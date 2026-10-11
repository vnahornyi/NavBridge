# NB-008: Control screen and correction

## 0. Lifecycle and session entry

- **Status:** Draft
- **Plan created:** 2026-10-11.
- **Target:** iOS 27 / iPhone, with React Native presentation and native Swift execution. Android is outside scope.
- **Prerequisites:** [NB-002](NB-002-native-session-contract.md), [NB-004](NB-004-location-output-and-pairing.md), [NB-005](NB-005-viecar-obd.md), [NB-006](NB-006-motion-and-dead-reckoning.md), [NB-007](NB-007-recording-and-replay-harness.md)
- **Approval:** Draft only. Documentation approval does not authorize this implementation. Obtain owner approval of this task and its blocking decisions before code.
- **Persistence:** Keep this plan in Git and update it in place; do not delete it after completion or create separate state/handoff/review files.

New-session prompt:

> Read AGENTS.md, plans/README.md, and plans/NB-008-control-screen-and-correction.md. Inspect Git branch/HEAD and staged/working changes. Verify prerequisites and open questions against the current tree. Continue only the approved scope of NB-008; report actual checks and stop at the staged diff for approval. Do not commit or push.

## 1. Task and intended outcome

The owner can set position/heading, Start/Stop one authoritative native session, inspect actionable quality/recovery states, and confirm or cancel manual corrections.

This is one task/approval unit. If new evidence materially changes it, update this plan and obtain agreement before expanding scope.

## 2. Verified context and proposed files

App.tsx still displays the template. No approved Figma exists. The requested functional UI is a manual coordinate map plus primary Start/Stop, with setup/correction actions kept explicit. Heading/motion/map decisions must already be settled.

Proposed new: src/app/nav-bridge-app.tsx; src/features/navigation-session/navigation-session-screen.tsx, use-navigation-session.ts, coordinate-picker.tsx, heading-picker.tsx, session-status.tsx, session-toggle.tsx, and __tests__/navigation-session-screen.test.tsx. Existing: App.tsx entry wiring and package files only for approved map/testing dependencies.

Baseline repository revision: `289d710aac77cfa3e8b4985201ca8285e33fabb8`. Predecessor tasks may add the proposed files; a new session must verify they actually exist. Future paths are planned ownership, not claims of implemented APIs. Sources and observation limits: [evidence register](../docs/research/evidence.md).

## 3. Problem framing and decisions

**Solved means:** The owner can set position/heading, Start/Stop one authoritative native session, inspect actionable quality/recovery states, and confirm or cancel manual corrections.

**Shortcut and limit:** A checklist or fake happy-path result is easier to produce, but does not prove the task's behavioral boundary or actual device conditions. Do not use it as completion evidence.

**Chosen approach and cost:** Follow the narrow ownership/files in §2 and the ordered steps below. Preserve native live ownership and shared replay logic; use the relevant proof layer, with device access where required. No backend or sibling-platform work is included.

**Who still has the problem:** Untested devices, OS builds, vehicle/adapter/head-unit configurations and users outside the agreed personal scope. Success of this task does not imply the entire product is complete.

**Decisions:** [BLOCKING] Q-07 map library/provider, online/offline behavior and UI locale; Q-10 correction behavior. Confirm screen content/states and dependency choice before writing UI. English documentation does not independently choose the product locale.

Applicable criteria: AGENTS.md; requirements R-01–R-10; [architecture contracts](../docs/architecture/contracts.md); [test strategy](../docs/testing/strategy.md). Numeric quality/resource settings need documented provenance and agreement; proposed structural design is reviewed with the task, not silently treated as established fact.

## 4. Ordered implementation / research steps

### 1. Agree functional setup and screen states

Map idle/preparing/active/correcting/stopping/faulted/cleanupRequired snapshots to controls and specific retry/settings actions. Confirm heading and supported motion mode messaging.

**Done when:** Owner agrees functional structure, provider terms and dependency blast radius; no visual-parity claim is implied.

### 2. Implement native-driven controls

Submit commands, render native snapshots, keep Stop usable during setup and cleanup, prevent duplicate taps, and reattach after JS reload.

**Done when:** The UI never optimistically claims active/stopped before native acknowledgement or owns a JS estimator loop.

### 3. Implement anchor drafts and atomic correction

Keep map/coordinate/heading edits local until confirmation; cancel does nothing; show preserved vs changed fields; include coordinate entry for the agreed offline fallback.

**Done when:** Position-only and heading-only correction send valid partial commands; old snapshot/event cannot overwrite a newer generation.

### 4. Verify behavior and accessibility

Add focused command/state tests and justified snapshots, then authorized simulator/device smoke with Dynamic Type, themes and screen sizes.

**Done when:** Busy/error/empty/offline states and accessible controls work; actual device/output limitations remain visible.

## 5. Language and user-facing copy

All code, documentation and plans are English. The product UI locale is a separate decision (Q-07). No localization catalog or i18n framework exists in the template; do not invent a catalog command. For user-visible changes, agree the supported locale and recovery/error wording before implementation.

## 6. Unit and integration tests

Proposed navigation-session-screen.test.tsx: validated Start command; invalid anchor; denied setup; busy repeated taps; Stop while preparing; native failure; failed clear/retry; correction cancel/position-only/heading-only/combined; missing map/network; reattach snapshot ordering; subscription cleanup and accessibility labels. Select compatible Testing Library before dependency edits.

Test paths described as proposed are new files, not existing suites. Tests run only under the approved task scope. Existing JS commands and future native command prerequisites are documented in [development](../docs/engineering/development.md).

## 7. Snapshots and visual checks

Propose focused session-status/session-toggle snapshots for idle, preparing, active, faulted, cleanupRequired only if stable/meaningful. Keep third-party map internals and whole-screen layout out; owner owns visual QA.

## 8. Manual QA / experiment cases

First setup → position/heading → Start → Waze → return/correct → Stop; denied permission, missing adapter, offline map, cleanupRequired, back navigation/JS reload, small/large screens, Dynamic Type and both themes.

Record preconditions → actions → expected result → actual observation using [device validation](../docs/testing/device-validation.md). Mark cases not run, pass, fail, blocked or inconclusive; never imply the listed cases already passed.

## 9. Regression scope

RN entry registration/safe area; bridge subscription and commands; native state ownership; template smoke test updated for real app; no Android implementation or unrelated dependencies.

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

[BLOCKING] Approved map/locale/screen decisions and functioning predecessors. Visual polish beyond agreed functional scope requires an assigned design task.

Read [the question register](../docs/research/open-questions.md) for cross-task questions. Record answers in the owning document and this plan. Future commercial distribution, automatic map matching, cell/Wi-Fi positioning, CAN/extra IMU hardware, GNSS anomaly detection and Android remain outside this task unless explicitly approved separately.
