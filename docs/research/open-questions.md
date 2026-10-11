# Open questions and decisions

These questions do not block the documentation foundation. They gate the specific implementation tasks below. A task-plan approval must resolve its blocking decisions or explicitly narrow the task to research only.

## Owner decisions

| ID | Question / proposed answer | Blocks |
|---|---|---|
| Q-01 | Is an active paid Apple Developer Program membership available for signing our embedded packet tunnel? | Own-device tunnel/output implementation NB-003/NB-004; research may continue |
| Q-02 | Which exact tool/build and setup produced “Waze sees it”? Can the owner repeat set, continuous updates, and clear? | NB-001 baseline; later comparison |
| Q-03 | Approve forward-only baseline with an explicit reverse limitation, or require a manual forward/reverse control? | NB-006 motion contract and NB-008 controls |
| Q-04 | Approve manual vehicle heading and a rigid mounting/calibration procedure? | NB-006/NB-008 |
| Q-05 | Which intended outage duration, routes, drift/intervention tolerance, and supported app states define usefulness? | Field acceptance NB-009; no invented target now |
| Q-06 | Is location/motion recording opt-in/local-only, and what export/retention behavior is acceptable? | NB-007 recorder |
| Q-07 | Which map provider, online/offline expectation, and UI locale should the manual coordinate picker use? Coordinate entry is proposed fallback. | NB-008 dependencies and UI |
| Q-08 | What are the exact phone model, vehicle/adapter firmware evidence, head-unit/CarPlay mode, and available independent reference device? | NB-001 measurement setup; NB-009/NB-010 matrix |
| Q-09 | Personal installation only, or later commercial evaluation? Own-code license and any publication remain undecided. | NB-011 distribution/business gate |
| Q-10 | Is manual correction supported only while stationary initially? Moving selection introduces time/position ambiguity. | NB-006 correction semantics and NB-008 flow |

Resolved: all documentation and plans are English (R-10). Android is outside scope; Waze on the phone precedes CarPlay. Persistent plans are explicitly requested. These decisions must not be asked again absent a scope change.

## Engineering measurements

| ID | Investigation | Owning task |
|---|---|---|
| M-01 | Own signed embedded tunnel and developer output work on the exact iOS 27 build | NB-001, NB-003, NB-004 |
| M-02 | Set/clear acknowledgement, fresh-handle clear, process restart and tunnel-loss recovery | NB-004 |
| M-03 | Actual BLE UUIDs/properties, supported speed PID, framing, latency and dropout distribution | NB-005 |
| M-04 | IMU axis/sign/bias, mounting effects, clock mapping, sensor/output gap policy | NB-006 |
| M-05 | Legitimate background execution while Waze is foreground; lock/termination behavior | NB-009 |
| M-06 | Head-unit location source selection and connect/disconnect behavior | NB-010 |
| M-07 | Numerical tolerances, sampling/freshness/retry/storage settings with provenance | Relevant implementation plans; no defaults yet |
| M-08 | Upstream source/library reproducible builds, slices, transitive licenses | NB-004 |
| M-09 | Reference uncertainty/alignment and field drift under supported conditions | NB-009 |

## Decision recording

Update the owning document and task plan in place. Record answer, decision owner, date, evidence, affected contracts/tests, and whether it is measured or merely agreed. Do not store credentials, real coordinates, or private identifiers here. If a feasibility test fails, keep its failure and limitation visible rather than rewriting it as an implementation success.
