# NB-007: Recording and replay harness

## 0. Lifecycle and session entry

- **Status:** Draft
- **Plan created:** 2026-10-11.
- **Target:** iOS 27 / iPhone, with React Native presentation and native Swift execution. Android is outside scope.
- **Prerequisites:** [NB-002](NB-002-native-session-contract.md), [NB-004](NB-004-location-output-and-pairing.md), [NB-005](NB-005-viecar-obd.md), [NB-006](NB-006-motion-and-dead-reckoning.md)
- **Approval:** Draft only. Documentation approval does not authorize this implementation. Obtain owner approval of this task and its blocking decisions before code.
- **Persistence:** Keep this plan in Git and update it in place; do not delete it after completion or create separate state/handoff/review files.

New-session prompt:

> Read AGENTS.md, plans/README.md, and plans/NB-007-recording-and-replay-harness.md. Inspect Git branch/HEAD and staged/working changes. Verify prerequisites and open questions against the current tree. Continue only the approved scope of NB-007; report actual checks and stop at the staged diff for approval. Do not commit or push.

## 1. Task and intended outcome

An opt-in local recording can be replayed deterministically through the production core, and synthetic fault scenarios verify session decisions without hardware.

This is one task/approval unit. If new evidence materially changes it, update this plan and obtain agreement before expanding scope.

## 2. Verified context and proposed files

harness/ currently documents conventions only. Native core/input/output boundaries from predecessor tasks must exist before selecting executable runner details. Real trip privacy and schema compatibility must be settled before first capture.

Proposed new: ios/NavBridge/Recording/; native/NavBridgeCore/Sources/NavBridgeCore/Replay/; Tests/NavBridgeCoreTests/ReplayTests.swift; a Swift replay executable target in Package.swift; harness/fixtures/synthetic/ and harness/scenarios/ real versioned inputs. Raw recordings/reports stay in ignored private/local folders.

Baseline repository revision: `289d710aac77cfa3e8b4985201ca8285e33fabb8`. Predecessor tasks may add the proposed files; a new session must verify they actually exist. Future paths are planned ownership, not claims of implemented APIs. Sources and observation limits: [evidence register](../docs/research/evidence.md).

## 3. Problem framing and decisions

**Solved means:** An opt-in local recording can be replayed deterministically through the production core, and synthetic fault scenarios verify session decisions without hardware.

**Shortcut and limit:** A checklist or fake happy-path result is easier to produce, but does not prove the task's behavioral boundary or actual device conditions. Do not use it as completion evidence.

**Chosen approach and cost:** Follow the narrow ownership/files in §2 and the ordered steps below. Preserve native live ownership and shared replay logic; use the relevant proof layer, with device access where required. No backend or sibling-platform work is included.

**Who still has the problem:** Untested devices, OS builds, vehicle/adapter/head-unit configurations and users outside the agreed personal scope. Success of this task does not imply the entire product is complete.

**Decisions:** [BLOCKING] Q-06 recording/export/retention policy. Finalize schema versioning, raw-vs-canonical boundary, clocks, event completeness, deterministic effect model, report metrics/oracles and CLI contract before capturing real data.

Applicable criteria: AGENTS.md; requirements R-01–R-10; [architecture contracts](../docs/architecture/contracts.md); [test strategy](../docs/testing/strategy.md). Numeric quality/resource settings need documented provenance and agreement; proposed structural design is reviewed with the task, not silently treated as established fact.

## 4. Ordered implementation / research steps

### 1. Finalize schema and local recorder

Record provenance/configuration, ordered events, clocks, source quality, commands/output completions and completeness. Bound writes with measured storage policy and explicit errors; never delay Stop for recording.

**Done when:** Consent, write failure, export and incomplete session behavior are implemented without credentials in records.

### 2. Implement fake time and shared-core replay

Feed one chosen input boundary through the production implementation with deterministic fake effects; never access BLE/VPN/system output in replay.

**Done when:** Same input/configuration yields equivalent ordered decisions under declared numerical/toolchain scope.

### 3. Create reviewed scenario fixtures

Implement H-01 through H-14 with independently derived expected outcomes, including stale data, late replies, correction/Stop races, failed clear, self-feedback and corrupt records.

**Done when:** Every fixture has provenance and oracle rationale; no golden generated from itself is presented as accuracy proof.

### 4. Deliver runner/report workflow

Add actual invocation/exit codes once built; report invalid input vs failed expectation vs incomplete session distinctly. Document local commands and optional CI prerequisites.

**Done when:** Authorized harness run has reproducible real results and redacted artifacts; no fake passing report or invented runnable command.

## 5. Language and user-facing copy

All code, documentation and plans are English. The product UI locale is a separate decision (Q-07). No localization catalog or i18n framework exists in the template; do not invent a catalog command. For user-visible changes, agree the supported locale and recovery/error wording before implementation.

## 6. Unit and integration tests

ReplayTests.swift: version/kind validation, finite/range checks, equal-time sequence ordering, unknown required event, truncation, duplicate/out-of-order event, raw/canonical double-count prevention, injected effect timing, stable output, private-field exclusion and recorder failure. Scenario assertions use H-01–H-14 and the real core.

Test paths described as proposed are new files, not existing suites. Tests run only under the approved task scope. Existing JS commands and future native command prerequisites are documented in [development](../docs/engineering/development.md).

## 7. Snapshots and visual checks

Not applicable for replay CLI; readable report format assertions only if they verify a supported contract rather than incidental formatting.

## 8. Manual QA / experiment cases

Replay a known synthetic input twice; alter a copy with a declared fault; verify source unchanged and non-success outcome. Record/export only after owner consent; inspect staged/exported files for sensitive data.

Record preconditions → actions → expected result → actual observation using [device validation](../docs/testing/device-validation.md). Mark cases not run, pass, fail, blocked or inconclusive; never imply the listed cases already passed.

## 9. Regression scope

Production estimator/session decisions are shared; no alternate math path, live-output side effects, changed device cleanup, or recording blockage of Stop.

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

[BLOCKING] Implemented native boundaries and recording/privacy decisions. Numerical and product thresholds must not be conflated.

Read [the question register](../docs/research/open-questions.md) for cross-task questions. Record answers in the owning document and this plan. Future commercial distribution, automatic map matching, cell/Wi-Fi positioning, CAN/extra IMU hardware, GNSS anomaly detection and Android remain outside this task unless explicitly approved separately.
