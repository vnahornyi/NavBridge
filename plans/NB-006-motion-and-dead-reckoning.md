# NB-006: Motion and dead reckoning

## 0. Lifecycle and session entry

- **Status:** Draft
- **Plan created:** 2026-10-11.
- **Target:** iOS 27 / iPhone, with React Native presentation and native Swift execution. Android is outside scope.
- **Prerequisites:** [NB-001](NB-001-feasibility-and-baseline.md), [NB-002](NB-002-native-session-contract.md), [NB-005](NB-005-viecar-obd.md)
- **Approval:** Draft only. Documentation approval does not authorize this implementation. Obtain owner approval of this task and its blocking decisions before code.
- **Persistence:** Keep this plan in Git and update it in place; do not delete it after completion or create separate state/handoff/review files.

New-session prompt:

> Read AGENTS.md, plans/README.md, and plans/NB-006-motion-and-dead-reckoning.md. Inspect Git branch/HEAD and staged/working changes. Verify prerequisites and open questions against the current tree. Continue only the approved scope of NB-006; report actual checks and stop at the staged diff for approval. Do not commit or push.

## 1. Task and intended outcome

A calibrated mounted phone and validated speed drive a pure position estimator with explicit timing/quality limits, atomic corrections, and no self-injected location feedback.

This is one task/approval unit. If new evidence materially changes it, update this plan and obtain agreement before expanding scope.

## 2. Verified context and proposed files

Only speed is expected from standard OBD. Absolute heading comes from a user-confirmed anchor; phone-relative yaw requires axis/sign/bias validation. Reverse and moving-correction semantics are unresolved.

Proposed new: ios/NavBridge/Motion/ ingestion/clock mapping; native/NavBridgeCore/Sources/NavBridgeCore/Positioning/ geometry/integration/calibration; Tests/NavBridgeCoreTests/PositioningTests.swift. Update docs/architecture/positioning.md and contracts.md with actual chosen formulas/configuration.

Baseline repository revision: `289d710aac77cfa3e8b4985201ca8285e33fabb8`. Predecessor tasks may add the proposed files; a new session must verify they actually exist. Future paths are planned ownership, not claims of implemented APIs. Sources and observation limits: [evidence register](../docs/research/evidence.md).

## 3. Problem framing and decisions

**Solved means:** A calibrated mounted phone and validated speed drive a pure position estimator with explicit timing/quality limits, atomic corrections, and no self-injected location feedback.

**Shortcut and limit:** A checklist or fake happy-path result is easier to produce, but does not prove the task's behavioral boundary or actual device conditions. Do not use it as completion evidence.

**Chosen approach and cost:** Follow the narrow ownership/files in §2 and the ordered steps below. Preserve native live ownership and shared replay logic; use the relevant proof layer, with device access where required. No backend or sibling-platform work is included.

**Who still has the problem:** Untested devices, OS builds, vehicle/adapter/head-unit configurations and users outside the agreed personal scope. Success of this task does not imply the entire product is complete.

**Decisions:** [BLOCKING] Q-03 motion mode, Q-04 heading/mount procedure, Q-10 correction conditions. Choose documented geodetic propagation, timestamp mapping, interpolation/hold/gap policy and calibration from measurements; no accuracy promise.

Applicable criteria: AGENTS.md; requirements R-01–R-10; [architecture contracts](../docs/architecture/contracts.md); [test strategy](../docs/testing/strategy.md). Numeric quality/resource settings need documented provenance and agreement; proposed structural design is reviewed with the task, not silently treated as established fact.

## 4. Ordered implementation / research steps

### 1. Validate motion and clock conversion

Capture stationary and known left/right turns across supported mount orientations. Project rotation with gravity, verify sign/axis, bias behavior, and mapping into session-monotonic time.

**Done when:** Observed conventions and calibration validity are documented; moving/unavailable mount is not silently accepted.

### 2. Implement pure measured-time integration

Normalize speed/yaw units, align actual timestamps, integrate heading/distance with a documented method and geodetic formula. Reject invalid/old/gapped inputs.

**Done when:** Independent analytic straight/turn/zero/wrap tests pass under justified numerical tolerances; no nominal-timer integration.

### 3. Implement corrections and quality recovery

Position-only/heading-only/combined correction preserves omitted fields, advances generation and resets the time baseline. Halt on stale input and require validated recovery anchor as defined.

**Done when:** A late pre-correction sample/output cannot overwrite it; missing data is never treated as stationary.

### 4. Connect estimator to native session

Produce output candidates only from valid approved inputs. Reject injected/unknown CoreLocation as independent measurement and record provenance.

**Done when:** Native integration uses the same pure core as tests; field usefulness remains a later measured gate.

## 5. Language and user-facing copy

All code, documentation and plans are English. The product UI locale is a separate decision (Q-07). No localization catalog or i18n framework exists in the template; do not invent a catalog command. For user-visible changes, agree the supported locale and recovery/error wording before implementation.

## 6. Unit and integration tests

PositioningTests.swift: cardinal straight movement; zero speed; constant left/right turn; heading/longitude wrap; non-finite/range error; irregular dt; duplicate/out-of-order samples; source-clock mismatch; stale/gap invalidation; equivalent mount yaw; bias calibration invalidity; partial correction; reverse unsupported/control semantics; injected-source rejection. Expected coordinates derive independently with documented tolerances.

Test paths described as proposed are new files, not existing suites. Tests run only under the approved task scope. Existing JS commands and future native command prerequisites are documented in [development](../docs/engineering/development.md).

## 7. Snapshots and visual checks

Not applicable; later feature tests cover heading/position controls.

## 8. Manual QA / experiment cases

D-05 mounted bench rotations and clock observations; controlled short vehicle route only if scoped/authorized, with independent reference. Do not label analytic replay evidence field accuracy.

Record preconditions → actions → expected result → actual observation using [device validation](../docs/testing/device-validation.md). Mark cases not run, pass, fail, blocked or inconclusive; never imply the listed cases already passed.

## 9. Regression scope

OBD normalization/timing, pure session transition contract, output ordering and clear recovery, no feedback from supplied system coordinates.

Broaden checks only when changed shared consumers, new failures, or unresolved concerns justify it. No unrelated dependency upgrade or architecture cleanup is included.

## 10. Estimate and resource assumptions

No hour estimate, delivery date, hardware purchase or paid-service budget is approved. Feasibility, device availability and measurement-dependent choices make an evidence-based estimate premature. Before implementation, price the concrete approved steps, meaningful automated verification, human device QA/review, documentation and release work; record optimistic/realistic effort and assumptions here if the owner requests an estimate. Do not apply unrelated company ticket gradations or invent a financial forecast.

## 11. Verification and completion

**Current record:** Not started. No task implementation, automated check, build, simulator, device, Waze, CarPlay, or vehicle result is claimed by this plan.

- [ ] Owner-approved task scope and blocking decisions recorded.
- [ ] Prerequisites verified against the current repository and device evidence.
- [ ] Ordered steps completed within scope; actual paths/contracts recorded.
- [ ] Authorized checks recorded with commands, revision, results and skipped cases.
- [ ] Relevant documentation/evidence updated; secrets and private recordings excluded.
- [ ] Exact task files staged; full diff and commit message presented.
- [ ] Owner approved the complete staged result; then mark Complete and update plans/README.md.

Append concise decisions and actual verification here as work proceeds. Do not create a separate handoff/review state file. Complete does not itself grant commit or publication authority.

## 12. Open questions, blockers and exclusions

[BLOCKING] Motion/mount/correction decisions and measured timing/calibration policy. Actual phone/vehicle evidence required for validity; no EKF/map matching expansion without a new approved task.

Read [the question register](../docs/research/open-questions.md) for cross-task questions. Record answers in the owning document and this plan. Future commercial distribution, automatic map matching, cell/Wi-Fi positioning, CAN/extra IMU hardware, GNSS anomaly detection and Android remain outside this task unless explicitly approved separately.
