import Foundation
import NavBridgeCore

@objc(NavBridgeSessionService)
final class NavBridgeSessionService: NSObject {
  @objc(shared)
  static let shared = NavBridgeSessionService()

  private static let core = NativeSessionBridgeCore()

  @objc(setUpdateHandler:)
  func setUpdateHandler(_ handler: @escaping ([String: Any]) -> Void) {
    let forwarder = SnapshotForwarder(handler: handler)
    Task {
      await Self.core.install(forwarder)
    }
  }

  @objc(getSnapshotWithResolve:reject:)
  func getSnapshot(
    resolve: @escaping ([String: Any]) -> Void,
    reject: @escaping (String, String, NSError?) -> Void
  ) {
    Task {
      let snapshot = await Self.core.snapshot()
      resolve(Self.dictionary(snapshot))
    }
  }

  @objc(dispatchCommand:resolve:reject:)
  func dispatchCommand(
    _ command: NSDictionary,
    resolve: @escaping ([String: Any]) -> Void,
    reject: @escaping (String, String, NSError?) -> Void
  ) {
    do {
      let parsedCommand = try Self.parse(command)
      Task {
        let result = await Self.core.dispatch(parsedCommand)
        resolve(Self.dictionary(result))
      }
    } catch {
      reject("invalidCommand", error.localizedDescription, error as NSError)
    }
  }

  private static func parse(_ command: NSDictionary) throws -> SessionCommand {
    let kind = try requiredString("kind", command)
    let requestId = try requiredString("requestId", command)

    switch kind {
    case "start":
      return .start(
        requestId: requestId,
        anchor: AnchorInput(
          latitudeDeg: try requiredDouble("latitudeDeg", command),
          longitudeDeg: try requiredDouble("longitudeDeg", command),
          headingDeg: try requiredDouble("headingDeg", command),
          origin: try requiredString("origin", command)
        )
      )
    case "correct":
      return .correct(
        requestId: requestId,
        sessionId: try requiredString("sessionId", command),
        correction: CorrectionInput(
          latitudeDeg: try optionalDouble("latitudeDeg", command),
          longitudeDeg: try optionalDouble("longitudeDeg", command),
          headingDeg: try optionalDouble("headingDeg", command),
          origin: try requiredString("origin", command)
        )
      )
    case "stop":
      return .stop(requestId: requestId, sessionId: try requiredString("sessionId", command))
    case "retry-cleanup":
      return .retryCleanup(requestId: requestId)
    default:
      throw NativeCommandParsingError.invalidField("kind")
    }
  }

  private static func requiredString(_ key: String, _ command: NSDictionary) throws -> String {
    guard let value = command[key] as? String, !value.isEmpty else {
      throw NativeCommandParsingError.invalidField(key)
    }
    return value
  }

  private static func requiredDouble(_ key: String, _ command: NSDictionary) throws -> Double {
    guard let value = command[key] as? NSNumber else {
      throw NativeCommandParsingError.invalidField(key)
    }
    let number = value.doubleValue
    guard number.isFinite else {
      throw NativeCommandParsingError.invalidField(key)
    }
    return number
  }

  private static func optionalDouble(_ key: String, _ command: NSDictionary) throws -> Double? {
    guard let value = command[key], !(value is NSNull) else { return nil }
    guard let number = value as? NSNumber, number.doubleValue.isFinite else {
      throw NativeCommandParsingError.invalidField(key)
    }
    return number.doubleValue
  }

  fileprivate static func dictionary(_ snapshot: SessionSnapshot) -> [String: Any] {
    [
      "phase": snapshot.phase.rawValue,
      "sessionId": snapshot.sessionId.map { $0 as Any } ?? NSNull(),
      "generation": snapshot.generation,
      "sequence": snapshot.sequence,
      "inputState": snapshot.inputState.rawValue,
      "outputState": snapshot.outputState.rawValue,
      "latitudeDeg": snapshot.latitudeDeg.map { $0 as Any } ?? NSNull(),
      "longitudeDeg": snapshot.longitudeDeg.map { $0 as Any } ?? NSNull(),
      "headingDeg": snapshot.headingDeg.map { $0 as Any } ?? NSNull(),
      "speedMps": snapshot.speedMps.map { $0 as Any } ?? NSNull(),
      "outputAcknowledgement": snapshot.outputAcknowledgement.rawValue,
      "errorCode": snapshot.errorCode.map { $0 as Any } ?? NSNull(),
      "cleanupErrorCode": snapshot.cleanupErrorCode.map { $0 as Any } ?? NSNull(),
      "recoveryCategory": snapshot.recoveryCategory.map { $0 as Any } ?? NSNull(),
    ]
  }

  private static func dictionary(_ result: CommandResult) -> [String: Any] {
    [
      "requestId": result.requestId,
      "outcome": result.outcome.rawValue,
      "snapshot": dictionary(result.snapshot),
      "errorCode": result.errorCode.map { $0 as Any } ?? NSNull(),
    ]
  }
}

private actor NativeSessionBridgeCore {
  private let coordinator = SessionCoordinator.shared
  private var streamCreation: Task<AsyncStream<SessionSnapshot>, Never>?
  private var streamForwarder: Task<Void, Never>?
  private var eventForwarder: SnapshotForwarder?

  func install(_ eventForwarder: SnapshotForwarder) async {
    self.eventForwarder = eventForwarder
    await ensureUpdates()
  }

  func snapshot() async -> SessionSnapshot {
    await ensureUpdates()
    return await coordinator.snapshot()
  }

  func dispatch(_ command: SessionCommand) async -> CommandResult {
    await ensureUpdates()
    return await coordinator.dispatch(command)
  }

  private func ensureUpdates() async {
    if streamCreation == nil {
      let coordinator = coordinator
      streamCreation = Task { await coordinator.updates() }
    }
    guard let stream = await streamCreation?.value else { return }
    guard streamForwarder == nil else { return }

    streamForwarder = Task { [weak self] in
      for await snapshot in stream {
        await self?.publish(snapshot)
      }
    }
  }

  private func publish(_ snapshot: SessionSnapshot) {
    eventForwarder?.emit(snapshot)
  }
}

private final class SnapshotForwarder: @unchecked Sendable {
  private let handler: ([String: Any]) -> Void

  init(handler: @escaping ([String: Any]) -> Void) {
    self.handler = handler
  }

  func emit(_ snapshot: SessionSnapshot) {
    DispatchQueue.main.async {
      self.handler(NavBridgeSessionService.dictionary(snapshot))
    }
  }
}

private enum NativeCommandParsingError: LocalizedError {
  case invalidField(String)

  var errorDescription: String? {
    switch self {
    case let .invalidField(field): return "Invalid native command field: \(field)"
    }
  }
}
