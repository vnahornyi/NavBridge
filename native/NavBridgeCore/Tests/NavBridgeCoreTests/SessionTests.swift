import XCTest
@testable import NavBridgeCore

final class SessionTests: XCTestCase {
  func testRejectsNonFiniteAnchorWithoutProducingEffects() {
    var machine = SessionMachine()
    let transition = machine.dispatch(
      .start(requestId: "start-1", anchor: AnchorInput(latitudeDeg: .nan, longitudeDeg: 0, headingDeg: 90, origin: "manual")),
      assignedSessionId: "session-1"
    )

    XCTAssertEqual(transition.result.errorCode, "invalidAnchor")
    XCTAssertEqual(transition.result.snapshot.phase, .idle)
    XCTAssertTrue(transition.effects.isEmpty)
  }

  func testDuplicateRequestDoesNotRepeatEffects() {
    var machine = SessionMachine()
    let command = SessionCommand.start(
      requestId: "start-1",
      anchor: AnchorInput(latitudeDeg: 37, longitudeDeg: -122, headingDeg: 90, origin: "manual")
    )

    let first = machine.dispatch(command, assignedSessionId: "session-1")
    let duplicate = machine.dispatch(command, assignedSessionId: "session-2")

    XCTAssertEqual(first.result.outcome, .accepted)
    XCTAssertEqual(duplicate.result.outcome, .duplicate)
    XCTAssertTrue(duplicate.effects.isEmpty)
    XCTAssertEqual(duplicate.result.snapshot.sessionId, "session-1")
  }

  func testSessionBecomesActiveOnlyAfterPreparationAndOutputAcknowledgements() {
    var machine = SessionMachine()
    let start = machine.dispatch(
      .start(requestId: "start-1", anchor: anchor()),
      assignedSessionId: "session-1"
    )
    let setEffects = machine.complete(start.effects[0], with: .prepared)

    XCTAssertEqual(machine.snapshot.phase, .preparing)
    XCTAssertEqual(machine.snapshot.inputState, .valid)
    XCTAssertEqual(setEffects.count, 1)

    _ = machine.complete(setEffects[0], with: .outputSet)

    XCTAssertEqual(machine.snapshot.phase, .active)
    XCTAssertEqual(machine.snapshot.outputAcknowledgement, .confirmed)
    XCTAssertEqual(machine.snapshot.latitudeDeg, 37)
    XCTAssertEqual(machine.snapshot.headingDeg, 90)
  }

  func testSnapshotSequenceAdvancesForStateTransitionsAndIgnoresStaleSessionCommands() throws {
    var machine = SessionMachine()
    let start = machine.dispatch(
      .start(requestId: "start-1", anchor: anchor()),
      assignedSessionId: "session-1"
    )
    XCTAssertEqual(machine.snapshot.sequence, 1)

    let prepared = machine.complete(start.effects[0], with: .prepared)
    XCTAssertEqual(machine.snapshot.sequence, 2)
    _ = machine.complete(prepared[0], with: .outputSet)
    XCTAssertEqual(machine.snapshot.sequence, 3)

    let staleCorrection = machine.dispatch(
      .correct(
        requestId: "correct-stale",
        sessionId: "old-session",
        correction: CorrectionInput(latitudeDeg: nil, longitudeDeg: nil, headingDeg: 180, origin: "manual")
      ),
      assignedSessionId: "unused"
    )
    let staleStop = machine.dispatch(
      .stop(requestId: "stop-stale", sessionId: "old-session"),
      assignedSessionId: "unused"
    )

    XCTAssertEqual(staleCorrection.result.errorCode, "staleSession")
    XCTAssertEqual(staleStop.result.errorCode, "staleSession")
    XCTAssertTrue(staleCorrection.effects.isEmpty)
    XCTAssertTrue(staleStop.effects.isEmpty)
    XCTAssertEqual(machine.snapshot.sequence, 3)
    XCTAssertEqual(machine.snapshot.phase, .active)
  }

  func testEmptyCorrectionIsRejectedAndPositionOnlyCorrectionKeepsHeading() {
    var machine = activeMachine()
    let sessionId = try! XCTUnwrap(machine.snapshot.sessionId)
    let empty = machine.dispatch(
      .correct(
        requestId: "correct-empty",
        sessionId: sessionId,
        correction: CorrectionInput(latitudeDeg: nil, longitudeDeg: nil, headingDeg: nil, origin: "manual")
      ),
      assignedSessionId: "unused"
    )

    XCTAssertEqual(empty.result.errorCode, "emptyCorrection")
    XCTAssertTrue(empty.effects.isEmpty)

    let positionOnly = machine.dispatch(
      .correct(
        requestId: "correct-position",
        sessionId: sessionId,
        correction: CorrectionInput(latitudeDeg: 38, longitudeDeg: -121, headingDeg: nil, origin: "manual")
      ),
      assignedSessionId: "unused"
    )
    _ = machine.complete(positionOnly.effects[0], with: .outputSet)

    XCTAssertEqual(machine.snapshot.latitudeDeg, 38)
    XCTAssertEqual(machine.snapshot.longitudeDeg, -121)
    XCTAssertEqual(machine.snapshot.headingDeg, 90)
  }

  func testRejectsPartialPositionAndRepeatedCorrectionWhileCorrectionIsPending() {
    var machine = activeMachine()
    let sessionId = try! XCTUnwrap(machine.snapshot.sessionId)
    let correction = machine.dispatch(
      .correct(
        requestId: "correct-1",
        sessionId: sessionId,
        correction: CorrectionInput(latitudeDeg: 38, longitudeDeg: -121, headingDeg: nil, origin: "manual")
      ),
      assignedSessionId: "unused"
    )
    let repeated = machine.dispatch(
      .correct(
        requestId: "correct-2",
        sessionId: sessionId,
        correction: CorrectionInput(latitudeDeg: nil, longitudeDeg: nil, headingDeg: 180, origin: "manual")
      ),
      assignedSessionId: "unused"
    )

    XCTAssertEqual(repeated.result.errorCode, "commandConflict")
    XCTAssertTrue(repeated.effects.isEmpty)

    let stop = machine.dispatch(.stop(requestId: "stop-1", sessionId: sessionId), assignedSessionId: "unused")
    XCTAssertFalse(machine.shouldExecute(correction.effects[0]))
    XCTAssertEqual(stop.effects.count, 1)
    XCTAssertEqual(stop.effects[0].token.generation, machine.snapshot.generation)
  }

  func testStopDuringPreparationInvalidatesLateCallbackAndClears() {
    var machine = SessionMachine()
    let start = machine.dispatch(
      .start(requestId: "start-1", anchor: anchor()),
      assignedSessionId: "session-1"
    )
    let stop = machine.dispatch(.stop(requestId: "stop-1", sessionId: "session-1"), assignedSessionId: "unused")

    XCTAssertFalse(machine.shouldExecute(start.effects[0]))
    XCTAssertTrue(machine.complete(start.effects[0], with: .prepared).isEmpty)
    XCTAssertEqual(stop.effects.count, 1)

    _ = machine.complete(stop.effects[0], with: .outputCleared)

    XCTAssertEqual(machine.snapshot.phase, .idle)
    XCTAssertEqual(machine.snapshot.outputAcknowledgement, .cleared)
  }

  func testLateSetAfterStopCannotRestoreActiveState() {
    var machine = activeMachine()
    let sessionId = try! XCTUnwrap(machine.snapshot.sessionId)
    let correction = machine.dispatch(
      .correct(
        requestId: "correct-1",
        sessionId: sessionId,
        correction: CorrectionInput(latitudeDeg: 38, longitudeDeg: -121, headingDeg: nil, origin: "manual")
      ),
      assignedSessionId: "unused"
    )
    let stop = machine.dispatch(.stop(requestId: "stop-1", sessionId: sessionId), assignedSessionId: "unused")

    XCTAssertTrue(machine.complete(correction.effects[0], with: .outputSet).isEmpty)
    XCTAssertEqual(machine.snapshot.phase, .stopping)
    _ = machine.complete(stop.effects[0], with: .outputCleared)
    XCTAssertEqual(machine.snapshot.phase, .idle)
  }

  func testClearFailureRequiresCleanupAndPreservesOriginalError() {
    var machine = activeMachine()
    let sessionId = try! XCTUnwrap(machine.snapshot.sessionId)
    let correction = machine.dispatch(
      .correct(
        requestId: "correct-1",
        sessionId: sessionId,
        correction: CorrectionInput(latitudeDeg: nil, longitudeDeg: nil, headingDeg: 180, origin: "manual")
      ),
      assignedSessionId: "unused"
    )
    let clearEffects = machine.complete(correction.effects[0], with: .outputFailed("setFailed"))

    XCTAssertEqual(machine.snapshot.phase, .stopping)
    XCTAssertEqual(clearEffects.count, 1)

    _ = machine.complete(clearEffects[0], with: .outputClearUnknown("clearUnavailable"))

    XCTAssertEqual(machine.snapshot.phase, .cleanupRequired)
    XCTAssertEqual(machine.snapshot.errorCode, "setFailed")
    XCTAssertEqual(machine.snapshot.cleanupErrorCode, "clearUnavailable")
    XCTAssertEqual(machine.snapshot.recoveryCategory, "cleanup")
  }

  func testRetryCleanupReturnsToFaultedOnlyAfterConfirmedClear() {
    var machine = activeMachine()
    let sessionId = try! XCTUnwrap(machine.snapshot.sessionId)
    let stop = machine.dispatch(.stop(requestId: "stop-1", sessionId: sessionId), assignedSessionId: "unused")
    _ = machine.complete(stop.effects[0], with: .outputClearFailed("clearFailed"))
    let retry = machine.dispatch(.retryCleanup(requestId: "retry-1"), assignedSessionId: "unused")

    XCTAssertEqual(machine.snapshot.phase, .stopping)
    XCTAssertEqual(retry.effects.count, 1)
    _ = machine.complete(retry.effects[0], with: .outputCleared)

    XCTAssertEqual(machine.snapshot.phase, .faulted)
    XCTAssertEqual(machine.snapshot.errorCode, "cleanupUnconfirmed")
    XCTAssertNil(machine.snapshot.cleanupErrorCode)
  }

  func testCoordinatorSerializesPendingSetupStopAndCleanupEffects() async throws {
    let gate = EffectGate()
    let coordinator = SessionCoordinator(effectRunner: { effect in await gate.perform(effect) })
    var updates = await coordinator.updates().makeAsyncIterator()
    _ = await updates.next()

    let start = await coordinator.dispatch(.start(requestId: "start-1", anchor: anchor()))
    let prepare = await gate.nextEffect()
    XCTAssertEqual(start.snapshot.phase, .preparing)

    let stop = await coordinator.dispatch(.stop(requestId: "stop-1", sessionId: try XCTUnwrap(start.snapshot.sessionId)))
    XCTAssertEqual(stop.snapshot.phase, .stopping)
    await gate.completeNext(.prepared)

    let clear = await gate.nextEffect()
    guard case .clearOutput = clear else {
      return XCTFail("Stop must clear after the pending setup effect completes")
    }
    await gate.completeNext(.outputCleared)

    var finalSnapshot = await coordinator.snapshot()
    while finalSnapshot.phase != .idle {
      guard let next = await updates.next() else { return XCTFail("Snapshot stream ended") }
      finalSnapshot = next
    }
    XCTAssertEqual(prepare.token.sessionId, start.snapshot.sessionId)
    XCTAssertEqual(finalSnapshot.outputAcknowledgement, .cleared)
  }

  private func anchor() -> AnchorInput {
    AnchorInput(latitudeDeg: 37, longitudeDeg: -122, headingDeg: 90, origin: "manual")
  }

  private func activeMachine() -> SessionMachine {
    var machine = SessionMachine()
    let start = machine.dispatch(.start(requestId: "start-1", anchor: anchor()), assignedSessionId: "session-1")
    let setEffects = machine.complete(start.effects[0], with: .prepared)
    _ = machine.complete(setEffects[0], with: .outputSet)
    return machine
  }
}

private actor EffectGate {
  private var pendingEffects: [SessionEffect] = []
  private var effectWaiters: [CheckedContinuation<SessionEffect, Never>] = []
  private var resultWaiters: [CheckedContinuation<SessionEffectResult, Never>] = []

  func perform(_ effect: SessionEffect) async -> SessionEffectResult {
    await withCheckedContinuation { (continuation: CheckedContinuation<SessionEffectResult, Never>) in
      if effectWaiters.isEmpty {
        pendingEffects.append(effect)
      } else {
        effectWaiters.removeFirst().resume(returning: effect)
      }
      resultWaiters.append(continuation)
    }
  }

  func nextEffect() async -> SessionEffect {
    if !pendingEffects.isEmpty {
      return pendingEffects.removeFirst()
    }
    return await withCheckedContinuation { (continuation: CheckedContinuation<SessionEffect, Never>) in
      effectWaiters.append(continuation)
    }
  }

  func completeNext(_ result: SessionEffectResult) {
    resultWaiters.removeFirst().resume(returning: result)
  }
}
