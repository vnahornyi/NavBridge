# Device and vehicle validation

## Evidence record

For every experiment record: date, operator, task plan, Git/build revision, Xcode/iOS version, phone model, adapter/firmware evidence, vehicle, Waze version, head unit/CarPlay mode where relevant, pairing method, tunnel configuration, permissions, app state, connectivity, mount/calibration, test configuration revision, reference method, steps, expected outcome, observed outcome, and limitations. Keep sensitive identifiers and coordinates private.

Use not-run/pass/fail/blocked/inconclusive statuses. The current only end-to-end observation is owner-reported Waze visibility from an external tool; the exact repeatable baseline remains to be captured. No device run has been executed by the documentation task.

## Bench procedures

| Case | Preconditions and actions | Observe |
|---|---|---|
| D-01 External control | Owner reproduces the existing tool setup; supply a recognizable stationary coordinate | Waze vehicle marker, set/clear behavior, exact tool/build; distinguish destination opening |
| D-02 Own tunnel/output | Signed NavBridge components; repeat set/clear while stationary | Own-build acknowledgements plus Waze result; Internet and DNS still work |
| D-03 Permissions/setup | Fresh/denied/revoked Bluetooth, motion, VPN/pairing prerequisites | Specific blocked state and deliberate recovery; no fabricated ready state |
| D-04 Actual OBD | Ignition/engine states documented; discover services; read-only speed request | UUIDs, fragments, latency, valid zero vs no data, disconnect/resync |
| D-05 Mounted motion | Confirm stationary then rotate through known left/right turns and supported orientations | Axis/sign, bias, clock mapping, movement/recalibration handling |
| D-06 Stop races | Stop during setup, pending set, correction, and tunnel interruption | Last possible set reconciled; confirmed clear or cleanupRequired |
| D-07 Restart | Terminate/force quit during an owned output session; reopen; separately reboot | Outstanding marker recovery, actual Waze/system state; no false restoration claim |
| D-08 JS lifecycle | Reload/unmount RN screen while a native session is active | No duplicate session or stale snapshot; Stop works on reattach |

## Background and connectivity matrix

Run relevant bench/route cases with Waze foreground, NavBridge foreground, lock/unlock, normal backgrounding, main-process termination, extension termination, permission change, BLE loss/reconnect, Wi-Fi-to-cellular change, unavailable Internet/map tiles, another VPN present, and low-power/thermal conditions. Record which combinations were actually tested; do not multiply untested rows into a support claim.

Measure input/output gaps, latency, time spent invalid, CPU/energy/thermal observations, successful cleanup, and recovery burden. Define required duration and pass thresholds with the owner before acceptance; durations and sampling settings must reflect the chosen use case and actual observations.

## Vehicle route procedure

Use a safely mounted phone; a passenger/operator performs UI actions and records observations. The driver does not manipulate the prototype during movement. Select a repeatable route with stationary intervals, straight motion, left/right turns, and planned correction checkpoints. Include reverse only after the motion-mode decision; unsupported reverse is a failure/invalid-state test, not normal tracking.

Specify an independent reference, its uncertainty, and clock alignment. A separate non-injected reference run has route/time differences; a second reference device has its own quality limits. State these instead of treating either as exact truth. Keep original private input and reference records.

Compare the declared estimator configuration to ordinary Waze behavior and the manual-anchor baseline. Report error vs traveled distance/time, turn timing, interventions, invalid intervals, and stop/recovery outcomes. Separate transport success (Waze follows supplied position) from positioning usefulness (supplied position is sufficiently accurate).

## CarPlay procedure

After phone acceptance, record the actual RCD 360 Pro/head unit identity, firmware and connection type. Repeat a stationary distinct-position set/clear experiment with Waze on CarPlay. Test connection changes, foreground/lock changes, and navigation continuity. If the head unit's source overrides phone output, record the limitation; do not claim general CarPlay support or add a NavBridge CarPlay app as a workaround without agreement.
