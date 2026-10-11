# NB-001: Feasibility and baseline

## 0. Lifecycle and session entry

- **Status:** Implemented — awaiting approval
- **Plan created:** 2026-10-11.
- **Target:** iOS 27 / iPhone, with React Native presentation and native Swift execution. Android is outside scope.
- **Prerequisites:** [NB-000](NB-000-documentation-foundation.md)
- **Approval:** The owner authorized the bounded read-only audit and documentation updates in §13 by asking to execute it. On 2026-10-11, the owner confirmed v1.0 is for their own iPhone on iOS 27, with no paid Apple Developer Program membership, no VPN in NavBridge, and no public release. The embedded packet tunnel is outside this scope. The owner identifies the external tool as Locus `main` run with LocalDevVPN on an iPhone 11 / iOS 27, with the latest App Store Waze version; they report that the GPS location returned after Locus Stop. Exact build identifiers are explicitly waived for NB-001; repeat-update behavior remains unknown and non-blocking at the owner's direction. No runtime implementation or speculative probe is authorized.
- **Persistence:** Keep this plan in Git and update it in place; do not delete it after completion or create separate state/handoff/review files.

New-session prompt:

> Read AGENTS.md, plans/README.md, and plans/NB-001-feasibility-and-baseline.md. Inspect Git branch/HEAD and staged/working changes. Verify prerequisites and open questions against the current tree. Continue only the approved scope of NB-001; report actual checks and stop at the staged diff for approval. Do not commit or push.

## 1. Task and intended outcome

A fresh session knows what the owner actually reproduced, what signing/setup is available, and which decisions and measurements gate implementation.

This is one task/approval unit. If new evidence materially changes it, update this plan and obtain agreement before expanding scope.

## 2. Verified context and proposed files

The owner reports building Locus from its `main` branch for an iPhone 11 running iOS 27, connecting LocalDevVPN, and simulating the phone's location; the earlier report says Waze saw the supplied location. After Locus Stop, the owner reports that GPS location returned. Waze was identified as the latest App Store version. Exact build identifiers are intentionally omitted at the owner's direction. Repeated-update behavior and background behavior remain unknown. No NavBridge native integration exists.

Existing: docs/research/evidence.md, docs/research/open-questions.md, docs/product/requirements.md, docs/testing/device-validation.md. Proposed new reviewed evidence: harness/reports/NB-001-feasibility.md. Any disposable signing probe must be explicitly scoped before it is created; it is not a finished product integration.

Baseline repository revision: `289d710aac77cfa3e8b4985201ca8285e33fabb8`. Predecessor tasks may add the proposed files; a new session must verify they actually exist. Future paths are planned ownership, not claims of implemented APIs. Sources and observation limits: [evidence register](../docs/research/evidence.md).

## 3. Problem framing and decisions

**Solved means:** A fresh session knows what the owner actually reproduced, what signing/setup is available, and which decisions and measurements gate implementation.

**Shortcut and limit:** A checklist or fake happy-path result is easier to produce, but does not prove the task's behavioral boundary or actual device conditions. Do not use it as completion evidence.

**Chosen approach and cost:** Follow the narrow ownership/files in §2 and the ordered steps below. Preserve native live ownership and shared replay logic; use the relevant proof layer, with device access where required. No backend or sibling-platform work is included.

**Who still has the problem:** Untested devices, OS builds, vehicle/adapter/head-unit configurations and users outside the agreed personal scope. Success of this task does not imply the entire product is complete.

**Decisions:** Q-01 is resolved for v1.0: personal iOS 27 use, no paid membership, no VPN in NavBridge, and no public release. The owner-reported Locus/LocalDevVPN test records an external location-set and Stop result; it does not verify the selected no-VPN NavBridge path. Exact build identifiers are not required for NB-001, and repeated updates remain unverified but non-blocking at the owner's direction. Q-08 is partially answered; remaining vehicle, adapter, and reference details affect later measurement tasks. Confirm or defer Q-03/Q-04/Q-05/Q-10 with explicit affected-task blockers. Agreement on this research task does not approve every proposed product decision.

Applicable criteria: AGENTS.md; requirements R-01–R-10; [architecture contracts](../docs/architecture/contracts.md); [test strategy](../docs/testing/strategy.md). Numeric quality/resource settings need documented provenance and agreement; proposed structural design is reviewed with the task, not silently treated as established fact.

## 4. Ordered implementation / research steps

### 1. Capture the external control

Record the tool/source branch and setup, available iOS/Waze versions, recognizable position updates, and clear/stop result; distinguish destination deep links from the vehicle marker. Exact build identifiers are intentionally omitted per owner direction.

**Done when:** The owner-reported external setup and observed location-set/Stop results are recorded, with untested repeat-update behavior labeled unknown and no secrets or real route disclosed.

### 2. Check own-signing and iOS 27 pairing feasibility

Record the owner's no-paid/no-VPN decision. Audit the pinned iOS 27 pairing/output path and distinguish a free personal signing account from a paid Network Extension entitlement. Propose any own-build/device experiment before creating it.

**Done when:** The documented candidate path and remaining own-build/device validation are explicit; no inferred signing or output success.

### 3. Approve measurement and product boundaries

Choose motion mode, heading/mount expectations, stationary-vs-moving correction, independent reference, intended app states and field-use targets. Design latency/gap/calibration observations.

**Done when:** Decisions have owner/date/evidence; unresolved items block only their affected tasks.

### 4. Update the roadmap gates

Record external-control results and own-integration experiments still required in NB-003/NB-004. Update requirements and downstream blockers.

**Done when:** A go/conditional-go/blocked decision names remaining uncertainty and the next authorized task.

## 5. Language and user-facing copy

All code, documentation and plans are English. The product UI locale is a separate decision (Q-07). No localization catalog or i18n framework exists in the template; do not invent a catalog command. For user-visible changes, agree the supported locale and recovery/error wording before implementation.

## 6. Unit and integration tests

No product unit tests in this research task. Inspect existing scripts; do not call a template smoke test proof of feasibility. Any probe check is documented separately.

Test paths described as proposed are new files, not existing suites. Tests run only under the approved task scope. Existing JS commands and future native command prerequisites are documented in [development](../docs/engineering/development.md).

## 7. Snapshots and visual checks

Not applicable: no product screen implementation.

## 8. Manual QA / experiment cases

D-01 external control; consent/setup inspection; deliberate clear and Waze observation while stationary. Record whether any background/connectivity case was actually exercised.

Record preconditions → actions → expected result → actual observation using [device validation](../docs/testing/device-validation.md). Mark cases not run, pass, fail, blocked or inconclusive; never imply the listed cases already passed.

## 9. Regression scope

Leave the owner's working external setup recoverable; do not delete VPN profiles, reset pairing globally, or alter other applications.

Broaden checks only when changed shared consumers, new failures, or unresolved concerns justify it. No unrelated dependency upgrade or architecture cleanup is included.

## 10. Estimate and resource assumptions

No hour estimate, delivery date, hardware purchase or paid-service budget is approved. Feasibility, device availability and measurement-dependent choices make an evidence-based estimate premature. Before implementation, price the concrete approved steps, meaningful automated verification, human device QA/review, documentation and release work; record optimistic/realistic effort and assumptions here if the owner requests an estimate. Do not apply unrelated company ticket gradations or invent a financial forecast.

## 11. Verification and completion

**Current record (2026-10-11):** The §13 documentation audit is recorded in [the NB-001 feasibility report](../harness/reports/NB-001-feasibility.md) at repository revision `0023ac72ebfe8625190833953725e7a770970ba9`. The tree was clean on `main` before these edits. Node `v22.14.0`, npm `10.9.2`, Xcode `27.0` build `27A266a`, and `/Applications/Xcode.app/Contents/Developer` were observed. The template remains RN `0.87.1` / React `19.2.3`, with the generated app bundle identifier and iOS deployment target `15.1`; no tunnel extension or NavBridge location-output implementation exists. Pinned upstream source and license conditions were audited, but no upstream build or artifact was reproduced. The owner confirmed v1.0 is for their own iOS 27 phone, without paid membership, VPN in NavBridge, or public release. The owner reports Locus `main` built for iPhone 11 / iOS 27 with LocalDevVPN connected, location simulation active, and GPS location returning after Stop; Waze was identified as the latest App Store version. Exact build identifiers are intentionally omitted at the owner's direction. Repeat-update behavior remains unknown and non-blocking for NB-001 by that direction. The pinned Locus README describes iOS 27 on-device developer pairing without LocalDevVPN and reserves LocalDevVPN for iOS 18–26; that upstream candidate does not establish that the owner's reported build used the same path or that NavBridge works without VPN. The paid Network Extension capability is irrelevant to the selected no-VPN scope. Free-team NavBridge signing, pairing, output, and own-build clear/recovery remain unverified. D-01 is an owner-reported external result, not reproduced in this session. No app tests, build, simulator, or device check was run in this session; no CarPlay or vehicle check was run.

- [x] Owner-authorized §13 documentation scope and confirmed v1.0 boundary recorded; motion and measurement decisions remain unresolved.
- [x] NB-000 documentation prerequisite and available repository/device evidence verified; the only device observation remains owner-reported.
- [x] Ordered documentation/research steps completed within the agreed scope; D-01 records the owner-reported set/Stop result, while repeated updates remain unknown; free-team signing/pairing/output validation is explicitly deferred to NB-004.
- [x] Authorized read-only checks recorded with commands, revision, results and skipped cases in the report.
- [x] Relevant evidence/report updated; no secrets or private recordings included.
- [x] Exact task files staged; full diff and commit message presented.
- [ ] Owner approved the complete staged result; then mark Complete and update plans/README.md.

Append concise decisions and actual verification here as work proceeds. Do not create a separate handoff/review state file. Complete does not itself grant commit or publication authority.

## 12. Open questions, blockers and exclusions

Q-01 is resolved for v1.0: own iOS 27 phone, no paid Apple Developer Program membership, no VPN in NavBridge, and no public release. The embedded tunnel is out of scope; the paid Network Extension entitlement is not a blocker for this selected design. Free-team signing and the pinned iOS 27 developer-pairing/location-output path still need an explicitly approved own-build/device experiment in NB-004. The current NB-003/NB-004 plans describe a tunnel-dependent design and must be reconciled before implementation. Q-02 is resolved enough to unblock NB-001: the owner identifies Locus `main` built for iPhone 11 / iOS 27 and used with LocalDevVPN; Waze was identified as the latest App Store version, and GPS location returned after Stop. Exact build identifiers are omitted at the owner's direction; repeated-update behavior is unknown and non-blocking for this baseline. D-01 is owner-reported, not independently reproduced. Q-08 is partially answered; remaining vehicle/adapter/reference details are for downstream measurement tasks. Independent source and documentation work can proceed.

Read [the question register](../docs/research/open-questions.md) for cross-task questions. Record answers in the owning document and this plan. Future commercial distribution, automatic map matching, cell/Wi-Fi positioning, CAN/extra IMU hardware, GNSS anomaly detection and Android remain outside this task unless explicitly approved separately.

## 13. Detailed execution guide for a smaller coding model

### Mission and authority

Your job is to establish a truthful feasibility baseline and return a reviewed documentation patch. Do not implement the full application, create a native module, copy upstream code, install a VPN, pair a phone, change signing, or run vehicle commands in this session. These actions belong to later approved tasks or an explicitly approved experiment.

The owner asking you to execute this plan authorizes its read-only audit and documentation updates. It does not approve a speculative product implementation. Never guess a device result, membership status, BLE UUID, sampling rate, quality threshold, price, or dependency license.

Use the existing files below. Do not create another plan, task-state JSON, handoff, or implementation checklist file. Record outcomes in this plan and the named reviewed report. If the owner cannot perform a device action during this session, finish the independent audit, record that case as not run/blocked, and stop honestly.

### A. Read these files in this order

1. Global instructions supplied by the runtime, then repository `AGENTS.md`.
2. `README.md` and `plans/README.md`.
3. This complete plan and `plans/NB-000-documentation-foundation.md`.
4. `docs/product/requirements.md` and `docs/research/open-questions.md`.
5. `docs/research/evidence.md` and `docs/engineering/ios-integration.md`.
6. `docs/testing/device-validation.md`, `docs/testing/acceptance.md`, and `docs/engineering/privacy-and-licensing.md`.
7. `package.json`, `jest.config.js`, `ios/NavBridge/AppDelegate.swift`, and `ios/NavBridge.xcodeproj/project.pbxproj`.

Check that the paths exist. If a predecessor has changed the design, read the current diff and reconcile it with this plan before proceeding. Do not re-audit unrelated Android files or another repository.

### B. Run only these initial read-only checks

Run from the NavBridge repository root; collect the results without changing branch, files or signing:

```bash
git status --short --branch
git rev-parse HEAD
git diff --stat
git diff --cached --stat
git branch --list
node --version
npm --version
xcodebuild -version
xcode-select -p
```

Inspect relevant dirty/staged files before touching them. A missing command is a reported environment issue, not permission to install a tool. Do not run `npm ci`, `pod install`, `npm test`, a build, a device command, Git checkout/reset/stash, or remote publishing as part of this initial audit.

Report the actual branch/revision and whether the tree has unrelated work. The reference planning revision is historical; do not reset to it. Recheck template versions and product-file presence rather than copying the old baseline as current fact.

### C. Ask one concise batch of owner questions

Ask in the owner's conversation language; maintain English repository records. Skip questions already answered in the current session or updated documents.

- The owner has answered the membership question: no paid Apple Developer Program membership for v1.0. Do not ask again or request credentials/account screenshots. Verify only the free-team signing and iOS 27 pairing path when an approved own-build experiment is planned.
- The owner identifies Locus `main` built for iPhone 11 / iOS 27 and run with LocalDevVPN, and reports GPS location returned after Stop. Exact build identifiers are waived for NB-001. Repeated-update behavior remains unknown and is non-blocking by owner direction.
- What adapter identification/firmware evidence and head-unit/connection type are available?
- Does the owner accept a rigid phone mount, manual initial heading, forward-only baseline, and initially stationary corrections? If reverse is required, ask whether a manual forward/reverse control is acceptable.
- What intended outage/use duration, accuracy/intervention expectations, and app states matter? What independent reference is available for later field tests?

The external-control result is sufficient to unblock this baseline under the owner's instruction; exact build identifiers are not required, and repeated-update behavior remains an explicit unknown. Motion/accuracy answers may remain explicitly blocked for NB-006/NB-009. Do not turn silence into approval or invent numeric defaults. Recording/map/locale questions can remain for their owning plans; do not overwhelm this session with every future choice.

### D. Reproduce the owner's external control only if available

This is an owner-operated stationary experiment with the existing working tool; do not automate or alter that tool's installation/profile. Agree the steps before the owner performs them:

1. Record the external tool/source branch, available Waze/iOS versions, and whether its helper VPN is active. The owner waived exact build identifiers for NB-001. No pairing secrets or private identifiers in repository notes.
2. On a stationary phone/vehicle, select an owner-chosen recognizable test position. Keep real test coordinates outside Git.
3. Open Waze and observe the vehicle marker. Opening a destination/map pin is not equivalent to setting the current location.
4. If supported by the current setup, make deliberate position changes and record whether Waze follows them. Record actual elapsed observations; do not prescribe an unsupported duration as a product target.
5. Use the tool's clear/stop action. Record its acknowledgement separately from the visible Waze/system result. If restoration is unclear, mark it unknown; do not claim that closing the app or tunnel restores GPS.
6. Record whether Waze-foreground/background, lock/unlock, Wi-Fi/cellular, and CarPlay were tested. Untested combinations stay not run.

Do not create a new simulated coordinate during cleanup, remove another app's VPN, or reset pairing. If the working setup cannot be safely reproduced, record the exact limitation and leave the environment as found.

The owner reports that GPS location returned after using Locus Stop. Repeated position updates were not reported; record them as unknown without blocking NB-001.

### E. Audit own-build feasibility without implementing it

Read the pinned Locus and LocalDevVPN evidence in `docs/research/evidence.md`. If live source verification is needed, use the configured GitHub connector or the owner's external browser; no in-app browser. Limit the audit to the cited repository/revision/license and relevant integration files.

Write a short table with these rows:

| Capability | Evidence to record | If absent |
|---|---|---|
| Free-team app signing and iOS 27 pairing | Owner-confirmed no-paid/no-VPN scope plus pinned Locus iOS 27 instructions | Block NB-004 own-build/output validation if signing or pairing is unavailable |
| App/extension identifiers | Proposed unique identifiers, still owner-approved before use | Leave unset; never use another project's ID |
| LocalDevVPN applicability | Pinned Locus README's OS-specific setup and the owner's no-VPN iOS 27 decision | No tunnel or route reuse in v1.0; retain the iOS 18–26 upstream note as context only |
| Pairing/output dependency | Source revision, reproducible-build work still needed | Assign to NB-004; do not vendor the binary |
| Clear/restart semantics | External observation vs own-build unknowns | Keep NB-004 recovery gate open |
| Waze-foreground execution | Exact observed app-state behavior | Keep NB-009 gate open |

A future minimal signing/output probe may be useful, but propose its exact code/device scope and checks before creating it. NB-001 can finish the research baseline without pretending NB-003/NB-004 own-build integration has passed. If the owner authorizes a probe, update this plan first with its files, device actions and success conditions; do not grow it into the product silently.

### F. Make only the named documentation changes

Allowed changes for the default NB-001 session:

- This plan: status, answered decisions, commands/results, experiment observations and next blockers.
- `plans/README.md`: matching task status only.
- `docs/research/evidence.md`: new actual observations with provenance/date/limits.
- `docs/research/open-questions.md`: owner answers and measured unknowns, no secrets.
- `docs/product/requirements.md`: only owner-confirmed decisions, retaining their provenance.
- `docs/testing/device-validation.md`: refine the now-reproducible control procedure if needed.
- New `harness/reports/NB-001-feasibility.md`: reviewed redacted baseline summary.

Do not edit `App.tsx`, `package.json`, lockfiles, Podfile, Xcode project, entitlements, native source or `.gitignore` in the default research task. Do not create empty runtime folders.

The report must contain: actual date/revision/environment; owner-reported vs directly observed results; each test's preconditions/actions/expected/actual/status; signing availability; answered decisions; unresolved blockers; explicit own-build/background/CarPlay/accuracy limitations; next task recommendation. Never call external-tool success an own-build pass.

### G. Check documents, then stage and stop

Review every new relative Markdown link and ensure its target exists. Check the report and staged files for private locations, credentials, raw identifiers and build products. Run `git diff --check` for whitespace. Do not run application tests for a documentation-only result.

Use `git add --` with only the exact files you actually changed from the allowlist above; never stage the whole directory. Show `git diff --cached --stat` and the full `git diff --cached`. Proposed commit message:

```text
docs: record NavBridge feasibility baseline
```

Do not commit or push. A task may be Implemented — awaiting approval when the scoped audit and baseline report are complete even if later product gates remain open. If a required NB-001 control/signing answer itself is unavailable, mark this task Blocked with the exact missing input. Mark Complete only after owner approval and update the plan/index together.

### H. Final response format

Answer briefly in the owner's language: what was verified; what remains owner-reported or not run; which decisions/blockers remain; exact staged files and proposed commit message; recommended next task with its prerequisite. Never end by claiming the app now works.

### Ready-to-paste prompt for the first new session

> Work in ~/Developer/NavBridge. Read AGENTS.md, plans/README.md, and the complete plans/NB-001-feasibility-and-baseline.md, including section 13. Execute the default NB-001 research/documentation scope step by step. Inspect Git first; preserve unrelated changes. Ask only unanswered blocking questions and continue independent read-only audit while waiting. Do not implement runtime code, install dependencies, change signing/VPN/pairing, run application tests, or claim unobserved device results. Update the existing plan and the named evidence documents/report in English. Stage only exact task files, show the full staged diff, propose a commit message, then stop without committing or pushing.
