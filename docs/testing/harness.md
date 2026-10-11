# Deterministic replay and fault harness

## Purpose and current state

Reproduce a navigation session, inspect its decisions, and test input/output failures without a car. This is a design document. `harness/` currently contains conventions only: no runner, executable fixtures, generated reports, or passing harness suite. NB-002 establishes the pure core; NB-007 implements recording and replay.

## Architecture

Use the same `NavBridgeCore` Swift package in the iOS session and replay target. The runner feeds recorded/constructed events into the production decision path, with fake monotonic time and deterministic fake effects. It must not contact a device, start a VPN, or send real system-location updates in replay mode.

Separate three test boundaries:

1. Raw BLE fragments through the production parser and normalizer.
2. Canonical speed/motion through the production estimator.
3. Session commands and asynchronous effect completions through production transition/orchestration decisions.

Do not feed raw and already-normalized versions of the same sample twice. Select and record the tested boundary. Timing changes and fault injection apply to a scenario copy; the source recording remains unchanged.

## Event format and provenance

Use the proposed versioned JSONL contract in [contracts](../architecture/contracts.md). Metadata includes build/dependency/configuration revision, clock mapping, units, device/adapter metadata when permitted, input boundary, mount/calibration description, completeness, and synthetic/real provenance. A fixture manifest documents its generator or capture method, reference source, and expected results.

Each event has a monotonic timestamp and stable sequence; events at equal time retain sequence ordering. Generations and session IDs remain explicit. Use separate event types for commands, measurements, source failures, output attempts/completions, and app/extension lifecycle. Unknown required kinds, invalid numbers, unsupported versions, and incomplete recordings produce explicit errors/inconclusive results.

Record relative time for replay, UTC only when useful for independent reference alignment. Normalize source clocks with explicit offsets/drift assumptions; do not replay using wall-clock sleeps. Determinism means identical input/configuration yields equivalent output under the declared toolchain/numerical tolerance. If byte-identical reports are desired, exclude run-time wall timestamps from compared content.

## Initial scenario catalog

| ID | Input | Required result |
|---|---|---|
| H-01 | Stationary with valid zero speed | No displacement; valid input distinguished from unavailable |
| H-02 | Analytic straight motion in cardinal directions | Distance/heading consistent with independent formula |
| H-03 | Constant-rate left/right turn and heading wrap | Correct sign/axes and continuity |
| H-04 | Phone orientations with equivalent vertical yaw | Correct projection for supported mounts; reject uncalibrated movement |
| H-05 | Fragmented/echoed/malformed BLE responses | Same valid decode; errors never become zero |
| H-06 | Timeout, late response, resynchronization, reconnect | Late/old data cannot satisfy a new request or session |
| H-07 | Missing/stale IMU or speed; long clock gap | Halt integration and follow recovery policy |
| H-08 | Position-only, heading-only and combined corrections | Atomic new generation; omitted fields preserved |
| H-09 | In-flight set, correction, then Stop in varied callback orders | No stale continuation; clear after last possible set |
| H-10 | Failed/unknown clear, restart with marker, retry | cleanupRequired until confirmed restoration |
| H-11 | Our output returns through Core Location | Never accepted as independent correction/reference |
| H-12 | Recorder full/fails; corrupt/truncated/version-mismatched input | Recording/replay failure visible; Stop remains usable |
| H-13 | Duplicate, out-of-order, non-finite or wrong-generation events | Explicit rejection with stable error and state |
| H-14 | Explicit reverse-mode event or operator-declared unsupported maneuver | Apply the approved mode policy; do not claim unsigned speed detects reversing |

Unsigned OBD speed cannot detect reverse by itself. A forward-only mode depends on the agreed operator procedure; automatic reverse rejection is not a proven capability. A synthetic reverse event tests an explicit command/quality policy, not a detector that does not exist.

Scenario values and geometric trajectories are synthetic test choices, labelled accordingly. Product limits remain configurable measured decisions. Create executable files in NB-007, not empty placeholders now.

## Oracles and reports

Analytic synthetic truth is independent of the implementation. Physical references include their own uncertainty, capture clocks, matching method, and missing intervals. Waze's displayed/snapped marker and the injected phone's Core Location stream are not ground truth.

Reports include event rejection counts, phase/effect trace, displacement/heading/distance metrics when valid, failure/cleanup outcome, configuration, provenance, and completeness. Metrics without a valid reference are absent with a reason. A golden file is useful only if its provenance and expected behavior were reviewed; auto-generating expected output from the same implementation creates no accuracy evidence.

The future CLI should provide machine-readable and readable results, distinguish input errors from assertion failures, and return non-success for either. Its exact executable name, arguments, and exit codes are finalized when implemented. No hypothetical command is advertised as runnable today.

## Privacy and future CI

Only synthetic fixtures enter Git by default. Real recordings and raw outputs stay in ignored private folders; reviewed summaries require redaction. Export is explicit. After local tests work, CI can run deterministic fixtures without credentials or device access. Device field reports remain a separate gate.
