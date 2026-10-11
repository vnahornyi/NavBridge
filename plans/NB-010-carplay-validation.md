# NB-010: CarPlay validation

## 0. Lifecycle and session entry

- **Status:** Draft
- **Plan created:** 2026-10-11.
- **Target:** iOS 27 / iPhone, with React Native presentation and native Swift execution. Android is outside scope.
- **Prerequisites:** [NB-009](NB-009-background-and-device-validation.md)
- **Approval:** Draft only. Documentation approval does not authorize this implementation. Obtain owner approval of this task and its blocking decisions before code.
- **Persistence:** Keep this plan in Git and update it in place; do not delete it after completion or create separate state/handoff/review files.

New-session prompt:

> Read AGENTS.md, plans/README.md, and plans/NB-010-carplay-validation.md. Inspect Git branch/HEAD and staged/working changes. Verify prerequisites and open questions against the current tree. Continue only the approved scope of NB-010; report actual checks and stop at the staged diff for approval. Do not commit or push.

## 1. Task and intended outcome

The owner knows whether their actual CarPlay/Waze/head-unit configuration follows NavBridge output, with connection and cleanup limits documented.

This is one task/approval unit. If new evidence materially changes it, update this plan and obtain agreement before expanding scope.

## 2. Verified context and proposed files

Phone Waze is the initial target. CarPlay may involve accessory location, and the RCD 360 Pro details are owner-supplied concept information. No CarPlay test or NavBridge CarPlay interface exists.

Proposed reviewed report: harness/reports/NB-010-carplay.md. Existing: docs/testing/device-validation.md, docs/testing/acceptance.md, README.md and relevant support notes. No new CarPlay UI target/entitlement is planned.

Baseline repository revision: `289d710aac77cfa3e8b4985201ca8285e33fabb8`. Predecessor tasks may add the proposed files; a new session must verify they actually exist. Future paths are planned ownership, not claims of implemented APIs. Sources and observation limits: [evidence register](../docs/research/evidence.md).

## 3. Problem framing and decisions

**Solved means:** The owner knows whether their actual CarPlay/Waze/head-unit configuration follows NavBridge output, with connection and cleanup limits documented.

**Shortcut and limit:** A checklist or fake happy-path result is easier to produce, but does not prove the task's behavioral boundary or actual device conditions. Do not use it as completion evidence.

**Chosen approach and cost:** Follow the narrow ownership/files in §2 and the ordered steps below. Preserve native live ownership and shared replay logic; use the relevant proof layer, with device access where required. No backend or sibling-platform work is included.

**Who still has the problem:** Untested devices, OS builds, vehicle/adapter/head-unit configurations and users outside the agreed personal scope. Success of this task does not imply the entire product is complete.

**Decisions:** [BLOCKING] Exact head unit/firmware/connection mode and owner access. Agree tested configurations and how failures affect the personal scope; do not infer all CarPlay support from one result.

Applicable criteria: AGENTS.md; requirements R-01–R-10; [architecture contracts](../docs/architecture/contracts.md); [test strategy](../docs/testing/strategy.md). Numeric quality/resource settings need documented provenance and agreement; proposed structural design is reviewed with the task, not silently treated as established fact.

## 4. Ordered implementation / research steps

### 1. Record configuration and source experiment

Document head unit/phone/Waze/iOS versions and connection type; compare a recognizable stationary supplied coordinate with CarPlay Waze marker.

**Done when:** Actual location-source behavior is observed separately from phone-only output.

### 2. Test lifecycle and navigation

Repeat set/clear, reconnect, foreground/lock transitions and an approved route with operator/reference; observe whether the accessory changes source selection.

**Done when:** Per-case outcome names phone and CarPlay behavior and cleanup result.

### 3. Publish bounded support conclusion

Update configuration-specific support notes and remaining questions; propose any new architecture only if current mechanism fails.

**Done when:** Support claim matches evidence; no new navigator/CarPlay app is added implicitly.

## 5. Language and user-facing copy

All code, documentation and plans are English. The product UI locale is a separate decision (Q-07). No localization catalog or i18n framework exists in the template; do not invent a catalog command. For user-visible changes, agree the supported locale and recovery/error wording before implementation.

## 6. Unit and integration tests

No new unit suite for a device-validation-only task. If a product fix is proposed, scope/approve it and define meaningful regression cases before coding.

Test paths described as proposed are new files, not existing suites. Tests run only under the approved task scope. Existing JS commands and future native command prerequisites are documented in [development](../docs/engineering/development.md).

## 7. Snapshots and visual checks

Not applicable: no NavBridge CarPlay UI.

## 8. Manual QA / experiment cases

CarPlay procedure in docs/testing/device-validation.md: distinct position, continuous output, clear, reconnect, lock/foreground, and agreed route. Keep phone controls with passenger/operator.

Record preconditions → actions → expected result → actual observation using [device validation](../docs/testing/device-validation.md). Mark cases not run, pass, fail, blocked or inconclusive; never imply the listed cases already passed.

## 9. Regression scope

Previously passed phone-only operation, own tunnel/pairing, input validity, Stop/restoration. Record any head-unit behavior that affects these.

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

[BLOCKING] Owner's actual head unit and connection access. A failed CarPlay experiment does not erase a separately validated phone-only result.

Read [the question register](../docs/research/open-questions.md) for cross-task questions. Record answers in the owning document and this plan. Future commercial distribution, automatic map matching, cell/Wi-Fi positioning, CAN/extra IMU hardware, GNSS anomaly detection and Android remain outside this task unless explicitly approved separately.
