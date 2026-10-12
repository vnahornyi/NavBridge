import type {
  NativeCommandResult,
  NativeSessionCommand,
  NativeSessionSnapshot,
} from '../../specs/NativeNavBridge';

export const sessionPhases = [
  'idle',
  'preparing',
  'active',
  'correcting',
  'stopping',
  'faulted',
  'cleanupRequired',
] as const;

export const sourceStates = ['unavailable', 'connecting', 'valid', 'stale', 'failed'] as const;

export const outputAcknowledgements = ['none', 'pending', 'confirmed', 'failed', 'unknown', 'cleared'] as const;

export type SessionPhase = (typeof sessionPhases)[number];
export type SourceState = (typeof sourceStates)[number];
export type OutputAcknowledgement = (typeof outputAcknowledgements)[number];

export type SessionSnapshot = Readonly<{
  phase: SessionPhase;
  sessionId: string | null;
  generation: number;
  sequence: number;
  inputState: SourceState;
  outputState: SourceState;
  position: Readonly<{latitudeDeg: number; longitudeDeg: number}> | null;
  headingDeg: number | null;
  speedMps: number | null;
  outputAcknowledgement: OutputAcknowledgement;
  errorCode: string | null;
  cleanupErrorCode: string | null;
  recoveryCategory: string | null;
}>;

export type AnchorInput = Readonly<{
  latitudeDeg: number;
  longitudeDeg: number;
  headingDeg: number;
  origin: 'manual' | 'trusted-pre-session';
}>;

export type CorrectionInput = Readonly<{
  position?: Readonly<{latitudeDeg: number; longitudeDeg: number}>;
  headingDeg?: number;
}>;

export type SessionCommand =
  | Readonly<{kind: 'start'; requestId: string; anchor: AnchorInput}>
  | Readonly<{kind: 'correct'; requestId: string; sessionId: string; correction: CorrectionInput}>
  | Readonly<{kind: 'stop'; requestId: string; sessionId: string}>
  | Readonly<{kind: 'retry-cleanup'; requestId: string}>;

export type CommandOutcome = 'accepted' | 'rejected' | 'duplicate';

export type CommandResult = Readonly<{
  requestId: string;
  outcome: CommandOutcome;
  snapshot: SessionSnapshot;
  errorCode: string | null;
}>;

export class NativeBridgeContractError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'NativeBridgeContractError';
  }
}

export function toNativeCommand(command: SessionCommand): NativeSessionCommand {
  const empty: Omit<NativeSessionCommand, 'kind' | 'requestId'> = {
    sessionId: null,
    latitudeDeg: null,
    longitudeDeg: null,
    headingDeg: null,
    origin: null,
  };

  switch (command.kind) {
    case 'start':
      return {
        ...empty,
        kind: command.kind,
        requestId: command.requestId,
        latitudeDeg: command.anchor.latitudeDeg,
        longitudeDeg: command.anchor.longitudeDeg,
        headingDeg: command.anchor.headingDeg,
        origin: command.anchor.origin,
      };
    case 'correct':
      return {
        ...empty,
        kind: command.kind,
        requestId: command.requestId,
        sessionId: command.sessionId,
        latitudeDeg: command.correction.position?.latitudeDeg ?? null,
        longitudeDeg: command.correction.position?.longitudeDeg ?? null,
        headingDeg: command.correction.headingDeg ?? null,
        origin: 'manual',
      };
    case 'stop':
      return {
        ...empty,
        kind: command.kind,
        requestId: command.requestId,
        sessionId: command.sessionId,
      };
    case 'retry-cleanup':
      return {
        ...empty,
        kind: command.kind,
        requestId: command.requestId,
      };
  }
}

export function fromNativeSnapshot(dto: NativeSessionSnapshot): SessionSnapshot {
  if (!isOneOf(sessionPhases, dto.phase)) {
    throw new NativeBridgeContractError(`Unknown native session phase: ${dto.phase}`);
  }
  if (!isOneOf(sourceStates, dto.inputState) || !isOneOf(sourceStates, dto.outputState)) {
    throw new NativeBridgeContractError('Unknown native source state');
  }
  if (!isOneOf(outputAcknowledgements, dto.outputAcknowledgement)) {
    throw new NativeBridgeContractError(`Unknown output acknowledgement: ${dto.outputAcknowledgement}`);
  }
  if (!isSafeCounter(dto.generation) || !isSafeCounter(dto.sequence)) {
    throw new NativeBridgeContractError('Native generation and sequence must be non-negative safe integers');
  }

  const hasLatitude = dto.latitudeDeg !== null;
  const hasLongitude = dto.longitudeDeg !== null;
  if (hasLatitude !== hasLongitude) {
    throw new NativeBridgeContractError('Native snapshot contains a partial position');
  }

  let position: SessionSnapshot['position'] = null;
  if (dto.latitudeDeg !== null && dto.longitudeDeg !== null) {
    const latitudeDeg = requireFinite(dto.latitudeDeg, 'latitude');
    const longitudeDeg = requireFinite(dto.longitudeDeg, 'longitude');
    if (latitudeDeg < -90 || latitudeDeg > 90 || longitudeDeg < -180 || longitudeDeg > 180) {
      throw new NativeBridgeContractError('Native snapshot position is out of range');
    }
    position = {latitudeDeg, longitudeDeg};
  }

  const headingDeg = dto.headingDeg === null ? null : requireHeading(dto.headingDeg);
  const speedMps = dto.speedMps === null ? null : requireFinite(dto.speedMps, 'speed');
  if (speedMps !== null && speedMps < 0) {
    throw new NativeBridgeContractError('Native snapshot speed cannot be negative');
  }

  return {
    phase: dto.phase,
    sessionId: dto.sessionId,
    generation: dto.generation,
    sequence: dto.sequence,
    inputState: dto.inputState,
    outputState: dto.outputState,
    position,
    headingDeg,
    speedMps,
    outputAcknowledgement: dto.outputAcknowledgement,
    errorCode: dto.errorCode,
    cleanupErrorCode: dto.cleanupErrorCode,
    recoveryCategory: dto.recoveryCategory,
  };
}

export function fromNativeResult(dto: NativeCommandResult): CommandResult {
  if (!isOneOf(['accepted', 'rejected', 'duplicate'] as const, dto.outcome)) {
    throw new NativeBridgeContractError(`Unknown native command outcome: ${dto.outcome}`);
  }
  return {
    requestId: dto.requestId,
    outcome: dto.outcome,
    snapshot: fromNativeSnapshot(dto.snapshot),
    errorCode: dto.errorCode,
  };
}

function isOneOf<const T extends readonly string[]>(values: T, value: string): value is T[number] {
  return values.includes(value);
}

function isSafeCounter(value: number): boolean {
  return Number.isSafeInteger(value) && value >= 0;
}

function requireFinite(value: number, field: string): number {
  if (!Number.isFinite(value)) {
    throw new NativeBridgeContractError(`Native snapshot ${field} must be finite`);
  }
  return value;
}

function requireHeading(value: number): number {
  const headingDeg = requireFinite(value, 'heading');
  if (headingDeg < 0 || headingDeg >= 360) {
    throw new NativeBridgeContractError('Native snapshot heading is out of range');
  }
  return headingDeg;
}
