import Foundation

public enum SessionPhase: String, Equatable, Sendable {
  case idle
  case preparing
  case active
  case correcting
  case stopping
  case faulted
  case cleanupRequired
}

public enum SourceState: String, Equatable, Sendable {
  case unavailable
  case connecting
  case valid
  case stale
  case failed
}

public enum OutputAcknowledgement: String, Equatable, Sendable {
  case none
  case pending
  case confirmed
  case failed
  case unknown
  case cleared
}

public struct SessionSnapshot: Equatable, Sendable {
  public var phase: SessionPhase
  public var sessionId: String?
  public var generation: Int
  public var sequence: Int
  public var inputState: SourceState
  public var outputState: SourceState
  public var latitudeDeg: Double?
  public var longitudeDeg: Double?
  public var headingDeg: Double?
  public var speedMps: Double?
  public var outputAcknowledgement: OutputAcknowledgement
  public var errorCode: String?
  public var cleanupErrorCode: String?
  public var recoveryCategory: String?

  public init(
    phase: SessionPhase = .idle,
    sessionId: String? = nil,
    generation: Int = 0,
    sequence: Int = 0,
    inputState: SourceState = .unavailable,
    outputState: SourceState = .unavailable,
    latitudeDeg: Double? = nil,
    longitudeDeg: Double? = nil,
    headingDeg: Double? = nil,
    speedMps: Double? = nil,
    outputAcknowledgement: OutputAcknowledgement = .none,
    errorCode: String? = nil,
    cleanupErrorCode: String? = nil,
    recoveryCategory: String? = nil
  ) {
    self.phase = phase
    self.sessionId = sessionId
    self.generation = generation
    self.sequence = sequence
    self.inputState = inputState
    self.outputState = outputState
    self.latitudeDeg = latitudeDeg
    self.longitudeDeg = longitudeDeg
    self.headingDeg = headingDeg
    self.speedMps = speedMps
    self.outputAcknowledgement = outputAcknowledgement
    self.errorCode = errorCode
    self.cleanupErrorCode = cleanupErrorCode
    self.recoveryCategory = recoveryCategory
  }
}

public struct AnchorInput: Equatable, Sendable {
  public let latitudeDeg: Double
  public let longitudeDeg: Double
  public let headingDeg: Double
  public let origin: String

  public init(latitudeDeg: Double, longitudeDeg: Double, headingDeg: Double, origin: String) {
    self.latitudeDeg = latitudeDeg
    self.longitudeDeg = longitudeDeg
    self.headingDeg = headingDeg
    self.origin = origin
  }
}

public struct CorrectionInput: Equatable, Sendable {
  public let latitudeDeg: Double?
  public let longitudeDeg: Double?
  public let headingDeg: Double?
  public let origin: String

  public init(
    latitudeDeg: Double?,
    longitudeDeg: Double?,
    headingDeg: Double?,
    origin: String
  ) {
    self.latitudeDeg = latitudeDeg
    self.longitudeDeg = longitudeDeg
    self.headingDeg = headingDeg
    self.origin = origin
  }
}

public enum SessionCommand: Equatable, Sendable {
  case start(requestId: String, anchor: AnchorInput)
  case correct(requestId: String, sessionId: String, correction: CorrectionInput)
  case stop(requestId: String, sessionId: String)
  case retryCleanup(requestId: String)

  public var requestId: String {
    switch self {
    case let .start(requestId, _), let .correct(requestId, _, _), let .stop(requestId, _), let .retryCleanup(requestId):
      return requestId
    }
  }
}

public enum CommandOutcome: String, Equatable, Sendable {
  case accepted
  case rejected
  case duplicate
}

public struct CommandResult: Equatable, Sendable {
  public let requestId: String
  public let outcome: CommandOutcome
  public let snapshot: SessionSnapshot
  public let errorCode: String?

  public init(requestId: String, outcome: CommandOutcome, snapshot: SessionSnapshot, errorCode: String?) {
    self.requestId = requestId
    self.outcome = outcome
    self.snapshot = snapshot
    self.errorCode = errorCode
  }
}

public struct SessionToken: Equatable, Hashable, Sendable {
  public let sessionId: String
  public let generation: Int

  public init(sessionId: String, generation: Int) {
    self.sessionId = sessionId
    self.generation = generation
  }
}

public enum SessionEffect: Equatable, Sendable {
  case prepare(token: SessionToken, anchor: AnchorInput)
  case setOutput(token: SessionToken, latitudeDeg: Double, longitudeDeg: Double, headingDeg: Double)
  case clearOutput(token: SessionToken)

  public var token: SessionToken {
    switch self {
    case let .prepare(token, _), let .setOutput(token, _, _, _), let .clearOutput(token):
      return token
    }
  }
}

public enum SessionEffectResult: Equatable, Sendable {
  case prepared
  case preparationFailed(String)
  case outputSet
  case outputFailed(String)
  case outputCleared
  case outputClearFailed(String)
  case outputClearUnknown(String)
}

public typealias SessionEffectRunner = @Sendable (SessionEffect) async -> SessionEffectResult

public struct SessionTransition: Equatable, Sendable {
  public let result: CommandResult
  public let effects: [SessionEffect]

  public init(result: CommandResult, effects: [SessionEffect]) {
    self.result = result
    self.effects = effects
  }
}
