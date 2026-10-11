# NB-004: Location output and pairing

## 0. Lifecycle and session entry

- **Status:** Draft
- **Plan created:** 2026-10-11.
- **Target:** iOS 27 / iPhone, with React Native presentation and native Swift execution. Android is outside scope.
- **Prerequisites:** [NB-001](NB-001-feasibility-and-baseline.md), [NB-002](NB-002-native-session-contract.md), [NB-003](NB-003-integrated-local-tunnel.md)
- **Approval:** Draft only. Documentation approval does not authorize this implementation. Obtain owner approval of this task and its blocking decisions before code.
- **Persistence:** Keep this plan in Git and update it in place; do not delete it after completion or create separate state/handoff/review files.

New-session prompt:

> Read AGENTS.md, plans/README.md, and plans/NB-004-location-output-and-pairing.md. Inspect Git branch/HEAD and staged/working changes. Verify prerequisites and open questions against the current tree. Continue only the approved scope of NB-004; report actual checks and stop at the staged diff for approval. Do not commit or push.

## 1. Task and intended outcome

Own-build NavBridge pairs, supplies a deliberate stationary coordinate to Waze, and clears it with honest acknowledgement/recovery semantics.

This is one task/approval unit. If new evidence materially changes it, update this plan and obtain agreement before expanding scope.

## 2. Verified context and proposed files

Locus/idevice provides a reference mechanism. The owner's external-tool observation is a control, not this integration. Clearing a fresh connection and cleanup after process loss are unverified.

Proposed new: ios/NavBridge/LocationOutput/ pairing/store/FFI wrapper and output implementation; native effect-boundary tests; source/build/notices manifest near any selected vendor integration. Existing: iOS project/link settings and docs/engineering/privacy-and-licensing.md. Record reviewed evidence in harness/reports/NB-004-location-output.md.

Baseline repository revision: `289d710aac77cfa3e8b4985201ca8285e33fabb8`. Predecessor tasks may add the proposed files; a new session must verify they actually exist. Future paths are planned ownership, not claims of implemented APIs. Sources and observation limits: [evidence register](../docs/research/evidence.md).

## 3. Problem framing and decisions

**Solved means:** Own-build NavBridge pairs, supplies a deliberate stationary coordinate to Waze, and clears it with honest acknowledgement/recovery semantics.

**Shortcut and limit:** A checklist or fake happy-path result is easier to produce, but does not prove the task's behavioral boundary or actual device conditions. Do not use it as completion evidence.

**Chosen approach and cost:** Follow the narrow ownership/files in §2 and the ordered steps below. Preserve native live ownership and shared replay logic; use the relevant proof layer, with device access where required. No backend or sibling-platform work is included.

**Who still has the problem:** Untested devices, OS builds, vehicle/adapter/head-unit configurations and users outside the agreed personal scope. Success of this task does not imply the entire product is complete.

**Decisions:** Approve the on-device pairing flow, secret storage/delete policy, FFI build source, set/clear ownership, and crash recovery marker. If fresh-handle clear cannot be proven, expose the limitation and do not fabricate a setup coordinate.

Applicable criteria: AGENTS.md; requirements R-01–R-10; [architecture contracts](../docs/architecture/contracts.md); [test strategy](../docs/testing/strategy.md). Numeric quality/resource settings need documented provenance and agreement; proposed structural design is reviewed with the task, not silently treated as established fact.

## 4. Ordered implementation / research steps

### 1. Reproduce dependency builds

Select exact idevice/transitive revisions; build required device/simulator slices, record toolchain/recipe/hashes and notices. Avoid blindly importing the opaque upstream archive.

**Done when:** Selected artifacts are reproducible and link to the own signed app, with licenses checked.

### 2. Implement pairing and connection ownership

Use narrow native setup methods with restricted storage, redacted errors, explicit invalid/revoked pairing recovery, and app-owned tunnel dependency.

**Done when:** Pair/unpair/retry behavior works on the target phone without secrets in logs/Git.

### 3. Implement ordered output and recovery

Expose set/clear acknowledgements; write outstanding marker before output; clear marker only after confirmed clear. Reconcile late sets and retain transport until cleanup; test new-process recovery.

**Done when:** Stop never reports success after unknown clear; restart attempts recovery before new output.

### 4. Prove stationary Waze integration

Repeat controlled distinct-coordinate set/clear, ongoing updates, canceled startup, tunnel interruption and process restart with the own build.

**Done when:** A sanitized report distinguishes API acknowledgement, actual Waze observation, and any unresolved system restoration behavior.

## 5. Language and user-facing copy

All code, documentation and plans are English. The product UI locale is a separate decision (Q-07). No localization catalog or i18n framework exists in the template; do not invent a catalog command. For user-visible changes, agree the supported locale and recovery/error wording before implementation.

## 6. Unit and integration tests

Fake FFI/connection boundary tests: pairing absent/rejected/revoked; set success/failure/unknown; clear success/failure/unknown; set completes after Stop; correction invalidates queued set; minimal-marker write failure; restart marker; fresh-handle clear; handle lifetime and first-error preservation. Verify real FFI separately.

Test paths described as proposed are new files, not existing suites. Tests run only under the approved task scope. Existing JS commands and future native command prerequisites are documented in [development](../docs/engineering/development.md).

## 7. Snapshots and visual checks

Not applicable; later RN tests display structured setup/cleanup states.

## 8. Manual QA / experiment cases

D-02/D-06/D-07 output portions while stationary; repeat clear through an existing and fresh connection, tunnel loss, app termination, reinstall/re-pair where authorized. Never assume closing a handle restores location.

Record preconditions → actions → expected result → actual observation using [device validation](../docs/testing/device-validation.md). Mark cases not run, pass, fail, blocked or inconclusive; never imply the listed cases already passed.

## 9. Regression scope

Own VPN lifecycle/Internet, Swift/RN linkage, privacy of pairing material, clean template launch, real location restoration after experiments.

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

[BLOCKING] NB-003 signed transport; source/build/license provenance; actual phone access. Unproven cleanup behavior blocks a usable live positioning claim.

Read [the question register](../docs/research/open-questions.md) for cross-task questions. Record answers in the owning document and this plan. Future commercial distribution, automatic map matching, cell/Wi-Fi positioning, CAN/extra IMU hardware, GNSS anomaly detection and Android remain outside this task unless explicitly approved separately.
