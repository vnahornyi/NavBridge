# Open questions and decisions

These questions do not block the documentation foundation. They gate the specific implementation tasks below. A task-plan approval must resolve its blocking decisions or explicitly narrow the task to research only.

## Owner decisions

| ID | Question / proposed answer | Blocks |
|---|---|---|
| Q-01 | Owner confirmed v1.0 is for their own iPhone on iOS 27, with no paid Apple Developer Program membership, no VPN in NavBridge, and no public release (2026-10-11). The embedded packet tunnel is out of v1.0. Pinned Locus instructions describe iOS 27 on-device developer pairing without LocalDevVPN; this is upstream evidence, not a verified NavBridge path. NB-003 is deferred and NB-004 is scoped to this no-VPN path. | Free-team NavBridge signing and iOS 27 pairing/location-output validation in NB-004 remain unverified |
| Q-02 | Resolved for the NB-001 external baseline at the owner's direction: Locus `main` was built for an iPhone 11 running iOS 27, used with LocalDevVPN and the latest App Store Waze version; the owner reports that GPS location returned after Locus Stop. Exact build identifiers are waived. Repeated position-update behavior remains unknown and non-blocking for NB-001. | No longer blocks NB-001. Repeated-update behavior remains unverified for any later comparison. |
| Q-03 | Approve forward-only baseline with an explicit reverse limitation, or require a manual forward/reverse control? | NB-006 motion contract and NB-008 controls |
| Q-04 | Approve manual vehicle heading and a rigid mounting/calibration procedure? | NB-006/NB-008 |
| Q-05 | Which intended outage duration, routes, drift/intervention tolerance, and supported app states define usefulness? | Field acceptance NB-009; no invented target now |
| Q-06 | Is location/motion recording opt-in/local-only, and what export/retention behavior is acceptable? | NB-007 recorder |
| Q-07 | Which map provider, online/offline expectation, and UI locale should the manual coordinate picker use? Coordinate entry is proposed fallback. | NB-008 dependencies and UI |
| Q-08 | Owner identified an iPhone 11 running iOS 27; exact build identifiers are waived for NB-001. What vehicle/adapter firmware evidence, head-unit/CarPlay mode, and independent reference device are available for later measurement? | NB-009/NB-010 matrix and measurement setup; does not block NB-001 |
| Q-09 | Current v1.0 is personal-use only with no public release. Future public or commercial distribution remains undecided. | NB-011 distribution/business gate |
| Q-10 | Is manual correction supported only while stationary initially? Moving selection introduces time/position ambiguity. | NB-006 correction semantics and NB-008 flow |

Resolved: all documentation and plans are English (R-10). Android is outside scope; Waze on the phone precedes CarPlay. Persistent plans are explicitly requested. These decisions must not be asked again absent a scope change.

## Engineering measurements

| ID | Investigation | Owning task |
|---|---|---|
| M-01 | Free-team signing and iOS 27 on-device developer pairing/location output on the owner's exact phone build | NB-004 |
| M-02 | Set/clear acknowledgement, fresh-handle clear, process restart and pairing/connection-loss recovery | NB-004 |
| M-03 | Actual BLE UUIDs/properties, supported speed PID, framing, latency and dropout distribution | NB-005 |
| M-04 | IMU axis/sign/bias, mounting effects, clock mapping, sensor/output gap policy | NB-006 |
| M-05 | Legitimate background execution while Waze is foreground; lock/termination behavior | NB-009 |
| M-06 | Head-unit location source selection and connect/disconnect behavior | NB-010 |
| M-07 | Numerical tolerances, sampling/freshness/retry/storage settings with provenance | Relevant implementation plans; no defaults yet |
| M-08 | Upstream source/library reproducible builds, slices, transitive licenses | NB-004 |
| M-09 | Reference uncertainty/alignment and field drift under supported conditions | NB-009 |

## Decision recording

Update the owning document and task plan in place. Record answer, decision owner, date, evidence, affected contracts/tests, and whether it is measured or merely agreed. Do not store credentials, real coordinates, or private identifiers here. If a feasibility test fails, keep its failure and limitation visible rather than rewriting it as an implementation success.
