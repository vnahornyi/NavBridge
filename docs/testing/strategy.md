# Testing strategy

## Current state and authorization

Only the generated React render smoke test exists. No NavBridge behavioral tests, replay fixtures, device reports, or CI checks exist yet. This foundation designs them; it does not execute application tests or claim passes. Test implementation and execution belong to individually approved plans.

## Proof layers

| Layer | Responsibility | Primary cases | Cannot prove |
|---|---|---|---|
| Pure Swift unit tests | Session decisions, parsing, geometry, time | Invalid input, ordering, zero speed, turns, correction, gap, Stop/clear race | iOS scheduling or hardware compatibility |
| Deterministic replay | Same engine under ordered/faulted events | Synthetic truth, loss, delay, reconnect, late output | Field accuracy from synthetic data alone |
| Native integration tests | Bridge, wrappers, fake effect boundaries | Promise/events, lifecycle, cleanup and error translation | Real transport reliability if mocked |
| RN behavior tests | User commands and authoritative snapshots | Busy, failure, correction, cleanupRequired, accessibility | Native background execution |
| Simulator smoke | Build/link/UI states | Navigation, UI reload, dependency wiring | Physical BLE/Waze/CarPlay behavior |
| Device bench | Signing, VPN, pairing, speed/motion/output | Stationary live input, set/clear, permission and disconnect recovery | Driving drift without a reference |
| Vehicle/Waze field validation | Intended end-to-end behavior | Stops/turns/gaps, corrections, background, independent reference | Other cars/devices/iOS builds |
| CarPlay validation | Specific head unit and connection | Source selection, reconnect, Stop, foreground changes | All CarPlay configurations |

## Unit and integration design

The pure core accepts explicit input events and a controllable monotonic clock. It returns decisions/effects rather than directly touching BLE or VPN. Test effects at the native orchestration boundary, including callbacks that arrive after cancellation. The harness reuses these production decisions and does not contain another estimator written just to produce the expected answer.

Normalize units once. Test non-finite numbers, range errors, timestamp mappings, duplicate/out-of-order events, session/generation mismatch, stale data and clock gaps. Test valid zero separately from missing data. Test raw BLE fragmentation independently of normalized estimator input.

For geometry use analytic straight/turn/zero-motion cases and independently derived expectations, with a justified numerical tolerance. Do not calculate expected results by calling the function under test. Keep floating-point reproducibility scope and compiler/toolchain in the report.

## RN tests and snapshots

NB-008 adds behavioral tests near the feature using a test library compatible with React 19.2.3/RN 0.87.1, chosen and approved before dependency changes. Assert commands, native-state rendering, validation, cancellation, accessibility labels, and subscription cleanup. Do not duplicate native math tests in JS.

Use small focused snapshots only if they add meaningful stable coverage for phase-specific presentation; avoid whole-screen/map snapshots that mostly reflect third-party renderer internals. Visual matching belongs to owner/manual QA. A snapshot pass is not an acceptance test for location output.

## Failure-oriented coverage

- Startup canceled at each acquisition boundary; resources acquired after cancellation are reconciled.
- Missing OBD/IMU, stale values, malformed frames, buffer overflow, reconnect and delayed old replies.
- Correction with in-flight output; Stop before/after set acknowledgement; unknown or failed clear.
- Process restart with an outstanding marker, failed tunnel, permission revocation, locked phone and JS reload.
- Recorder storage/write failure, corrupt/truncated/unsupported replay, stable session error despite cleanup failure.
- Injected system location rejected as independent measurement or ground truth.

## Passing and reporting

Use separate statuses: not run, pass, fail, blocked, inconclusive. “Build passed” and “Waze followed supplied coordinates” are different observations. Reports name exact command, revision, environment, configuration, fixture provenance, actual results, and limitations.

Define field thresholds before the acceptance run using the NB-001 measurement protocol and owner's use case. A synthetic test tolerance is a numerical-testing choice, not a real-world accuracy promise. Regression scope follows actual shared consumers and changed contracts; do not run unrelated checks merely for volume.
