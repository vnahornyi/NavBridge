import Foundation

public struct SessionMachine: Sendable {
  private struct Anchor: Equatable, Sendable {
    let latitudeDeg: Double
    let longitudeDeg: Double
    let headingDeg: Double
    let origin: String
  }

  public private(set) var snapshot = SessionSnapshot()
  private var anchor: Anchor?
  private var seenRequestIds = Set<String>()

  public init() {}

  public mutating func dispatch(_ command: SessionCommand, assignedSessionId: String) -> SessionTransition {
    let requestId = command.requestId
    guard !requestId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      return transition(requestId, .rejected, errorCode: "invalidRequestId")
    }
    guard seenRequestIds.insert(requestId).inserted else {
      return transition(requestId, .duplicate, errorCode: nil)
    }

    switch command {
    case let .start(_, input):
      return start(requestId, input, assignedSessionId)
    case let .correct(_, sessionId, input):
      return correct(requestId, sessionId, input)
    case let .stop(_, sessionId):
      return stop(requestId, sessionId)
    case .retryCleanup:
      return retryCleanup(requestId)
    }
  }

  public mutating func complete(_ effect: SessionEffect, with result: SessionEffectResult) -> [SessionEffect] {
    guard effect.token == currentToken else { return [] }

    switch (effect, result) {
    case (.prepare, .prepared) where snapshot.phase == .preparing:
      guard let anchor else { return failCurrentSession("missingAnchor", category: "setup") }
      update {
        $0.inputState = .valid
        $0.outputState = .connecting
        $0.outputAcknowledgement = .pending
      }
      return [
        .setOutput(
          token: currentToken,
          latitudeDeg: anchor.latitudeDeg,
          longitudeDeg: anchor.longitudeDeg,
          headingDeg: anchor.headingDeg
        ),
      ]

    case let (.prepare, .preparationFailed(errorCode)) where snapshot.phase == .preparing:
      update {
        $0.phase = .faulted
        $0.inputState = .failed
        $0.outputState = .unavailable
        $0.outputAcknowledgement = .none
        $0.errorCode = errorCode
        $0.recoveryCategory = "setup"
      }
      return []

    case (.setOutput, .outputSet) where snapshot.phase == .preparing || snapshot.phase == .correcting:
      guard let confirmedAnchor = anchor else { return failCurrentSession("missingAnchor", category: "output") }
      update {
        $0.phase = .active
        $0.outputState = .valid
        $0.outputAcknowledgement = .confirmed
        $0.errorCode = nil
        $0.cleanupErrorCode = nil
        $0.recoveryCategory = nil
        $0.latitudeDeg = confirmedAnchor.latitudeDeg
        $0.longitudeDeg = confirmedAnchor.longitudeDeg
        $0.headingDeg = confirmedAnchor.headingDeg
      }
      return []

    case let (.setOutput, .outputFailed(errorCode)) where snapshot.phase == .preparing || snapshot.phase == .correcting:
      update {
        $0.phase = .stopping
        $0.generation += 1
        $0.outputState = .failed
        $0.outputAcknowledgement = .unknown
        $0.errorCode = errorCode
        $0.recoveryCategory = "output"
      }
      return [.clearOutput(token: currentToken)]

    case (.clearOutput, .outputCleared) where snapshot.phase == .stopping || snapshot.phase == .cleanupRequired:
      update {
        $0.phase = $0.errorCode == nil ? .idle : .faulted
        $0.inputState = .unavailable
        $0.outputState = .unavailable
        $0.outputAcknowledgement = .cleared
        $0.cleanupErrorCode = nil
        $0.recoveryCategory = $0.errorCode == nil ? nil : $0.recoveryCategory
        if $0.phase == .idle {
          $0.sessionId = nil
          $0.latitudeDeg = nil
          $0.longitudeDeg = nil
          $0.headingDeg = nil
        }
      }
      anchor = nil
      return []

    case let (.clearOutput, .outputClearFailed(errorCode)) where snapshot.phase == .stopping || snapshot.phase == .cleanupRequired:
      return requireCleanup(errorCode, acknowledgement: .failed)

    case let (.clearOutput, .outputClearUnknown(errorCode)) where snapshot.phase == .stopping || snapshot.phase == .cleanupRequired:
      return requireCleanup(errorCode, acknowledgement: .unknown)

    default:
      return []
    }
  }

  public func shouldExecute(_ effect: SessionEffect) -> Bool {
    guard effect.token == currentToken else { return false }
    switch effect {
    case .prepare:
      return snapshot.phase == .preparing
    case .setOutput:
      return snapshot.phase == .preparing || snapshot.phase == .correcting
    case .clearOutput:
      return snapshot.phase == .stopping || snapshot.phase == .cleanupRequired
    }
  }

  private var currentToken: SessionToken {
    SessionToken(sessionId: snapshot.sessionId ?? "", generation: snapshot.generation)
  }

  private mutating func start(_ requestId: String, _ input: AnchorInput, _ assignedSessionId: String) -> SessionTransition {
    guard snapshot.phase == .idle || snapshot.phase == .faulted else {
      return transition(requestId, .rejected, errorCode: "commandConflict")
    }
    guard !assignedSessionId.isEmpty else {
      return transition(requestId, .rejected, errorCode: "invalidSessionId")
    }
    guard let validated = validate(input) else {
      return transition(requestId, .rejected, errorCode: "invalidAnchor")
    }

    anchor = validated
    update {
      $0.phase = .preparing
      $0.sessionId = assignedSessionId
      $0.generation += 1
      $0.inputState = .connecting
      $0.outputState = .unavailable
      $0.latitudeDeg = nil
      $0.longitudeDeg = nil
      $0.headingDeg = nil
      $0.speedMps = nil
      $0.outputAcknowledgement = .none
      $0.errorCode = nil
      $0.cleanupErrorCode = nil
      $0.recoveryCategory = nil
    }
    let effect = SessionEffect.prepare(token: currentToken, anchor: input)
    return SessionTransition(result: accepted(requestId), effects: [effect])
  }

  private mutating func correct(_ requestId: String, _ sessionId: String, _ input: CorrectionInput) -> SessionTransition {
    guard sessionId == snapshot.sessionId else {
      return transition(requestId, .rejected, errorCode: "staleSession")
    }
    guard snapshot.phase == .active else {
      return transition(requestId, .rejected, errorCode: "commandConflict")
    }
    guard input.origin == "manual", let current = anchor else {
      return transition(requestId, .rejected, errorCode: "invalidCorrection")
    }
    guard (input.latitudeDeg == nil) == (input.longitudeDeg == nil) else {
      return transition(requestId, .rejected, errorCode: "invalidCorrection")
    }
    guard input.latitudeDeg != nil || input.headingDeg != nil else {
      return transition(requestId, .rejected, errorCode: "emptyCorrection")
    }

    let latitude = input.latitudeDeg ?? current.latitudeDeg
    let longitude = input.longitudeDeg ?? current.longitudeDeg
    let heading = input.headingDeg ?? current.headingDeg
    guard isValidPosition(latitude, longitude), isValidHeading(heading) else {
      return transition(requestId, .rejected, errorCode: "invalidCorrection")
    }

    anchor = Anchor(latitudeDeg: latitude, longitudeDeg: longitude, headingDeg: heading, origin: "manual")
    update {
      $0.phase = .correcting
      $0.generation += 1
      $0.outputState = .connecting
      $0.outputAcknowledgement = .pending
      $0.errorCode = nil
      $0.cleanupErrorCode = nil
      $0.recoveryCategory = nil
    }
    let effect = SessionEffect.setOutput(
      token: currentToken,
      latitudeDeg: latitude,
      longitudeDeg: longitude,
      headingDeg: heading
    )
    return SessionTransition(result: accepted(requestId), effects: [effect])
  }

  private mutating func stop(_ requestId: String, _ sessionId: String) -> SessionTransition {
    guard sessionId == snapshot.sessionId else {
      return transition(requestId, .rejected, errorCode: "staleSession")
    }
    if snapshot.phase == .stopping {
      return transition(requestId, .accepted, errorCode: nil)
    }
    guard snapshot.phase != .idle && snapshot.phase != .cleanupRequired else {
      return transition(requestId, .rejected, errorCode: "commandConflict")
    }

    update {
      $0.phase = .stopping
      $0.generation += 1
      $0.outputState = .connecting
      if $0.outputAcknowledgement == .none {
        $0.outputAcknowledgement = .pending
      }
      if $0.errorCode == nil {
        $0.recoveryCategory = nil
      }
    }
    return SessionTransition(
      result: accepted(requestId),
      effects: [.clearOutput(token: currentToken)]
    )
  }

  private mutating func retryCleanup(_ requestId: String) -> SessionTransition {
    guard snapshot.phase == .cleanupRequired, let sessionId = snapshot.sessionId else {
      return transition(requestId, .rejected, errorCode: "commandConflict")
    }
    update {
      $0.phase = .stopping
      $0.generation += 1
      $0.outputState = .connecting
      $0.outputAcknowledgement = .pending
      $0.cleanupErrorCode = nil
    }
    return SessionTransition(
      result: accepted(requestId),
      effects: [.clearOutput(token: SessionToken(sessionId: sessionId, generation: snapshot.generation))]
    )
  }

  private mutating func requireCleanup(_ cleanupErrorCode: String, acknowledgement: OutputAcknowledgement) -> [SessionEffect] {
    update {
      $0.phase = .cleanupRequired
      $0.outputState = .failed
      $0.outputAcknowledgement = acknowledgement
      if $0.errorCode == nil {
        $0.errorCode = "cleanupUnconfirmed"
      }
      $0.cleanupErrorCode = cleanupErrorCode
      $0.recoveryCategory = "cleanup"
    }
    return []
  }

  private mutating func failCurrentSession(_ errorCode: String, category: String) -> [SessionEffect] {
    update {
      $0.phase = .faulted
      $0.errorCode = errorCode
      $0.recoveryCategory = category
    }
    return []
  }

  private func validate(_ input: AnchorInput) -> Anchor? {
    guard isValidPosition(input.latitudeDeg, input.longitudeDeg),
          isValidHeading(input.headingDeg),
          input.origin == "manual" || input.origin == "trusted-pre-session"
    else {
      return nil
    }
    return Anchor(
      latitudeDeg: input.latitudeDeg,
      longitudeDeg: input.longitudeDeg,
      headingDeg: input.headingDeg,
      origin: input.origin
    )
  }

  private func isValidPosition(_ latitudeDeg: Double, _ longitudeDeg: Double) -> Bool {
    latitudeDeg.isFinite && longitudeDeg.isFinite && latitudeDeg >= -90 && latitudeDeg <= 90 && longitudeDeg >= -180 && longitudeDeg <= 180
  }

  private func isValidHeading(_ headingDeg: Double) -> Bool {
    headingDeg.isFinite && headingDeg >= 0 && headingDeg < 360
  }

  private func accepted(_ requestId: String) -> CommandResult {
    CommandResult(requestId: requestId, outcome: .accepted, snapshot: snapshot, errorCode: nil)
  }

  private func transition(_ requestId: String, _ outcome: CommandOutcome, errorCode: String?) -> SessionTransition {
    SessionTransition(
      result: CommandResult(requestId: requestId, outcome: outcome, snapshot: snapshot, errorCode: errorCode),
      effects: []
    )
  }

  private mutating func update(_ body: (inout SessionSnapshot) -> Void) {
    var next = snapshot
    body(&next)
    guard next != snapshot else { return }
    next = SessionSnapshot(
      phase: next.phase,
      sessionId: next.sessionId,
      generation: next.generation,
      sequence: snapshot.sequence + 1,
      inputState: next.inputState,
      outputState: next.outputState,
      latitudeDeg: next.latitudeDeg,
      longitudeDeg: next.longitudeDeg,
      headingDeg: next.headingDeg,
      speedMps: next.speedMps,
      outputAcknowledgement: next.outputAcknowledgement,
      errorCode: next.errorCode,
      cleanupErrorCode: next.cleanupErrorCode,
      recoveryCategory: next.recoveryCategory
    )
    snapshot = next
  }
}
