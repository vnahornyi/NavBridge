# Session lifecycle

This is a proposed behavioral contract. NB-002 implements pure transitions and deterministic tests; later plans supply the effects.

| Phase | Entry | Allowed actions | Exit |
|---|---|---|---|
| `idle` | No outstanding output ownership; resources inactive | Setup, edit anchor, Start | `preparing` after validation |
| `preparing` | Start accepted; resources being acquired | Stop; observe prerequisite errors | `active` after fresh inputs and first successful output; otherwise cleanup/fault |
| `active` | Preconditions satisfied and output acknowledged | Correct, Stop, recording controls | `correcting`, `stopping`, or failure cleanup |
| `correcting` | Atomic correction accepted | Stop supersedes; repeated corrections ordered/rejected explicitly | `active` after new-generation output, or failure cleanup |
| `stopping` | New work cancelled; clear in progress | Repeated Stop is idempotent | `idle`/`faulted` after confirmed clear; `cleanupRequired` otherwise |
| `faulted` | Movement halted and outstanding output cleared | Inspect error, retry setup, explicit new Start | `preparing` after recovery validation |
| `cleanupRequired` | Output may remain set | Retry cleanup, inspect recovery instructions | `idle`/`faulted` only after confirmed clear |

## Start ownership

The controller serializes transitions and owns session/generation IDs. Setup acquires only the resources needed by the approved configuration. Record whether the VPN configuration belongs to NavBridge; do not change another application's profile. Already-active resources and partial startup failures have explicit cleanup responsibilities.

Start completion must name what is acknowledged. “Accepted” is not “active”; an active snapshot requires successful prerequisites and output. Multiple Start taps cannot create separate live owners. A Stop during setup invalidates all later completions from that generation.

## Effect ordering

Only one output operation is outstanding. Corrections and Stop invalidate older candidates, but a cancellation does not prove an already-sent operation did not reach iOS. Reconcile its result and clear after the last possible set before reporting successful Stop. Test both callback arrival orders.

On missing/stale input, immediately halt integration according to measured policy, then attempt clear. The output connection must remain usable through cleanup where possible. Do not tear down the tunnel first and make the clear impossible.

## Failure semantics

The first relevant error remains identifiable; later cleanup errors are attached, not substituted for it. A confirmed clear allows a faulted/inactive outcome. An unknown or failed clear enters `cleanupRequired` even if local resources have been released.

Persist a minimal outstanding-output marker before the first set; clear it only after confirmed clear. It contains no coordinates or pairing material. The exact persistence API and crash-ordering tests belong to NB-004. A fresh app process checks that marker and attempts recovery before new output.

Connecting to a fresh simulation handle and clearing without first injecting a coordinate must be verified. If the upstream wrapper cannot do it, that is an integration task/blocker, not a reason to send an invented position. Force quit, OS termination, VPN termination, and device reboot have separate measured outcomes.

## App and extension lifetime

The VPN extension is a separate process. Its survival does not imply the main process, CoreMotion, BLE polling, or React Native keeps executing. View unmount and JS suspension are normal; sensor/session ownership must not attach to React effects. Background execution and recovery require the device matrix in NB-009.
