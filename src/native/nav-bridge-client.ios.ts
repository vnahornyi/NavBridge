import type {EventSubscription} from 'react-native';

import NativeNavBridge, {type Spec} from '../../specs/NativeNavBridge';
import {
  fromNativeResult,
  fromNativeSnapshot,
  NativeBridgeContractError,
  toNativeCommand,
  type CommandResult,
  type SessionCommand,
  type SessionSnapshot,
} from './nav-bridge-types';

export type SessionUpdateListener = (snapshot: SessionSnapshot) => void;
export type BridgeErrorListener = (error: Error) => void;

export function createNavBridgeClient(nativeModule: Spec) {
  return {
    async getSnapshot(): Promise<SessionSnapshot> {
      return fromNativeSnapshot(await nativeModule.getSnapshot());
    },

    async dispatch(command: SessionCommand): Promise<CommandResult> {
      return fromNativeResult(await nativeModule.dispatchCommand(toNativeCommand(command)));
    },

    subscribe(listener: SessionUpdateListener, onError: BridgeErrorListener): EventSubscription {
      let closed = false;
      let initialized = false;
      let lastSequence = -1;
      const buffered: Parameters<typeof fromNativeSnapshot>[0][] = [];

      const report = (error: unknown) => {
        onError(error instanceof Error ? error : new NativeBridgeContractError(String(error)));
      };

      const deliver = (dto: Parameters<typeof fromNativeSnapshot>[0]) => {
        try {
          const snapshot = fromNativeSnapshot(dto);
          if (snapshot.sequence <= lastSequence) {
            return;
          }
          lastSequence = snapshot.sequence;
          listener(snapshot);
        } catch (error) {
          report(error);
        }
      };

      const nativeSubscription = nativeModule.onSessionUpdate(dto => {
        if (closed) {
          return;
        }
        if (!initialized) {
          buffered.push(dto);
          return;
        }
        deliver(dto);
      });

      void nativeModule.getSnapshot().then(
        snapshot => {
          if (closed) {
            return;
          }
          const initialSnapshots = [...buffered, snapshot].sort((left, right) => left.sequence - right.sequence);
          for (const initialSnapshot of initialSnapshots) {
            deliver(initialSnapshot);
          }
          initialized = true;
          buffered.length = 0;
        },
        error => {
          if (closed) {
            return;
          }
          initialized = true;
          for (const update of buffered.sort((left, right) => left.sequence - right.sequence)) {
            deliver(update);
          }
          buffered.length = 0;
          report(error);
        },
      );

      return {
        remove() {
          closed = true;
          buffered.length = 0;
          nativeSubscription.remove();
        },
      };
    },
  };
}

const navBridgeClient = createNavBridgeClient(NativeNavBridge);

export default navBridgeClient;
