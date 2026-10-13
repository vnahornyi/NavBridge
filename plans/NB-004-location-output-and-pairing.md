# NB-004: Location output and pairing

## 0. Lifecycle and session entry

- **Status:** In progress — branch `nb-004-location-output-and-pairing`, started 2026-10-13. Step 1 is blocked; see §4 and §11.
- **Current scope:** No VPN in NavBridge. Target the iOS 27 on-device Developer Mode pairing path. The first step after the FFI build is a no-VPN tunnel experiment inside NavBridge; free-team signing and NavBridge output/recovery remain unverified.
- **Decisions recorded:** 2026-10-12 (§3). Owner approved the task scope and the English pairing/recovery UI locale on 2026-10-12.
- **Plan created:** 2026-10-11.
- **Target:** iOS 27 / iPhone, with React Native presentation and native Swift execution. Android is outside scope.
- **Prerequisites:** [NB-001](NB-001-feasibility-and-baseline.md), [NB-002](NB-002-native-session-contract.md)
- **Approval:** Owner-approved 2026-10-12 (task scope, English UI locale). The pairing/recovery strings are listed in §5 (2026-10-13) and await owner approval before the first UI change.
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

**Resolved 2026-10-12:** the owner approved the complete task scope and set the pairing/recovery screen locale to English. Q-07 (map picker, NB-008) stays open and does not apply here.

Applicable criteria: AGENTS.md; requirements R-01–R-11; [architecture contracts](../docs/architecture/contracts.md); [test strategy](../docs/testing/strategy.md). Numeric quality/resource settings need documented provenance and agreement; proposed structural design is reviewed with the task, not silently treated as established fact.

## 4. Ordered implementation / research steps

### 1. Reproduce dependency builds

Build idevice `v0.1.68` per D-2: device and simulator slices, toolchain/recipe/hashes and notices recorded. Do not import the opaque Locus archive.

**Done when:** Selected artifacts are reproducible and link to the own signed app, with licenses checked.

**Status (2026-10-13): Blocked.** Rust toolchain installed and the upstream revision verified. Running the upstream build (`cargo check`/`cargo build`, which executes third-party build scripts) was denied by the auto-mode permission check, and it has not been run. Nothing was built or linked. See §11.

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

All code, documentation and plans are English. The pairing/recovery screen locale is English (owner, 2026-10-12); Q-07 remains open for the NB-008 map picker. No localization catalog or i18n framework exists in the template; do not invent a catalog command. Before the first UI change, the implementation session lists every user-visible string and recovery/error message for owner approval.

**Proposed strings for owner approval (2026-10-13). Not approved; no UI code exists.** Each row is a proposal in English. `{pin}` is a runtime value shown only in the notification and never logged. A string may say a location is cleared only for S-21; S-29 records the owner's own check and must not be presented as a clear.

Pairing (D-3, D-4):

| ID | Where / when | Proposed text |
|---|---|---|
| S-01 | Pairing screen title | Pair this iPhone |
| S-02 | Pairing screen explanation | NavBridge pairs with this iPhone in Developer Mode. Pairing is stored only in this iPhone's Keychain and is never shown or exported. |
| S-03 | Idle, no pairing stored | No pairing stored. |
| S-04 | Idle, pairing stored | Paired. Pairing is stored in this iPhone's Keychain. |
| S-05 | Primary button, no pairing | Start pairing |
| S-06 | Waiting for confirmation | Waiting for confirmation on this iPhone. Keep NavBridge open. Use the PIN from the notification if iOS asks for it. *(Revise after the device run.)* |
| S-07 | PIN notification title | NavBridge pairing PIN |
| S-08 | PIN notification body | Use PIN {pin} to finish pairing NavBridge. Cancel pairing in NavBridge to stop. |
| S-09 | Cancel button, pairing in progress | Cancel pairing |
| S-10 | Cancelled, prior pairing kept | Pairing cancelled. Your existing pairing was kept. |
| S-11 | Cancelled, no prior pairing | Pairing cancelled. Nothing was stored. |
| S-12 | Failed, no prior pairing | Pairing did not finish. Nothing was stored. You can start pairing again. |
| S-13 | Re-pair failed, prior pairing kept | Pairing did not finish. Your working pairing was kept. |
| S-14 | Pairing rejected or revoked by the device | The device no longer accepts this pairing. Pair again to continue. |
| S-15 | Button for S-14 | Pair again |
| S-16 | Forget button | Forget pairing |
| S-17 | Forget confirmation (title / body / buttons) | Forget this pairing? NavBridge deletes the stored pairing from this iPhone. You must pair again before setting a location. Buttons: "Forget pairing" / "Keep pairing". |
| S-18 | Stale item removed after reinstall | A pairing from an earlier installation was removed. Pair again to continue. |

Output and recovery (D-5, NB-002 outcomes):

| ID | Where / when | Proposed text |
|---|---|---|
| S-19 | Set acknowledged by the developer connection | Location accepted by the developer connection. NavBridge cannot see Waze; check Waze yourself. |
| S-20 | Set failed or unknown, clear pending | Location could not be set. NavBridge is clearing any partial setting. |
| S-21 | Clear confirmed (the only "cleared" wording) | Location clear confirmed by NavBridge. Check Maps or Waze to confirm your real position. |
| S-22 | `cleanupRequired` | Cleanup not confirmed. NavBridge could not confirm that the simulated location was cleared, so your real location may not be restored yet. |
| S-23 | Retry button | Retry cleanup |
| S-24 | Retry running | Retrying cleanup… |
| S-25 | Retry failed | Cleanup still not confirmed. Retry again. |
| S-26 | Launch with an outstanding record | NavBridge found an unfinished location session from an earlier launch. It will try to clear it before any new location is set. |
| S-27 | User-attested recovery button | Location is back to normal |
| S-28 | User-attested confirmation (buttons: "Record confirmation" / "Cancel") | Confirm only if Maps and Waze show your real position. NavBridge records that you confirmed this. It does not count as a confirmed clear. |
| S-29 | After user attestation | Recorded as confirmed by you, not as a confirmed clear. |
| S-30 | Recovery record cannot be written | Could not save the recovery record, so no location was set. |
| S-31 | Developer connection unavailable | The developer connection is unavailable. Location was not set. |
| S-32 | Fresh-connection clear failed | Could not confirm the clear with a new connection. Cleanup is still required. |
| S-33 | Start refused while cleanup is required | Clear the previous location session before starting a new one. |

Permissions and Info.plist text (decisions, not final strings):

| ID | Item | Status |
|---|---|---|
| P-01 | Notification permission for the PIN notification | Requesting it needs owner approval; the system prompt is iOS-owned. |
| P-02 | `NSLocalNetworkUsageDescription` | Absent from `ios/NavBridge/Info.plist`. Add only if the device run shows a local-network prompt; text needs approval then. |
| P-03 | `NSLocationWhenInUseUsageDescription` | Present but empty. NavBridge does not request location; fix the text or remove the key before any location request, including the D-3 background fallback. |

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

**Record (2026-10-13, branch `nb-004-location-output-and-pairing`, base `main` at `e1724c6`).** Verification only; no runtime code written. No commit, push, or signing change.

Verified:
- Branch created from `main`. The planning baseline `289d710aac77cfa3e8b4985201ca8285e33fabb8` is an ancestor of HEAD.
- Prerequisites: NB-001 and NB-002 are Complete in the index and plans. NB-002's files are present (`specs/NativeNavBridge.ts`, `src/native/*`, `native/NavBridgeCore/*`, `ios/NavBridge/Bridge/*`). The NB-001 report header still says "Implemented — awaiting approval" and was not changed here.
- `swift test --package-path native/NavBridgeCore`: 11 tests, 0 failures (Swift 6.4, Xcode 27.0 build 27A266a, macOS arm64e).
- Proposed NB-004 paths do not exist yet: `ios/NavBridge/LocationOutput/`, `harness/reports/NB-004-location-output.md`.
- Toolchain: Xcode 27.0 (27A266a); iPhoneOS and iPhoneSimulator SDK 27.0; Node v22.14.0; `pod` is not on PATH in this shell, so CocoaPods was not re-verified.
- Rust (approved new tool dependency, D-2): `rustup-init` was fetched from `static.rust-lang.org`, and its SHA-256 matched the published `.sha256` (`ec1b9233…c696a`). Installed with `--no-modify-path` (shell profile untouched), minimal profile, stable toolchain `rustc`/`cargo` 1.99.0 (2026-09-28). Targets installed: `aarch64-apple-ios`, `aarch64-apple-ios-sim`.
- idevice: tag `v0.1.68` peels to commit `d32c8189c51c2789496b0768039419c3705498c3`, which matches D-2 and the evidence register. Shallow clone in `vendor/idevice/build/src`, ignored by the `build/` rule (`git check-ignore` confirmed). Upstream workspace members: `ffi`, `idevice`, `tests`, `tools`; `Cargo.lock` present.
- Device: iPhone 11 (`iPhone12,1`), iOS 27.0.1 (24A446), Developer Mode enabled, pairing state "paired". At check time the device state was "unavailable" (not connected). No pairing, tunnel, or location action was taken. The owner must connect the phone for device steps.
- Signing: `security find-identity -v -p codesigning` lists five valid identities. `~/Library/MobileDevice/Provisioning Profiles` is empty. Free-team NavBridge signing is untested.
- Locus reference: the local checkout is at pinned `83c8fb3`, with uncommitted owner changes in `Locus.xcodeproj/project.pbxproj` and `Locus/Resources/Info.plist`. It was not used or modified. Its engine chain is `rp_pairing_file_read` → `tunnel_create_rppairing` (hostname "LocusLocation", hard-coded port 49152, target IP from configuration) → `remote_server_connect_rsd` → `location_simulation_new` → `set`/`clear`. Clear uses only the existing handle; there is no fresh-handle path.

Source-derived feature mapping (read from source, not compiled):
- `tunnel_create_rppairing` is gated by `tunnel_tcp_stack`, which enables `core_device_proxy`, `rsd`, and `remote_pairing`. `rp_pairing_file` and `pairing_host`/`pairable_host` are gated by `remote_pairing`. `location_simulation` is gated by `location_simulation` and the `dvt` module.
- Candidate, untested: `--no-default-features --features "ring remote_pairing tunnel_tcp_stack dvt location_simulation rsd core_device_proxy tcp"`. It differs from the upstream iOS recipe in three ways, each proposed for approval: `ring` instead of default `aws-lc`; no `full` set, which keeps the licensed crate set small; and no `obfuscate`, which the upstream device recipe enables but which only obfuscates string literals (`obfstr`).

Discrepancy found:
- The evidence register's primary-sources table (`NSLocalNetworkUsageDescription` row) says an empty `NSLocalNetworkUsageDescription` exists. The current `ios/NavBridge/Info.plist` has no such key; it has an empty `NSLocationWhenInUseUsageDescription`. The register needs correction (not in this staged set).

Blocked:
- Step 1 build was not run. The next command was `cargo check --locked` on the pinned upstream source for `aarch64-apple-ios`. It executes upstream `build.rs` and crate build scripts. The auto-mode permission check denied it ("Code from External"). I did not retry it through another tool. One unrelated read-only Bash call was also denied; the same files were read with the file reader.

Needed from the owner:
1. Permission to run the pinned idevice build (device and simulator) in `vendor/idevice/build/`, either in chat or as a Bash permission rule.
2. Decisions on the candidate feature set (`ring`, no `full`, no `obfuscate`) and the tracked provenance location (proposed: `vendor/idevice/`, with pinned revision, `Cargo.lock` comparison, features, toolchain, artifact SHA-256, and a license list from `cargo tree`).
3. Approval of the §5 strings (S-01–S-33, P-01–P-03).

Not run: JS/Jest, lint, Pods install, app and simulator builds, device pairing, tunnel, set/clear, Waze, CarPlay, vehicle.

- [x] Blocking decisions recorded (D-1–D-5, 2026-10-12).
- [x] Owner-approved task scope, including UI locale/wording.
- [ ] Prerequisites verified against the current repository and device evidence.
- [ ] Ordered steps completed within scope; actual paths/contracts recorded.
- [ ] Authorized checks recorded with commands, revision, results and skipped cases.
- [ ] Relevant documentation/evidence updated; secrets and private recordings excluded.
- [ ] Exact task files staged; full diff and commit message presented.
- [ ] Owner approved the complete staged result; then mark Complete and update plans/README.md.

Append concise decisions and actual verification here as work proceeds. Do not create a separate handoff/review state file. Complete does not itself grant commit or publication authority.

## 12. Open questions, blockers and exclusions

[BLOCKING] No-VPN developer tunnel to the phone's own address (step 2); free-team signing and iOS 27 on-device pairing availability; selected source/build/license provenance; actual phone access; and proven cleanup behavior. If cleanup remains unknown, do not claim usable live positioning.

[BLOCKING, 2026-10-13] Owner permission to run the pinned idevice build (step 1). Until granted, there is no FFI artifact, provenance manifest, or tunnel experiment.

[OWNER ACTION, step 2] Connect the iPhone 11 (iOS 27.0.1, Developer Mode enabled) for an attended run. Confirm any system pairing prompts on the phone.

[EVIDENCE CORRECTION] The evidence register's `NSLocalNetworkUsageDescription` statement does not match `ios/NavBridge/Info.plist` (see §11).

Read [the question register](../docs/research/open-questions.md) for cross-task questions. Record answers in the owning document and this plan. Future commercial distribution, automatic map matching, cell/Wi-Fi positioning, CAN/extra IMU hardware, GNSS anomaly detection and Android remain outside this task unless explicitly approved separately.
