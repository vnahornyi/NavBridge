# Contracts

**Status: proposed design, not implemented interfaces.** NB-002 must validate the wire representation with React Native 0.87.1 Codegen and the actual Swift target. The conceptual types below express semantics; a Codegen-compatible transport may use flatter records plus conversion and exhaustive validation.

## Units and ownership

| Value | Canonical representation | Owner |
|---|---|---|
| Geographic position | WGS 84 latitude/longitude degrees | Confirmed anchor / estimator |
| Vehicle heading | Degrees clockwise from true north, normalized to a full turn | User-confirmed heading + relative yaw |
| Raw rotation | Radians/second in device axes | CoreMotion |
| Canonical yaw rate | Radians/second clockwise around local down | Native motion conversion |
| Speed | Meters/second with explicit validity | OBD decoder and normalizer |
| Time | Session-relative monotonic milliseconds | Native clock mapping |
| Ordering | Increasing sequence plus session ID and generation | Native session |
| Wall time | Optional UTC metadata for display/export | Recorder; never integration time |

Units are part of field names. Zero is a valid measurement; unavailable is a distinct state. Validate finite numbers, geographic range, monotonic ordering, enum membership, and schema version at ingestion. Product quality thresholds are separate, measured configuration; no implicit default establishes suitability.

## Conceptual command boundary

```ts
type Anchor = {
  latitudeDeg: number;
  longitudeDeg: number;
  headingDeg: number;
  origin: 'manual' | 'trusted-pre-session';
};
type Correction = {
  position?: { latitudeDeg: number; longitudeDeg: number };
  headingDeg?: number;
  origin: 'manual';
};
type SessionCommand =
  | { kind: 'start'; requestId: string; anchor: Anchor }
  | { kind: 'correct'; requestId: string; sessionId: string; correction: Correction }
  | { kind: 'stop'; requestId: string; sessionId: string }
  | { kind: 'retry-cleanup'; requestId: string };
```

Start, correction, and Stop are asynchronous. A correction must contain a position and/or heading; reject an empty correction. Omitted fields retain their current value. A result acknowledges a defined transition or reports a structured failure. Duplicate request IDs do not create duplicate effects; session IDs prevent a stale UI from controlling a newer session. Setup methods (permissions, pairing, device selection, VPN consent) are separate from live-session commands.

## Snapshot boundary

```ts
type SessionPhase =
  | 'idle' | 'preparing' | 'active' | 'correcting' | 'stopping'
  | 'faulted' | 'cleanupRequired';
type SourceState = 'unavailable' | 'connecting' | 'valid' | 'stale' | 'failed';
```

A snapshot carries phase, session ID when present, generation, event sequence, quality states, optional position/heading/speed, last confirmed output acknowledgement, and structured error/recovery details. Missing values remain absent. `active` requires satisfied input/output prerequisites; it is never inferred solely from VPN connection status. A UI reconnect fetches a fresh snapshot and then subscribes without losing an intervening update.

Snapshot cadence is a measured presentation setting, independent of native sensor/output rates. Events crossing the bridge are bounded summaries, not every raw IMU frame. Native state is authoritative; JS does not write a second estimator or clear state by optimistic assumption.

## Errors

| Code family | Examples | UI behavior |
|---|---|---|
| Setup | Permission denied, pairing absent, signing/configuration failure | Explain prerequisite and allow a specific recovery action |
| Tunnel/output | Tunnel unavailable, session handshake failure, set failed | Stop active movement and show transport recovery |
| Input | OBD framing/timeout, unsupported PID, IMU absent/stale | Show unavailable input; never substitute zero |
| Command | Invalid anchor, stale session, conflicting request | Keep authoritative snapshot; show correctable reason |
| Cleanup | Clear failed or acknowledgement unknown | `cleanupRequired`, retry action, no success claim |
| Record/replay | Unsupported version, corrupt record, storage full | Preserve core session policy; report recording separately |

Errors contain a stable code, recovery category, and redacted diagnostic context. Human-readable text is not the machine contract. Pairing contents and real coordinates are excluded from default diagnostic text.

## Recording contract

Proposed format: UTF-8 JSON Lines with one metadata record followed by ordered events. `schemaVersion: 1` is a format design choice, not a product threshold.

```json
{"kind":"metadata","schemaVersion":1,"synthetic":true,"clock":"session-monotonic-ms","units":{"speed":"m/s","rotation":"rad/s","position":"WGS84-deg"}}
{"kind":"anchor","sequence":1,"atMs":0,"generation":1,"latitudeDeg":0,"longitudeDeg":0,"headingDeg":90,"origin":"manual"}
{"kind":"speed","sequence":2,"atMs":0,"generation":1,"speedMps":10,"validity":"valid"}
```

The example is synthetic illustration, not a recorded trip or a completed fixture. Implement explicit event variants for raw OBD fragments, normalized speed, raw/normalized motion, correction, lifecycle/permission/transport changes, output requests/acknowledgements, Stop, and cleanup. Preserve source timestamps plus mapping metadata so later replay does not invent sample times.

Each session records its configuration revision, app/core version, source provenance, mount/calibration metadata, and measurement quality. Reference trajectory records are separately tagged and never injected as estimator input during blind replay. Real identifiers and coordinates require controlled export.

Unknown required event kinds or schema versions fail loudly. A truncated final record has an explicit incomplete-session result; it must not become an apparent pass. Compatibility/migration policy is finalized before the first real recording in NB-007.
