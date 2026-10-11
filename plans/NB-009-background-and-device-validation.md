# NB-009: Background and device acceptance

## 0. Lifecycle and session entry

- **Status:** Draft
- **Plan created:** 2026-10-11.
- **Target:** iOS 27 / iPhone, with React Native presentation and native Swift execution. Android is outside scope.
- **Prerequisites:** [NB-003](NB-003-integrated-local-tunnel.md), [NB-004](NB-004-location-output-and-pairing.md), [NB-005](NB-005-viecar-obd.md), [NB-006](NB-006-motion-and-dead-reckoning.md), [NB-007](NB-007-recording-and-replay-harness.md), [NB-008](NB-008-control-screen-and-correction.md)
- **Approval:** Draft only. Documentation approval does not authorize this implementation. Obtain owner approval of this task and its blocking decisions before code.
- **Persistence:** Keep this plan in Git and update it in place; do not delete it after completion or create separate state/handoff/review files.

New-session prompt:

> Read AGENTS.md, plans/README.md, and plans/NB-009-background-and-device-validation.md. Inspect Git branch/HEAD and staged/working changes. Verify prerequisites and open questions against the current tree. Continue only the approved scope of NB-009; report actual checks and stop at the staged diff for approval. Do not commit or push.

## 1. Task and intended outcome

Own-build NavBridge demonstrates, or explicitly fails/narrows, Waze-foreground operation and measured positioning usefulness on the owner's actual phone/vehicle.

This is one task/approval unit. If new evidence materially changes it, update this plan and obtain agreement before expanding scope.

## 2. Verified context and proposed files

Native ownership and tunnel survival do not prove host background execution. Accuracy has no agreed numerical target yet. Every result must identify app state, versions, reference uncertainty and configuration.

Existing runtime files introduced by predecessors may receive only fixes needed for this acceptance scope. Proposed reviewed report: harness/reports/NB-009-device-acceptance.md. Update docs/testing/device-validation.md, acceptance.md, architecture/positioning.md and supported-condition notes.

Baseline repository revision: `289d710aac77cfa3e8b4985201ca8285e33fabb8`. Predecessor tasks may add the proposed files; a new session must verify they actually exist. Future paths are planned ownership, not claims of implemented APIs. Sources and observation limits: [evidence register](../docs/research/evidence.md).

## 3. Problem framing and decisions

**Solved means:** Own-build NavBridge demonstrates, or explicitly fails/narrows, Waze-foreground operation and measured positioning usefulness on the owner's actual phone/vehicle.

**Shortcut and limit:** A checklist or fake happy-path result is easier to produce, but does not prove the task's behavioral boundary or actual device conditions. Do not use it as completion evidence.

**Chosen approach and cost:** Follow the narrow ownership/files in §2 and the ordered steps below. Preserve native live ownership and shared replay logic; use the relevant proof layer, with device access where required. No backend or sibling-platform work is included.

**Who still has the problem:** Untested devices, OS builds, vehicle/adapter/head-unit configurations and users outside the agreed personal scope. Success of this task does not imply the entire product is complete.

**Decisions:** [BLOCKING] Q-05 owner-approved duration/drift/intervention/resource criteria and Q-08 independent reference/operator. Select legitimate background behavior after measurements; do not silently copy silent-audio keepalive or claim unsupported uptime.

Applicable criteria: AGENTS.md; requirements R-01–R-10; [architecture contracts](../docs/architecture/contracts.md); [test strategy](../docs/testing/strategy.md). Numeric quality/resource settings need documented provenance and agreement; proposed structural design is reviewed with the task, not silently treated as established fact.

## 4. Ordered implementation / research steps

### 1. Freeze acceptance configuration and reference

Record build/device/adapter/mount/version/configuration, agreed route/app-state matrix, reference uncertainty and clock alignment, and all pass/fail targets before running.

**Done when:** Acceptance protocol is approved and repeatable; no target is selected after seeing results.

### 2. Run bench/background failure matrix

Execute D-01–D-08 as applicable, Waze foreground, lock/unlock, BLE/network loss, extension/main-process termination and restart; measure sensor/output gaps and cleanup.

**Done when:** Actual results separate transport, background, recovery and untested cases; failed clear stays visible.

### 3. Measure vehicle usefulness

Run agreed repeatable routes with passenger/operator and independent reference; compare ordinary Waze/manual-anchor baselines, drift, turn timing, interventions and invalid intervals.

**Done when:** Metrics include uncertainty and coverage; the injected phone stream/Waze marker is never ground truth.

### 4. Resolve scoped failures and support claims

Fix only documented acceptance failures with meaningful regression tests under this approved scope, rerun affected cases, and narrow supported conditions where necessary.

**Done when:** No broad success claim exceeds evidence; remaining failures/blockers are explicit and gate personal release.

## 5. Language and user-facing copy

All code, documentation and plans are English. The product UI locale is a separate decision (Q-07). No localization catalog or i18n framework exists in the template; do not invent a catalog command. For user-visible changes, agree the supported locale and recovery/error wording before implementation.

## 6. Unit and integration tests

Add only regression tests for measured failures not covered by predecessor suites: suspend/gap/restart ordering, stale inputs, cleanup and clock mapping. Run relevant core/harness/RN tests after such fixes; hardware results remain separate.

Test paths described as proposed are new files, not existing suites. Tests run only under the approved task scope. Existing JS commands and future native command prerequisites are documented in [development](../docs/engineering/development.md).

## 7. Snapshots and visual checks

No new visual snapshots unless a scoped UI state fix changes a previously agreed stable snapshot.

## 8. Manual QA / experiment cases

The complete approved device/background/vehicle matrix in docs/testing/device-validation.md. Simulator and deterministic results cannot substitute for these physical cases.

Record preconditions → actions → expected result → actual observation using [device validation](../docs/testing/device-validation.md). Mark cases not run, pass, fail, blocked or inconclusive; never imply the listed cases already passed.

## 9. Regression scope

End-to-end Start/correction/Stop, actual network/VPN/pairing, BLE input, mount recalibration, private recording policy and independent reference separation.

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

[BLOCKING] Physical device/vehicle/reference access and agreed field targets. If reliable Waze-foreground operation fails, stop the supported-use claim and return a concrete limitation/decision.

Read [the question register](../docs/research/open-questions.md) for cross-task questions. Record answers in the owning document and this plan. Future commercial distribution, automatic map matching, cell/Wi-Fi positioning, CAN/extra IMU hardware, GNSS anomaly detection and Android remain outside this task unless explicitly approved separately.
