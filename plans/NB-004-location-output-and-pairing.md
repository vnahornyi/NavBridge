# NB-004: Location output and pairing

## 0. Lifecycle and session entry

- **Status:** Draft
- **Current scope:** No VPN in NavBridge. Target the iOS 27 on-device Developer Mode pairing path. The first step after the FFI build is a no-VPN tunnel experiment inside NavBridge; free-team signing and NavBridge output/recovery remain unverified.
- **Decisions recorded:** 2026-10-12 (§3). Implementation scope is not yet approved.
- **Plan created:** 2026-10-11.
- **Target:** iOS 27 / iPhone, with React Native presentation and native Swift execution. Android is outside scope.
- **Prerequisites:** [NB-001](NB-001-feasibility-and-baseline.md), [NB-002](NB-002-native-session-contract.md)
- **Approval:** Draft only. Documentation approval does not authorize this implementation. Obtain owner approval of this task and its blocking decisions before code.
- **Persistence:** Keep this plan in Git and update it in place; do not delete it after completion or create separate state/handoff/review files.

New-session prompt:

> Read AGENTS.md, plans/README.md, and plans/NB-004-location-output-and-pairing.md. Inspect Git branch/HEAD and staged/working changes. Verify prerequisites and open questions against the current tree. Implement only after NB-004's remaining blocking decisions and the complete task scope are approved. Preserve the no-VPN v1.0 boundary. Report actual checks and stop at the staged diff for approval. Do not commit or push.

## 1. Task and intended outcome

Own-build NavBridge uses iOS 27 on-device Developer Mode pairing without a VPN, supplies a deliberate stationary coordinate to Waze, and clears it with honest acknowledgement/recovery semantics.

This is one task/approval unit. If new evidence materially changes it, update this plan and obtain agreement before expanding scope.

## 2. Verified context and proposed files

The pinned Locus instructions describe an iOS 27 on-device Developer Mode pairing path; this upstream reference and the owner's external-tool observation do not prove that NavBridge works. Inspection on 2026-10-12 found that this path removes the computer only from pairing: Locus output still opens `tunnel_create_rppairing` to the LocalDevVPN loopback address, and Locus tells the user to connect LocalDevVPN after iOS 27 pairing ([evidence](../docs/research/evidence.md#locus)). Upstream [idevice](https://github.com/jkcoxson/idevice) tag `v0.1.68` (commit `d32c8189c51c2789496b0768039419c3705498c3`, 2026-09-15, MIT) contains the FFI sources Locus uses: `ffi/src/pairable_host.rs`, `rp_pairing_file.rs` (including `rp_pairing_file_from_bytes`/`_to_bytes`), `tunnel_provider.rs`, and `dvt/location_simulation.rs`. No Rust toolchain is installed on the development Mac as of 2026-10-12. A targeted search of `ios`, `native`, `src`, and `specs` found no NavBridge pairing, idevice FFI, or location-output implementation. LocalDevVPN and embedded packet tunnels are outside the confirmed v1.0 scope. Clearing through a fresh connection and cleanup after process loss are unverified.

Proposed new: ios/NavBridge/LocationOutput/ pairing/store/FFI wrapper and output implementation; native effect-boundary tests; source/build/notices manifest near any selected vendor integration. Existing: iOS project/link settings and docs/engineering/privacy-and-licensing.md. Record reviewed evidence in harness/reports/NB-004-location-output.md.

Baseline repository revision: `289d710aac77cfa3e8b4985201ca8285e33fabb8`. Predecessor tasks may add the proposed files; a new session must verify they actually exist. Future paths are planned ownership, not claims of implemented APIs. Sources and observation limits: [evidence register](../docs/research/evidence.md).

## 3. Problem framing and decisions

**Solved means:** Own-build NavBridge pairs, supplies a deliberate stationary coordinate to Waze, and clears it with honest acknowledgement/recovery semantics.

**Shortcut and limit:** A checklist or fake happy-path result is easier to produce, but does not prove the task's behavioral boundary or actual device conditions. Do not use it as completion evidence.

**Chosen approach and cost:** Follow the narrow ownership/files in §2 and the ordered steps below. Preserve native live ownership and shared replay logic; use the relevant proof layer, with device access where required. No backend or sibling-platform work is included.

**Who still has the problem:** Untested devices, OS builds, vehicle/adapter/head-unit configurations and users outside the agreed personal scope. Success of this task does not imply the entire product is complete.

**Confirmed boundary:** No paid Apple Developer Program membership and no VPN in NavBridge v1.0. Target iOS 27 on-device Developer Mode pairing; the exact NavBridge path remains unverified.

**Owner decisions (2026-10-12):**

- **D-1 Transport experiment.** Port the needed Locus engine behavior into NavBridge's native Swift `LocationOutput` module (React Native only for the pairing/set/clear screen) and test, in NavBridge, whether the developer tunnel opens to the phone's own Wi-Fi address with no VPN. Locus is a reference, not a dependency. A negative result stops NB-004 and returns the VPN boundary (R-11) to the owner; do not add a tunnel or LocalDevVPN dependency on our own.
- **D-2 FFI provenance.** Build idevice from source at `v0.1.68` / `d32c8189c51c2789496b0768039419c3705498c3` with rustup and the `aarch64-apple-ios` and `aarch64-apple-ios-sim` targets into a local `.xcframework`. Track the build script, revision, `Cargo.lock`, artifact SHA-256 and the transitive crate license list; keep the binary and generated header out of Git. Do not use the Locus prebuilt archive. Installing rustup is an approved new tool dependency for this task.
- **D-3 Pairing flow.** Explicit Start pairing / Cancel; no automatic timeout. Keep the pairing listener alive with `beginBackgroundTask` plus a local notification carrying the PIN; add background location only if the device experiment shows pairing is interrupted. No silent-audio keep-alive. Re-pairing replaces the stored record atomically only after the new record is obtained; a failed retry keeps the working pairing. Host model `Mac17,7` is copied from Locus as an unverified upstream value.
- **D-4 Pairing storage.** Keychain generic-password item, `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`, not synchronized, read/written through `rp_pairing_file_from_bytes`/`_to_bytes`; no pairing file on disk. Explicit Forget pairing. Invalid/revoked pairing yields `pairingRevoked` with a re-pair action and is never deleted automatically on transport errors. On first launch after reinstall (no UserDefaults install marker) delete the stale Keychain item. Pairing contents never appear in logs or errors.
- **D-5 Recovery marker.** A small file in Application Support, atomic write, excluded from backup, holding only version, session ID, generation and write time. Write it before the first `setOutput` of a session; if the write fails, do not set and fault with `outputMarkerWriteFailed`. Any failed set is treated as possibly applied. Delete the marker only after `outputCleared`; `outputClearFailed`/`outputClearUnknown` keep it and enter `cleanupRequired`. On a new process, native code checks the marker before accepting Start: enter `cleanupRequired`, reject Start, make one automatic fresh-connection clear when the app becomes active, then offer manual Retry cleanup. Offer an explicit confirmed "Location is back to normal" action that removes the marker and is recorded as `userAttested`, never as `cleared`. Manual system recovery steps are documented only after they are observed.

Map transport callbacks to the NB-002 acknowledgement outcomes while keeping live session effects and ordering in native Swift. If fresh-handle clear cannot be proven, expose the limitation and do not fabricate a setup coordinate. If free-team signing or the no-VPN tunnel is unavailable, stop and report the blocker rather than introducing paid signing or a tunnel.

**Still open before implementation approval:** pairing/recovery screen locale and wording (§5, Q-07), and owner approval of the complete task scope.

Applicable criteria: AGENTS.md; requirements R-01–R-11; [architecture contracts](../docs/architecture/contracts.md); [test strategy](../docs/testing/strategy.md). Numeric quality/resource settings need documented provenance and agreement; proposed structural design is reviewed with the task, not silently treated as established fact.

## 4. Ordered implementation / research steps

### 1. Reproduce dependency builds

Build idevice `v0.1.68` per D-2: device and simulator slices, toolchain/recipe/hashes and notices recorded. Do not import the opaque Locus archive.

**Done when:** Selected artifacts are reproducible and link to the own signed app, with licenses checked.

### 2. Prove the no-VPN tunnel

With the minimal pairing (D-3/D-4) and set/clear path needed for the experiment, open `tunnel_create_rppairing` to the phone's own Wi-Fi address with no VPN installed or connected, then set and clear one deliberate stationary coordinate.

**Done when:** A sanitized report records tunnel/handshake/simulation/set/clear outcomes and Waze observation. On failure, stop NB-004 and report to the owner (D-1).

### 3. Implement pairing and connection ownership

Use narrow native setup methods with the approved pairing-material storage policy, redacted errors, and explicit invalid/revoked pairing recovery. Do not add a tunnel dependency.

**Done when:** Pair/unpair/retry behavior works on the target phone without secrets in logs/Git.

### 4. Implement ordered output and recovery

Expose set/clear acknowledgements; implement the D-5 marker semantics. Reconcile late sets and retain transport until cleanup; test new-process recovery.

**Done when:** Stop never reports success after unknown clear; restart attempts recovery before new output.

### 5. Prove stationary Waze integration

Repeat controlled distinct-coordinate set/clear, ongoing updates, canceled startup, pairing/connection interruption and process restart with the own build.

**Done when:** A sanitized report distinguishes API acknowledgement, actual Waze observation, and any unresolved system restoration behavior.

## 5. Language and user-facing copy

All code, documentation and plans are English. The product UI locale is a separate decision (Q-07). No localization catalog or i18n framework exists in the template; do not invent a catalog command. For user-visible changes, agree the supported locale and recovery/error wording before implementation.

## 6. Unit and integration tests

Fake FFI/connection boundary tests: pairing absent/rejected/revoked; failed re-pair keeps the stored record; reinstall removes a stale Keychain item; `userAttested` removes the marker without reporting `cleared`; set success/failure/unknown; clear success/failure/unknown; set completes after Stop; correction invalidates queued set; minimal-marker write failure; restart marker; fresh-handle clear; handle lifetime and first-error preservation. Verify real FFI separately.

Test paths described as proposed are new files, not existing suites. Tests run only under the approved task scope. Existing JS commands and future native command prerequisites are documented in [development](../docs/engineering/development.md).

## 7. Snapshots and visual checks

Not applicable; later RN tests display structured setup/cleanup states.

## 8. Manual QA / experiment cases

D-02/D-06/D-07 output portions while stationary; repeat clear through an existing and fresh connection, pairing denial/revocation, app termination, and reinstall/re-pair where authorized. Never assume closing a handle restores location.

Record preconditions → actions → expected result → actual observation using [device validation](../docs/testing/device-validation.md). Mark cases not run, pass, fail, blocked or inconclusive; never imply the listed cases already passed.

## 9. Regression scope

Free-team signing, no-VPN pairing and output, Swift/RN linkage, privacy of pairing material, clean template launch, and real location restoration after experiments.

Broaden checks only when changed shared consumers, new failures, or unresolved concerns justify it. No unrelated dependency upgrade or architecture cleanup is included.

## 10. Estimate and resource assumptions

No hour estimate, delivery date, hardware purchase or paid-service budget is approved. Feasibility, device availability and measurement-dependent choices make an evidence-based estimate premature. Before implementation, price the concrete approved steps, meaningful automated verification, human device QA/review, documentation and release work; record optimistic/realistic effort and assumptions here if the owner requests an estimate. Do not apply unrelated company ticket gradations or invent a financial forecast.

## 11. Verification and completion

**Current record (2026-10-12):** Blocking decisions D-1–D-5 recorded; implementation not started. No task implementation, automated check, build, simulator, device, Waze, CarPlay, or vehicle result is claimed by this plan.

- [x] Blocking decisions recorded (D-1–D-5, 2026-10-12).
- [ ] Owner-approved task scope, including UI locale/wording.
- [ ] Prerequisites verified against the current repository and device evidence.
- [ ] Ordered steps completed within scope; actual paths/contracts recorded.
- [ ] Authorized checks recorded with commands, revision, results and skipped cases.
- [ ] Relevant documentation/evidence updated; secrets and private recordings excluded.
- [ ] Exact task files staged; full diff and commit message presented.
- [ ] Owner approved the complete staged result; then mark Complete and update plans/README.md.

Append concise decisions and actual verification here as work proceeds. Do not create a separate handoff/review state file. Complete does not itself grant commit or publication authority.

## 12. Open questions, blockers and exclusions

[BLOCKING] No-VPN developer tunnel to the phone's own address (step 2); free-team signing and iOS 27 on-device pairing availability; selected source/build/license provenance; actual phone access; and proven cleanup behavior. If cleanup remains unknown, do not claim usable live positioning.

Read [the question register](../docs/research/open-questions.md) for cross-task questions. Record answers in the owning document and this plan. Future commercial distribution, automatic map matching, cell/Wi-Fi positioning, CAN/extra IMU hardware, GNSS anomaly detection and Android remain outside this task unless explicitly approved separately.
