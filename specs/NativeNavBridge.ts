import type {CodegenTypes, TurboModule} from 'react-native';
import {TurboModuleRegistry} from 'react-native';

export type NativeSessionSnapshot = {
  phase: string;
  sessionId: string | null;
  generation: number;
  sequence: number;
  inputState: string;
  outputState: string;
  latitudeDeg: number | null;
  longitudeDeg: number | null;
  headingDeg: number | null;
  speedMps: number | null;
  outputAcknowledgement: string;
  errorCode: string | null;
  cleanupErrorCode: string | null;
  recoveryCategory: string | null;
};

export type NativeSessionCommand = {
  kind: string;
  requestId: string;
  sessionId: string | null;
  latitudeDeg: number | null;
  longitudeDeg: number | null;
  headingDeg: number | null;
  origin: string | null;
};

export type NativeCommandResult = {
  requestId: string;
  outcome: string;
  snapshot: NativeSessionSnapshot;
  errorCode: string | null;
};

export interface Spec extends TurboModule {
  readonly onSessionUpdate: CodegenTypes.EventEmitter<NativeSessionSnapshot>;
  getSnapshot(): Promise<NativeSessionSnapshot>;
  dispatchCommand(command: NativeSessionCommand): Promise<NativeCommandResult>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('NativeNavBridge');
