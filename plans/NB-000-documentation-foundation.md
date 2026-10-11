# NB-000: Documentation foundation

## 0. Lifecycle and session entry

- **Status:** Implemented — awaiting approval
- **Plan created:** 2026-10-11.
- **Target:** iOS 27 / iPhone, with React Native presentation and native Swift execution. Android is outside scope.
- **Prerequisites:** None; this is the current documentation task.
- **Approval:** The owner authorized the documentation foundation; complete staged-diff review is pending.
- **Persistence:** Keep this plan in Git and update it in place; do not delete it after completion or create separate state/handoff/review files.

New-session prompt:

> Read AGENTS.md, plans/README.md, and plans/NB-000-documentation-foundation.md. Inspect Git branch/HEAD and staged/working changes. Verify prerequisites and open questions against the current tree. Continue only the approved scope of NB-000; report actual checks and stop at the staged diff for approval. Do not commit or push.

## 1. Task and intended outcome

The owner can review the project boundaries, architecture, business hypotheses, verification strategy, and persistent task roadmap before runtime work begins.

This is one task/approval unit. If new evidence materially changes it, update this plan and obtain agreement before expanding scope.

## 2. Verified context and proposed files

The owner created a clean RN template and explicitly requested documentation/planning changes in the repository. The owner also confirmed that all documentation and plans must be English.

Existing files: README.md and .gitignore. New files: AGENTS.md, docs/**/*.md, harness/**/README.md, and plans/*.md. App.tsx, native projects, dependencies, and existing tests are outside this task.

Baseline repository revision: `289d710aac77cfa3e8b4985201ca8285e33fabb8`. Predecessor tasks may add the proposed files; a new session must verify they actually exist. Future paths are planned ownership, not claims of implemented APIs. Sources and observation limits: [evidence register](../docs/research/evidence.md).

## 3. Problem framing and decisions

**Solved means:** The owner can review the project boundaries, architecture, business hypotheses, verification strategy, and persistent task roadmap before runtime work begins.

**Shortcut and limit:** A checklist or fake happy-path result is easier to produce, but does not prove the task's behavioral boundary or actual device conditions. Do not use it as completion evidence.

**Chosen approach and cost:** Follow the narrow ownership/files in §2 and the ordered steps below. Preserve native live ownership and shared replay logic; use the relevant proof layer, with device access where required. No backend or sibling-platform work is included.

**Who still has the problem:** Untested devices, OS builds, vehicle/adapter/head-unit configurations and users outside the agreed personal scope. Success of this task does not imply the entire product is complete.

**Decisions:** Persistent tracked plans override temporary-plan guidance. No runtime, executable harness, CI workflow, dependency, or application test changes in this foundation.

Applicable criteria: AGENTS.md; requirements R-01–R-10; [architecture contracts](../docs/architecture/contracts.md); [test strategy](../docs/testing/strategy.md). Numeric quality/resource settings need documented provenance and agreement; proposed structural design is reviewed with the task, not silently treated as established fact.

## 4. Ordered implementation / research steps

### 1. Audit the template and research boundaries

Record versions/current files, owner requirements, the external Waze observation, upstream revisions, and unverified integration assumptions.

**Done when:** Evidence register distinguishes observed, proposed, and measured claims.

### 2. Define documentation and future ownership

Write product/business/architecture/contracts/integration/privacy/test documents and actual-versus-proposed folder structure.

**Done when:** README and documentation index link to every owning document without implying runtime exists.

### 3. Create persistent execution plans

Create one task plan per roadmap task, statuses, dependencies, and session prompts; document approval and Git rules.

**Done when:** A new session can choose a task and see its prerequisites, checks, and blocking questions.

### 4. Review and stage exact documentation

Check Markdown links, scope, plan index, ignored private paths, and whitespace; stage exact changed files and show full diff.

**Done when:** Only the requested documentation foundation is staged; commit and all runtime work await owner approval.

## 5. Language and user-facing copy

All code, documentation and plans are English. The product UI locale is a separate decision (Q-07). No localization catalog or i18n framework exists in the template; do not invent a catalog command. For user-visible changes, agree the supported locale and recovery/error wording before implementation.

## 6. Unit and integration tests

Not applicable: documentation-only change. Do not add or run application tests.

Test paths described as proposed are new files, not existing suites. Tests run only under the approved task scope. Existing JS commands and future native command prerequisites are documented in [development](../docs/engineering/development.md).

## 7. Snapshots and visual checks

Not applicable: no UI changes.

## 8. Manual QA / experiment cases

Read README → plans → NB-001; review contracts/cleanup and harness boundaries; confirm English text and private-data rules.

Record preconditions → actions → expected result → actual observation using [device validation](../docs/testing/device-validation.md). Mark cases not run, pass, fail, blocked or inconclusive; never imply the listed cases already passed.

## 9. Regression scope

Repository links, existing template instructions, tracked plan visibility, .gitignore exceptions, and Git scope only; runtime is unchanged.

Broaden checks only when changed shared consumers, new failures, or unresolved concerns justify it. No unrelated dependency upgrade or architecture cleanup is included.

## 10. Estimate and resource assumptions

No hour estimate, delivery date, hardware purchase or paid-service budget is approved. Feasibility, device availability and measurement-dependent choices make an evidence-based estimate premature. Before implementation, price the concrete approved steps, meaningful automated verification, human device QA/review, documentation and release work; record optimistic/realistic effort and assumptions here if the owner requests an estimate. Do not apply unrelated company ticket gradations or invent a financial forecast.

## 11. Verification and completion

**Current record (2026-10-11):** 38 English Markdown files and .gitignore prepared. Document validation passed for 155 relative links, all 12 plan/index statuses, acyclic prerequisites, private-file ignore rules, and the exact 39-file documentation scope. `git diff --check` passed. Existing application/native/dependency files are unchanged. No application tests, builds, simulator, hardware, Waze, CarPlay, or vehicle checks were run. Complete staged-diff approval remains pending.

- [x] Owner-approved task scope and blocking decisions recorded.
- [x] Prerequisites verified against the current repository and device evidence.
- [x] Ordered steps completed within scope; actual paths/contracts recorded.
- [x] Authorized checks recorded with commands, revision, results and skipped cases.
- [x] Relevant documentation/evidence updated; secrets and private recordings excluded.
- [x] Exact task files staged; full diff supplied for review. Proposed commit: `docs: define NavBridge architecture and implementation roadmap`.
- [x] Owner approved the complete staged result; then mark Complete and update plans/README.md.

Append concise decisions and actual verification here as work proceeds. Do not create a separate handoff/review state file. Complete does not itself grant commit or publication authority.

## 12. Open questions, blockers and exclusions

Owner review of the complete staged documentation is pending. Implementation questions are recorded in docs/research/open-questions.md and do not block this foundation.

Read [the question register](../docs/research/open-questions.md) for cross-task questions. Record answers in the owning document and this plan. Future commercial distribution, automatic map matching, cell/Wi-Fi positioning, CAN/extra IMU hardware, GNSS anomaly detection and Android remain outside this task unless explicitly approved separately.
