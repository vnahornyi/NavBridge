# NB-003: Integrated local tunnel

## 0. Lifecycle and session entry

- **Status:** Draft
- **Plan created:** 2026-10-11.
- **Target:** iOS 27 / iPhone, with React Native presentation and native Swift execution. Android is outside scope.
- **Prerequisites:** [NB-001](NB-001-feasibility-and-baseline.md), [NB-002](NB-002-native-session-contract.md)
- **Approval:** Draft only. Documentation approval does not authorize this implementation. Obtain owner approval of this task and its blocking decisions before code.
- **Persistence:** Keep this plan in Git and update it in place; do not delete it after completion or create separate state/handoff/review files.

New-session prompt:

> Read AGENTS.md, plans/README.md, and plans/NB-003-integrated-local-tunnel.md. Inspect Git branch/HEAD and staged/working changes. Verify prerequisites and open questions against the current tree. Continue only the approved scope of NB-003; report actual checks and stop at the staged diff for approval. Do not commit or push.

## 1. Task and intended outcome

NavBridge manages its own signed local packet tunnel with clear consent/state/cleanup, while ordinary phone networking remains usable.

This is one task/approval unit. If new evidence materially changes it, update this plan and obtain agreement before expanding scope.

## 2. Verified context and proposed files

LocalDevVPN at the pinned revision is a mechanism reference under a custom license. No tunnel target or product entitlements exist in NavBridge. Tunnel success alone cannot prove location output or background execution.

Proposed new: ios/NavBridgeTunnel/PacketTunnelProvider.swift, Info.plist, NavBridgeTunnel.entitlements; ios/NavBridge/Tunnel/ manager and integration tests. Existing: ios/NavBridge.xcodeproj/project.pbxproj and app entitlements if added. Update docs/engineering/ios-integration.md and dependency notices if code is reused.

Baseline repository revision: `289d710aac77cfa3e8b4985201ca8285e33fabb8`. Predecessor tasks may add the proposed files; a new session must verify they actually exist. Future paths are planned ownership, not claims of implemented APIs. Sources and observation limits: [evidence register](../docs/research/evidence.md).

## 3. Problem framing and decisions

**Solved means:** NavBridge manages its own signed local packet tunnel with clear consent/state/cleanup, while ordinary phone networking remains usable.

**Shortcut and limit:** A checklist or fake happy-path result is easier to produce, but does not prove the task's behavioral boundary or actual device conditions. Do not use it as completion evidence.

**Chosen approach and cost:** Follow the narrow ownership/files in §2 and the ordered steps below. Preserve native live ownership and shared replay logic; use the relevant proof layer, with device access where required. No backend or sibling-platform work is included.

**Who still has the problem:** Untested devices, OS builds, vehicle/adapter/head-unit configurations and users outside the agreed personal scope. Success of this task does not imply the entire product is complete.

**Decisions:** [BLOCKING] Q-01 paid signing and owner-approved unique bundle identifiers. Review LocalDevVPN license/reuse scope before copying. Derive exact routes from the selected developer transport, not an arbitrary subnet.

Applicable criteria: AGENTS.md; requirements R-01–R-10; [architecture contracts](../docs/architecture/contracts.md); [test strategy](../docs/testing/strategy.md). Numeric quality/resource settings need documented provenance and agreement; proposed structural design is reviewed with the task, not silently treated as established fact.

## 4. Ordered implementation / research steps

### 1. Define target and provenance

Pin selected source, preserve required notices, register only app-owned identifiers/configuration, and add extension target/entitlements.

**Done when:** Source/license/build ownership and signing prerequisites are explicit; no unrelated profile is edited.

### 2. Implement narrow tunnel routing

Port/adapt the measured local packet mechanism; validate supported packet types and error handling. Keep RN and pairing credentials out of the extension.

**Done when:** Extension starts/stops through system consent; traffic behavior matches the required route with observable errors.

### 3. Manage app-owned VPN lifecycle

Implement configuration load/save/state observation/start/stop, startup cancellation, extension failure, and another-VPN conflict behavior.

**Done when:** Only NavBridge profiles are managed; late callbacks cannot reactivate a stopped session.

### 4. Validate actual networking

Run own signed bench test with Internet/DNS/Waze traffic and pairing-route prerequisites. Record disconnection and restart outcomes.

**Done when:** Physical-device evidence proves the claimed configuration; simulated manager tests are not reported as device proof.

## 5. Language and user-facing copy

All code, documentation and plans are English. The product UI locale is a separate decision (Q-07). No localization catalog or i18n framework exists in the template; do not invent a catalog command. For user-visible changes, agree the supported locale and recovery/error wording before implementation.

## 6. Unit and integration tests

Proposed native tunnel-manager integration tests with a fake configuration boundary: consent denial, save/start failure, duplicate start/stop, canceled start callback, extension failure, own-profile filtering, and another-VPN conflict. Pure packet transformation tests require supported-frame and malformed/unsupported-frame cases if that logic is copied.

Test paths described as proposed are new files, not existing suites. Tests run only under the approved task scope. Existing JS commands and future native command prerequisites are documented in [development](../docs/engineering/development.md).

## 7. Snapshots and visual checks

Not applicable; setup status is consumed by the later control screen.

## 8. Manual QA / experiment cases

D-02 networking portion: fresh consent, on/off, Waze Internet/DNS, Wi-Fi/cellular change, another VPN present, app/extension termination. Record actual supported behavior.

Record preconditions → actions → expected result → actual observation using [device validation](../docs/testing/device-validation.md). Mark cases not run, pass, fail, blocked or inconclusive; never imply the listed cases already passed.

## 9. Regression scope

iOS signing/build/embedded extension, ordinary Internet access and DNS, existing pairing control setup, other applications' VPN configurations.

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

[BLOCKING] Paid signing/provisioning and reuse-license review. If unavailable, record the blocker; do not silently change the final product to a two-app design.

Read [the question register](../docs/research/open-questions.md) for cross-task questions. Record answers in the owning document and this plan. Future commercial distribution, automatic map matching, cell/Wi-Fi positioning, CAN/extra IMU hardware, GNSS anomaly detection and Android remain outside this task unless explicitly approved separately.
