# NB-011: Personal release and business gate

## 0. Lifecycle and session entry

- **Status:** Draft
- **Plan created:** 2026-10-11.
- **Target:** iOS 27 / iPhone, with React Native presentation and native Swift execution. Android is outside scope.
- **Prerequisites:** [NB-009](NB-009-background-and-device-validation.md)
- **Approval:** Draft only. Documentation approval does not authorize this implementation. Obtain owner approval of this task and its blocking decisions before code.
- **Persistence:** Keep this plan in Git and update it in place; do not delete it after completion or create separate state/handoff/review files.

New-session prompt:

> Read AGENTS.md, plans/README.md, and plans/NB-011-personal-release-and-business-gate.md. Inspect Git branch/HEAD and staged/working changes. Verify prerequisites and open questions against the current tree. Continue only the approved scope of NB-011; report actual checks and stop at the staged diff for approval. Do not commit or push.

## 1. Task and intended outcome

The owner receives a reproducible personal installation/operation guide and an evidence-based decision on whether to investigate commercialization.

This is one task/approval unit. If new evidence materially changes it, update this plan and obtain agreement before expanding scope.

## 2. Verified context and proposed files

No distribution path, own-code license, market size, revenue or App Store eligibility is currently established. NB-010 is required only if the release claims CarPlay support; phone-only delivery must say so explicitly.

Proposed new: docs/engineering/personal-installation.md and a reviewed version-specific release summary. Existing: README.md, docs/product/business-plan.md, docs/engineering/privacy-and-licensing.md, docs/testing/acceptance.md, dependency provenance/notices and relevant persistent plans.

Baseline repository revision: `289d710aac77cfa3e8b4985201ca8285e33fabb8`. Predecessor tasks may add the proposed files; a new session must verify they actually exist. Future paths are planned ownership, not claims of implemented APIs. Sources and observation limits: [evidence register](../docs/research/evidence.md).

## 3. Problem framing and decisions

**Solved means:** The owner receives a reproducible personal installation/operation guide and an evidence-based decision on whether to investigate commercialization.

**Shortcut and limit:** A checklist or fake happy-path result is easier to produce, but does not prove the task's behavioral boundary or actual device conditions. Do not use it as completion evidence.

**Chosen approach and cost:** Follow the narrow ownership/files in §2 and the ordered steps below. Preserve native live ownership and shared replay logic; use the relevant proof layer, with device access where required. No backend or sibling-platform work is included.

**Who still has the problem:** Untested devices, OS builds, vehicle/adapter/head-unit configurations and users outside the agreed personal scope. Success of this task does not imply the entire product is complete.

**Decisions:** [BLOCKING] Q-09 personal/commercial boundary and approved install method. Owner chooses own-code license before publication. Do not enroll/pay/publish/contact users or create a PR without explicit instruction.

Applicable criteria: AGENTS.md; requirements R-01–R-10; [architecture contracts](../docs/architecture/contracts.md); [test strategy](../docs/testing/strategy.md). Numeric quality/resource settings need documented provenance and agreement; proposed structural design is reviewed with the task, not silently treated as established fact.

## 4. Ordered implementation / research steps

### 1. Prepare the personal build record

Record actual revision, locks, toolchain, identifiers/entitlements, install/provisioning constraints, selected upstream licenses and verified configurations without secrets.

**Done when:** Owner can reproduce the installation with their account; no opaque artifact provenance is omitted.

### 2. Write the operational guide

Describe exact setup/pairing/mount/anchor/Start/Waze/correction/Stop/cleanup recovery steps, uninstall/re-pair, and supported limitations based on measured behavior.

**Done when:** The owner follows the guide on their device; untested restore behavior is not presented as a remedy.

### 3. Review actual costs and usefulness

Enter measured effort/expenses and field outcomes into the business plan; keep price/demand/market assumptions distinct. Evaluate whether separate distribution/licensing/user research is warranted.

**Done when:** A personal-only or next-research decision has explicit evidence and no fabricated forecast.

### 4. Hand back reviewed artifacts

Run the relevant already-approved build/acceptance checks for the release revision, stage exact files, show full diff and propose a commit message.

**Done when:** All release claims trace to actual results; owner approval is pending before commit, and no push/publication occurs.

## 5. Language and user-facing copy

All code, documentation and plans are English. The product UI locale is a separate decision (Q-07). No localization catalog or i18n framework exists in the template; do not invent a catalog command. For user-visible changes, agree the supported locale and recovery/error wording before implementation.

## 6. Unit and integration tests

No new test suite for documentation/release alone. Run existing approved checks appropriate to actual runtime changes and final release revision; record commands/results and skipped physical cases explicitly.

Test paths described as proposed are new files, not existing suites. Tests run only under the approved task scope. Existing JS commands and future native command prerequisites are documented in [development](../docs/engineering/development.md).

## 7. Snapshots and visual checks

No new snapshots unless a separately approved UI change is needed.

## 8. Manual QA / experiment cases

Owner follows install and operation/recovery guide. Phone support requires NB-009 evidence; any CarPlay claim additionally requires NB-010 evidence on the named configuration.

Record preconditions → actions → expected result → actual observation using [device validation](../docs/testing/device-validation.md). Mark cases not run, pass, fail, blocked or inconclusive; never imply the listed cases already passed.

## 9. Regression scope

Personal install/signing, privacy/redaction, dependency notices, working setup/Stop, documentation links, traceability to the actual release revision.

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

[BLOCKING] Actual validated personal build/install path and distribution decision. Commercial demand, legal/distribution feasibility and support economics remain separate gates.

Read [the question register](../docs/research/open-questions.md) for cross-task questions. Record answers in the owning document and this plan. Future commercial distribution, automatic map matching, cell/Wi-Fi positioning, CAN/extra IMU hardware, GNSS anomaly detection and Android remain outside this task unless explicitly approved separately.
