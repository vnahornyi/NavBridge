# NB-002: Native core and session contract

## 0. Lifecycle and session entry

- **Status:** Implemented — awaiting approval
- **Plan created:** 2026-10-11.
- **Target:** iOS 27 / iPhone, with React Native presentation and native Swift execution. Android is outside scope.
- **Prerequisites:** [NB-001](NB-001-feasibility-and-baseline.md)
- **Approval:** The owner approved the NB-002 scope and command/session semantics in chat on 2026-10-12. React Native 0.87.1 Codegen accepted the flat nullable DTOs, Promise methods, and event emitter; no material contract change was needed. The workspace link remains unverified because the checked-in Pods project predates this Codegen spec and CocoaPods CLI is unavailable in the current environment.
- **Persistence:** Keep this plan in Git and update it in place; do not delete it after completion or create separate state/handoff/review files.

New-session prompt:

> Read AGENTS.md, plans/README.md, and plans/NB-002-native-session-contract.md. Inspect Git branch/HEAD and staged/working changes. Verify prerequisites and open questions against the current tree. Continue only the approved scope of NB-002; report actual checks and stop at the staged diff for approval. Do not commit or push.

## 1. Task and intended outcome

One native session owns validated commands/state, and the same deterministic decision core can be called from the iOS host and tests without BLE/VPN/Waze.

This is one task/approval unit. If new evidence materially changes it, update this plan and obtain agreement before expanding scope.

## 2. Verified context and proposed files

The template has a Swift AppDelegate and RN New Architecture. NB-002 adds the Codegen spec and a local NavBridge Swift package; docs/architecture/contracts.md and session-lifecycle.md remain contracts requiring transport validation.

Implemented: specs/NativeNavBridge.ts; src/native/nav-bridge-types.ts; src/native/nav-bridge-client.ios.ts and its focused tests; native/NavBridgeCore/Package.swift, model/session sources and tests; ios/NavBridge/Bridge/NavBridgeSessionService.swift and RCTNavBridge.mm. Integration points: package.json and ios/NavBridge.xcodeproj/project.pbxproj. Generated Codegen output stays under ignored build/temp paths and is not tracked.

Baseline repository revision: `289d710aac77cfa3e8b4985201ca8285e33fabb8`. Predecessor tasks may add the proposed files; a new session must verify they actually exist. Future paths are planned ownership, not claims of implemented APIs. Sources and observation limits: [evidence register](../docs/research/evidence.md).

## 3. Problem framing and decisions

**Solved means:** One native session owns validated commands/state, and the same deterministic decision core can be called from the iOS host and tests without BLE/VPN/Waze.

**Shortcut and limit:** A checklist or fake happy-path result is easier to produce, but does not prove the task's behavioral boundary or actual device conditions. Do not use it as completion evidence.

**Chosen approach and cost:** Follow the narrow ownership/files in §2 and the ordered steps below. Preserve native live ownership and shared replay logic; use the relevant proof layer, with device access where required. No backend or sibling-platform work is included.

**Who still has the problem:** Untested devices, OS builds, vehicle/adapter/head-unit configurations and users outside the agreed personal scope. Success of this task does not imply the entire product is complete.

**Approved decisions (owner, 2026-10-12):** Native state is authoritative. Start enters `preparing` and becomes `active` only after prerequisites and the first output effect are acknowledged. Corrections require a position, heading, or both; omitted values are retained, and empty corrections are rejected. Duplicate request IDs do not repeat effects. Session/generation tokens fence stale work; Stop supersedes pending work. A failed or unknown clear enters `cleanupRequired`. Snapshots use an increasing sequence, and reconnect obtains a snapshot then subscribes without losing a transition. Codegen uses flat, validated DTOs if the RN 0.87.1 compile proof does not support the conceptual union shapes. No OS transport or estimator math is in this task.

**Codegen proof:** RN 0.87.1 generated the expected iOS provider mapping (`NativeNavBridge` → `RCTNavBridge`), nullable flat fields, Promise methods, and `onSessionUpdate`. Additional corrections while a correction is pending are rejected with `commandConflict`; they are not queued or coalesced.

Applicable criteria: AGENTS.md; requirements R-01–R-10; [architecture contracts](../docs/architecture/contracts.md); [test strategy](../docs/testing/strategy.md). Numeric quality/resource settings need documented provenance and agreement; proposed structural design is reviewed with the task, not silently treated as established fact.

## 4. Ordered implementation / research steps

### 1. Prove build integration

Create the minimal Swift package and host linkage plus Codegen spec. Validate supported record/event/Promise types against RN 0.87.1.

**Done when:** The iOS host links a real callable module and the package tests run independently; commands are recorded.

### 2. Implement pure contract validation and transitions

Implement anchor/nonempty partial correction validation, phases, session/generation/request ordering, quality states, structured errors, and effect descriptions.

**Done when:** Invalid input cannot produce output; native state is authoritative; tests cover all declared transitions.

### 3. Connect the native owner and JS boundary

Implement command dispatch and race-free snapshot/subscription semantics. Keep screen/JS reload independent of the session.

**Done when:** Reattach returns current state without duplicate sessions or a lost transition; no fake transport is labelled live.

### 4. Verify cancellation and build scope

Use fake effects for pending setup/set/clear callbacks, duplicated commands, Stop/correction races and invalidation. Update contracts with actual supported shapes.

**Done when:** Authorized tests/build checks pass or precise limitations are recorded; Android and unrelated template behavior remain outside the patch.

## 5. Language and user-facing copy

All code, documentation and plans are English. The product UI locale is a separate decision (Q-07). No localization catalog or i18n framework exists in the template; do not invent a catalog command. For user-visible changes, agree the supported locale and recovery/error wording before implementation.

## 6. Unit and integration tests

Proposed SessionTests.swift: invalid/non-finite anchor; empty/partial correction; duplicate request; stale session/generation; Start→prepare→active only after acknowledgement; Stop during every setup boundary; set completion after cancellation; clear failure→cleanupRequired; snapshot sequence ordering. Proposed src/native/__tests__/nav-bridge-client.test.ts: mapping/subscription lifecycle using a narrow fake native boundary.

Test paths described as proposed are new files, not existing suites. Tests run only under the approved task scope. Existing JS commands and future native command prerequisites are documented in [development](../docs/engineering/development.md).

## 7. Snapshots and visual checks

Not applicable: native contract and client only; no product screen.

## 8. Manual QA / experiment cases

Build/link on the approved iOS environment; call commands using a development-only test boundary without real location injection; reload JS and reattach snapshots. Do not ship a fake active/live mode.

Record preconditions → actions → expected result → actual observation using [device validation](../docs/testing/device-validation.md). Mark cases not run, pass, fail, blocked or inconclusive; never imply the listed cases already passed.

## 9. Regression scope

Template app registration, CocoaPods linkage, Swift host launch, package locks if deliberately changed, Codegen regeneration, JS subscription cleanup.

Broaden checks only when changed shared consumers, new failures, or unresolved concerns justify it. No unrelated dependency upgrade or architecture cleanup is included.

## 10. Estimate and resource assumptions

No hour estimate, delivery date, hardware purchase or paid-service budget is approved. Feasibility, device availability and measurement-dependent choices make an evidence-based estimate premature. Before implementation, price the concrete approved steps, meaningful automated verification, human device QA/review, documentation and release work; record optimistic/realistic effort and assumptions here if the owner requests an estimate. Do not apply unrelated company ticket gradations or invent a financial forecast.

## 11. Verification and completion

**Current record (2026-10-12):** Implementation is ready for owner review. `SessionCoordinator.shared` deliberately uses an unavailable effect runner, so the bridge cannot claim a live output or enter `active` in production in this task.

- [x] Owner-approved task scope and decisions recorded; prerequisites verified against the current repository.
- [x] Native state machine, local Swift package, flat Codegen spec, iOS provider, Swift service, and JS snapshot/subscription client implemented at the paths in §2.
- [x] `swift test --package-path native/NavBridgeCore`: 11 tests passed on macOS arm64e.
- [x] `npm test -- --runInBand --watchman=false`: 2 suites, 6 tests passed. Watchman was disabled because its socket permission check fails in this environment.
- [x] `npx --no-install tsc --noEmit`: passed.
- [x] `node node_modules/react-native/scripts/generate-codegen-artifacts.js --path . --targetPlatform ios --outputPath /private/tmp/navbridge-codegen-nb002-final`: passed; generated provider map includes `NativeNavBridge` → `RCTNavBridge`.
- [x] `plutil -lint ios/NavBridge.xcodeproj/project.pbxproj`: passed.
- [x] Generic iOS Simulator build attempted with Xcode 27. The unmodified workspace build stopped because the installed `Pods.xcodeproj` does not expose the new generated `ReactCodegen/NavBridgeSpec/NavBridgeSpec.h`. With a temporary search path to fresh Codegen output, Swift and ObjC++ source compilation proceeded, then linking failed because the stale Pods project lacks `NativeNavBridgeSpecBase` and `NativeNavBridgeSpecJSI` generated symbols. `pod`/CocoaPods is not installed, so `pod install` could not be run. The local Swift package itself resolved in Xcode.
- [x] No simulator was launched. Device, Waze, CarPlay, vehicle, location-output, transport, and estimator runtime checks were not run.
- [x] Exact task files staged; full staged diff and proposed commit message presented for owner review.
- [ ] Owner approved the complete staged result; then mark Complete and update plans/README.md.

Append concise decisions and actual verification here as work proceeds. Do not create a separate handoff/review state file. Complete does not itself grant commit or publication authority.

## 12. Open questions, blockers and exclusions

No product decision remains open for NB-002. Full workspace link verification awaits a CocoaPods installation that regenerates the existing Pods project from the new Codegen spec; the current environment has no `pod` executable. Device-signing blockers are outside this task.

Read [the question register](../docs/research/open-questions.md) for cross-task questions. Record answers in the owning document and this plan. Future commercial distribution, automatic map matching, cell/Wi-Fi positioning, CAN/extra IMU hardware, GNSS anomaly detection and Android remain outside this task unless explicitly approved separately.
