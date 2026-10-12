import Foundation

public actor SessionCoordinator {
  public static let shared = SessionCoordinator(effectRunner: unavailableEffectRunner)

  public static let unavailableEffectRunner: SessionEffectRunner = { effect in
    switch effect {
    case .prepare:
      return .preparationFailed("transportUnavailable")
    case .setOutput:
      return .outputFailed("transportUnavailable")
    case .clearOutput:
      return .outputClearUnknown("outputClearUnavailable")
    }
  }

  private var machine = SessionMachine()
  private let effectRunner: SessionEffectRunner
  private var continuations: [UUID: AsyncStream<SessionSnapshot>.Continuation] = [:]
  private var effectQueue: [SessionEffect] = []
  private var isProcessingEffects = false

  public init(effectRunner: @escaping SessionEffectRunner = SessionCoordinator.unavailableEffectRunner) {
    self.effectRunner = effectRunner
  }

  public func snapshot() -> SessionSnapshot {
    machine.snapshot
  }

  public func dispatch(_ command: SessionCommand) -> CommandResult {
    let before = machine.snapshot.sequence
    let transition = machine.dispatch(command, assignedSessionId: UUID().uuidString)
    if machine.snapshot.sequence != before {
      publish(machine.snapshot)
    }
    enqueue(transition.effects)
    return transition.result
  }

  public func updates() -> AsyncStream<SessionSnapshot> {
    let id = UUID()
    let pair = AsyncStream<SessionSnapshot>.makeStream()
    continuations[id] = pair.continuation
    pair.continuation.yield(machine.snapshot)
    pair.continuation.onTermination = { [weak self] _ in
      Task { await self?.removeContinuation(id) }
    }
    return pair.stream
  }

  private func removeContinuation(_ id: UUID) {
    continuations[id] = nil
  }

  private func publish(_ snapshot: SessionSnapshot) {
    for continuation in continuations.values {
      continuation.yield(snapshot)
    }
  }

  private func enqueue(_ effects: [SessionEffect]) {
    effectQueue.append(contentsOf: effects)
    guard !isProcessingEffects, !effectQueue.isEmpty else { return }
    isProcessingEffects = true
    Task { await drainEffects() }
  }

  private func drainEffects() async {
    while !effectQueue.isEmpty {
      let effect = effectQueue.removeFirst()
      guard machine.shouldExecute(effect) else { continue }
      let result = await effectRunner(effect)
      let previousSequence = machine.snapshot.sequence
      let followUpEffects = machine.complete(effect, with: result)
      if machine.snapshot.sequence != previousSequence {
        publish(machine.snapshot)
      }
      effectQueue.append(contentsOf: followUpEffects)
    }
    isProcessingEffects = false
  }
}
