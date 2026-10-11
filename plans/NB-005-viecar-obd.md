# NB-005: Viecar OBD discovery and speed

## 0. Lifecycle and session entry

- **Status:** Draft
- **Plan created:** 2026-10-11.
- **Target:** iOS 27 / iPhone, with React Native presentation and native Swift execution. Android is outside scope.
- **Prerequisites:** [NB-001](NB-001-feasibility-and-baseline.md), [NB-002](NB-002-native-session-contract.md)
- **Approval:** Draft only. Documentation approval does not authorize this implementation. Obtain owner approval of this task and its blocking decisions before code.
- **Persistence:** Keep this plan in Git and update it in place; do not delete it after completion or create separate state/handoff/review files.

New-session prompt:

> Read AGENTS.md, plans/README.md, and plans/NB-005-viecar-obd.md. Inspect Git branch/HEAD and staged/working changes. Verify prerequisites and open questions against the current tree. Continue only the approved scope of NB-005; report actual checks and stop at the staged diff for approval. Do not commit or push.

## 1. Task and intended outcome

The exact owner's adapter/vehicle supplies validated timestamped speed through a bounded parser/request path, with missing data distinguished from zero.

This is one task/approval unit. If new evidence materially changes it, update this plan and obtain agreement before expanding scope.

## 2. Verified context and proposed files

The VC100 model label and third-party compatibility list are known. Actual UUIDs, characteristic behavior, firmware, supported PID, latency, fragmentation and sampling quality are not verified.

Proposed new: ios/NavBridge/Obd/ discovery/transport/request owner; native/NavBridgeCore/Sources/NavBridgeCore/Model/ObdFrameDecoder.swift; native/NavBridgeCore/Tests/NavBridgeCoreTests/ObdFrameDecoderTests.swift. Synthetic protocol fixtures under harness/fixtures/synthetic/ when reviewed. Actual raw captures stay private.

Baseline repository revision: `289d710aac77cfa3e8b4985201ca8285e33fabb8`. Predecessor tasks may add the proposed files; a new session must verify they actually exist. Future paths are planned ownership, not claims of implemented APIs. Sources and observation limits: [evidence register](../docs/research/evidence.md).

## 3. Problem framing and decisions

**Solved means:** The exact owner's adapter/vehicle supplies validated timestamped speed through a bounded parser/request path, with missing data distinguished from zero.

**Shortcut and limit:** A checklist or fake happy-path result is easier to produce, but does not prove the task's behavioral boundary or actual device conditions. Do not use it as completion evidence.

**Chosen approach and cost:** Follow the narrow ownership/files in §2 and the ordered steps below. Preserve native live ownership and shared replay logic; use the relevant proof layer, with device access where required. No backend or sibling-platform work is included.

**Who still has the problem:** Untested devices, OS builds, vehicle/adapter/head-unit configurations and users outside the agreed personal scope. Success of this task does not imply the entire product is complete.

**Decisions:** Verify authoritative command/response reference and exact read-only initialization sequence. Approve measured polling/freshness/retry/buffer/resynchronization settings before live integration. No guessed BLE UUID or ECU write commands.

Applicable criteria: AGENTS.md; requirements R-01–R-10; [architecture contracts](../docs/architecture/contracts.md); [test strategy](../docs/testing/strategy.md). Numeric quality/resource settings need documented provenance and agreement; proposed structural design is reviewed with the task, not silently treated as established fact.

## 4. Ordered implementation / research steps

### 1. Discover and capture actual device behavior

Inspect BLE service/characteristic properties, identify firmware evidence, discover speed PID support, and capture raw read-only traffic with timing.

**Done when:** A redacted compatibility summary distinguishes observed frames from advertised properties; raw private capture is excluded from Git.

### 2. Implement decoder and request association

Handle observed fragments/echo/lines/prompt/status/header configuration; validate PID and byte payload; convert expected unsigned km/h to canonical m/s once.

**Done when:** Decoder tests cover actual supported variants, zero and unavailable/error without conflation.

### 3. Implement connection and bounded polling

Use one request in flight, generation-tagged callbacks, measured waits and buffer limits, and explicit drain/reset/reconnect after timeout before a new request.

**Done when:** Late replies cannot satisfy new requests; disconnect invalidates quality and no overlapping loop survives reconnect.

### 4. Measure and publish approved configuration

Measure send/receive latency and successful sample intervals under documented ignition/engine states; integrate canonical quality/time events into the native session.

**Done when:** Compatibility is demonstrated on the actual vehicle; rates/thresholds have source, units, revision and owner approval.

## 5. Language and user-facing copy

All code, documentation and plans are English. The product UI locale is a separate decision (Q-07). No localization catalog or i18n framework exists in the template; do not invent a catalog command. For user-visible changes, agree the supported locale and recovery/error wording before implementation.

## 6. Unit and integration tests

ObdFrameDecoderTests.swift: fragmentation at every relevant boundary; echo/CR/LF/spaces; observed headers; several lines; unrelated PID; invalid hex/status; valid zero/max byte; truncated prompt; oversized input. Request-boundary tests: timeout then late response, resync failure, disconnect, old generation, unsupported PID and duplicate completion.

Test paths described as proposed are new files, not existing suites. Tests run only under the approved task scope. Existing JS commands and future native command prerequisites are documented in [development](../docs/engineering/development.md).

## 7. Snapshots and visual checks

Not applicable; no product UI in this task.

## 8. Manual QA / experiment cases

D-04 with owner's VC100 and vehicle: power/ignition changes, speed support, adapter out of range, reconnect and delayed frames; vehicle movement only with the agreed operator procedure.

Record preconditions → actions → expected result → actual observation using [device validation](../docs/testing/device-validation.md). Mark cases not run, pass, fail, blocked or inconclusive; never imply the listed cases already passed.

## 9. Regression scope

Native input clock/quality contract, BLE permission and reconnection, session invalidation; do not alter output/tunnel ownership or send unrelated vehicle commands.

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

[BLOCKING for compatibility claim] Physical adapter/vehicle access and actual capture. [BLOCKING for live configuration] Approved measured settings. Synthetic parser work can be scoped separately if explicitly approved.

Read [the question register](../docs/research/open-questions.md) for cross-task questions. Record answers in the owning document and this plan. Future commercial distribution, automatic map matching, cell/Wi-Fi positioning, CAN/extra IMU hardware, GNSS anomaly detection and Android remain outside this task unless explicitly approved separately.
