import type {Spec} from '../../../specs/NativeNavBridge';

import {createNavBridgeClient} from '../nav-bridge-client.ios';
import type {NativeSessionSnapshot} from '../../../specs/NativeNavBridge';

jest.mock('../../../specs/NativeNavBridge', () => ({
  __esModule: true,
  default: {},
}));

function snapshot(sequence: number, phase = 'idle'): NativeSessionSnapshot {
  return {
    phase,
    sessionId: null,
    generation: 0,
    sequence,
    inputState: 'unavailable',
    outputState: 'unavailable',
    latitudeDeg: null,
    longitudeDeg: null,
    headingDeg: null,
    speedMps: null,
    outputAcknowledgement: 'none',
    errorCode: null,
    cleanupErrorCode: null,
    recoveryCategory: null,
  };
}

function fakeNativeModule() {
  const listeners = new Set<(value: NativeSessionSnapshot) => void>();
  let resolveSnapshot: ((value: NativeSessionSnapshot) => void) | undefined;
  let rejectSnapshot: ((reason: Error) => void) | undefined;
  const getSnapshot = jest.fn(
    () =>
      new Promise<NativeSessionSnapshot>((resolve, reject) => {
        resolveSnapshot = resolve;
        rejectSnapshot = reject;
      }),
  );
  const dispatchCommand = jest.fn();
  const module = {
    onSessionUpdate(listener: (value: NativeSessionSnapshot) => void) {
      listeners.add(listener);
      return {remove: () => listeners.delete(listener)};
    },
    getSnapshot,
    dispatchCommand,
  } as unknown as Spec;

  return {
    module,
    emit(value: NativeSessionSnapshot) {
      listeners.forEach(listener => listener(value));
    },
    resolveSnapshot(value: NativeSessionSnapshot) {
      resolveSnapshot?.(value);
    },
    rejectSnapshot(error: Error) {
      rejectSnapshot?.(error);
    },
    dispatchCommand,
    get listenerCount() {
      return listeners.size;
    },
  };
}

describe('NavBridge client', () => {
  it('subscribes before reading the initial snapshot and delivers buffered updates in sequence order', async () => {
    const native = fakeNativeModule();
    const client = createNavBridgeClient(native.module);
    const received: number[] = [];
    const onError = jest.fn();

    client.subscribe(value => received.push(value.sequence), onError);
    native.emit(snapshot(3, 'active'));
    native.emit(snapshot(2, 'preparing'));
    native.resolveSnapshot(snapshot(1));

    await Promise.resolve();

    expect(native.module.getSnapshot).toHaveBeenCalledTimes(1);
    expect(received).toEqual([1, 2, 3]);
    expect(onError).not.toHaveBeenCalled();
  });

  it('ignores duplicate and stale sequence numbers after initialization', async () => {
    const native = fakeNativeModule();
    const client = createNavBridgeClient(native.module);
    const received: number[] = [];

    client.subscribe(value => received.push(value.sequence), jest.fn());
    native.resolveSnapshot(snapshot(4));
    await Promise.resolve();
    native.emit(snapshot(4, 'active'));
    native.emit(snapshot(3));
    native.emit(snapshot(5, 'active'));

    expect(received).toEqual([4, 5]);
  });

  it('removes the native listener and ignores a snapshot that resolves after removal', async () => {
    const native = fakeNativeModule();
    const client = createNavBridgeClient(native.module);
    const listener = jest.fn();

    const subscription = client.subscribe(listener, jest.fn());
    subscription.remove();
    native.resolveSnapshot(snapshot(1));
    await Promise.resolve();
    native.emit(snapshot(2));

    expect(native.listenerCount).toBe(0);
    expect(listener).not.toHaveBeenCalled();
  });

  it('flattens partial corrections into the Codegen command DTO', async () => {
    const native = fakeNativeModule();
    const client = createNavBridgeClient(native.module);
    native.dispatchCommand.mockResolvedValue({
      requestId: 'correct-1',
      outcome: 'accepted',
      snapshot: snapshot(4, 'correcting'),
      errorCode: null,
    });

    await client.dispatch({
      kind: 'correct',
      requestId: 'correct-1',
      sessionId: 'session-1',
      correction: {position: {latitudeDeg: 38, longitudeDeg: -121}},
    });

    expect(native.dispatchCommand).toHaveBeenCalledWith({
      kind: 'correct',
      requestId: 'correct-1',
      sessionId: 'session-1',
      latitudeDeg: 38,
      longitudeDeg: -121,
      headingDeg: null,
      origin: 'manual',
    });
  });

  it('reports snapshot failure and continues delivering buffered and later updates', async () => {
    const native = fakeNativeModule();
    const client = createNavBridgeClient(native.module);
    const received: number[] = [];
    const onError = jest.fn();

    client.subscribe(value => received.push(value.sequence), onError);
    native.emit(snapshot(2, 'active'));
    native.rejectSnapshot(new Error('snapshot unavailable'));
    await Promise.resolve();
    native.emit(snapshot(3, 'stopping'));

    expect(received).toEqual([2, 3]);
    expect(onError).toHaveBeenCalledWith(expect.objectContaining({message: 'snapshot unavailable'}));
  });
});
