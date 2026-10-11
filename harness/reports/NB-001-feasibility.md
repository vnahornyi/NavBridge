# NB-001 feasibility baseline

- **Record date:** 2026-10-11
- **Status:** Blocked: Q-02 external-tool and repeat-update/clear evidence remains unanswered
- **Repository revision:** `0023ac72ebfe8625190833953725e7a770970ba9`
- **Branch and initial worktree:** `main`, clean; no staged or unstaged changes before this report
- **Evidence register:** [docs/research/evidence.md](../../docs/research/evidence.md)

This report records a documentation and source audit. It is not a NavBridge build or device-validation result. The owner authorized the bounded §13 research/documentation scope by asking to execute NB-001. No runtime implementation, signing change, probe, VPN/profile change, pairing action, or vehicle command was performed.

## Environment and repository observations

| Item | Observed result |
|---|---|
| `git status --short --branch` | `## main...origin/main` before edits |
| `git rev-parse HEAD` | `0023ac72ebfe8625190833953725e7a770970ba9` |
| `git diff --stat` / `git diff --cached --stat` | Empty before edits |
| `git branch --list` | `main` |
| `node --version` / `npm --version` | `v22.14.0` / `10.9.2` |
| `xcodebuild -version` | Xcode `27.0`, build `27A266a` |
| `xcode-select -p` | `/Applications/Xcode.app/Contents/Developer` |
| Template | React Native `0.87.1`, React `19.2.3`; generated app bundle identifier; deployment target `15.1`; one app target |
| NavBridge runtime | No tunnel target, location-output implementation, or native NavBridge module found in the inspected project files |

The baseline planning revision `289d710aac77cfa3e8b4985201ca8285e33fabb8` is historical. The current branch was not changed or reset. The repository's Android template was not audited or modified.

## Owner-reported information and direct observations

| Provenance | Result |
|---|---|
| Owner-reported, already recorded in the repository | Waze on an iOS 27 phone displayed a location supplied by an external location-simulation tool. |
| Owner-confirmed, 2026-10-11 | v1.0 is for the owner's own iPhone on iOS 27, with no paid Apple Developer Program membership, no VPN, and no public release. |
| Directly observed in this session | Repository files, template versions/configuration, local tool versions, and the pinned upstream files listed below. |
| Not directly observed | External-control behavior on a phone, NavBridge signing, NavBridge output, Waze background behavior, CarPlay source selection, and positioning accuracy. |

No coordinates, pairing materials, credentials, device identifiers, screenshots, logs, or real trip data were collected or added.

## External-control case D-01

| Preconditions | Actions | Expected result | Actual observation | Status |
|---|---|---|---|---|
| Exact external tool/build, iOS/Waze versions, and owner-operated stationary setup available; test position chosen by the owner and kept outside Git | Open Waze; distinguish the vehicle marker from a destination pin; make deliberate location changes; invoke the tool's clear/stop; record acknowledgements and visible results separately | Waze's current-location marker follows repeated supplied positions; clear acknowledgement and resulting Waze/system behavior are recorded independently | Not run in this session. The existing owner report establishes only that Waze displayed an externally supplied location; update cadence, clear behavior, app states, and restoration remain unknown. No device interaction was performed. | Blocked by Q-02 and owner-operated device access |

The external test must remain stationary and leave the existing setup recoverable. Untested foreground/background, lock/unlock, connectivity, and CarPlay combinations remain not run. No duration or accuracy target is inferred from existing code or upstream claims.

## Own-build and upstream feasibility audit

| Capability | Evidence observed | Remaining result or blocker |
|---|---|---|
| VPN and paid Network Extension entitlement | Apple's [Supported capabilities (iOS)](https://developer.apple.com/help/account/reference/supported-capabilities-ios/) excludes Network Extensions from ordinary Apple Developer accounts; the [Network Extensions entitlement](https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.developer.networking.networkextension) lists packet-tunnel-provider. The owner confirmed no VPN and no paid membership for v1.0. | This excludes an embedded packet tunnel under the selected scope. It is not a blocker for v1.0 because no VPN extension will be used. |
| App and extension identifiers | Current Xcode project still uses the generated app bundle identifier; it contains one app target and no tunnel extension target. | Keep future unique identifiers unset until owner approval; no signing/project change was made. |
| LocalDevVPN applicability | The [pinned Locus README](https://github.com/ChrisMack32/Locus/blob/83c8fb324983728e8f44759cfd834dc637ee38b5/README.md) requires LocalDevVPN only in its iOS 18–26 setup; the owner selected iOS 27 with no VPN. | No LocalDevVPN installation, route, or integration is needed or included in the v1.0 plan. No route was copied or tested. |
| iOS 27 pairing/output dependency | [Pinned Locus README](https://github.com/ChrisMack32/Locus/blob/83c8fb324983728e8f44759cfd834dc637ee38b5/README.md) describes iOS 27 Settings → “Pair on this iPhone” and confirmation in Developer Mode → “Pair with Host”; it says iOS 18–26 instead use RPPairing plus LocalDevVPN. It describes source code signing with a free or paid Apple Developer account. | This is an upstream candidate only. No NavBridge free-team signing, iOS 27 pairing, output, Waze, clear, or restart test ran. Keep reproducible build/provenance and own-device validation for an explicitly approved NB-004 path. |
| Clear and restart semantics | [Pinned `LocationEngine.swift`](https://github.com/ChrisMack32/Locus/blob/83c8fb324983728e8f44759cfd834dc637ee38b5/Locus/Engine/LocationEngine.swift) serializes set/clear. Clear requires the current simulation handle, attempts clear, and frees local handles after the attempt even when it returns an error. | This source file does not prove restoration after a failed clear and has no fresh-handle or process-restart recovery path. Own-build clear/restart behavior remains an NB-004 device gate. |
| Waze-foreground/background behavior | The existing Waze observation has no exact app-state record. Upstream keepalive code and claims are not NavBridge device evidence. | Keep background execution blocked for NB-009; no Waze foreground/background or CarPlay test ran. |

The pinned [Locus license](https://github.com/ChrisMack32/Locus/blob/83c8fb324983728e8f44759cfd834dc637ee38b5/LICENSE) is MIT. The pinned [LocalDevVPN license](https://github.com/jkcoxson/LocalDevVPN/blob/af3fd697803ada4ac2b8d518358f5ab0a534844c/LICENSE) is the custom StosVPN License; it requires notices, attribution, and a derived-project statement, and restricts substantially similar re-uploads/rebranding under the same or similar branding without written permission. This records license text for engineering review; it is not legal advice or a decision to reuse either project.

The current [NB-003 plan](../../plans/NB-003-integrated-local-tunnel.md) describes an embedded tunnel and is outside the owner's v1.0 scope. The [NB-004 plan](../../plans/NB-004-location-output-and-pairing.md) depends on NB-003 and must be reconciled with the no-VPN iOS 27 pairing path before implementation. Editing those downstream plans was outside §13's documentation allowlist.

## Owner decisions and downstream blockers

| Question | Current answer | Effect |
|---|---|---|
| Q-01: v1.0 cost and distribution boundary | Owner confirmed own iOS 27 phone only, no paid Apple Developer Program membership, no VPN, and no public release. | Embedded tunnel is out of v1.0. Free-team signing and iOS 27 developer pairing/output still require an own-build/device check; revise NB-003/NB-004 plans before implementation. |
| Q-02: exact external tool/build and repeat-update/clear behavior? | Unknown; not supplied in this session. | Blocks a reproducible D-01 baseline and comparison with a future NavBridge build. |
| Q-03/Q-04/Q-05/Q-08/Q-10: motion mode, mount/heading, field-use targets, exact device/reference, and correction mode? | No new owner decisions recorded. | Keep the affected NB-006/NB-008/NB-009/NB-010 decisions and measurements open. No numeric target or product default was introduced. |
| Q-09: distribution | Owner confirmed personal use only and no public release for v1.0; future distribution remains undecided. | No public or commercial release work is included in v1.0; future evaluation remains for NB-011. |

## Checks and skipped validation

The following read-only commands ran from the repository root: `git status --short --branch`, `git rev-parse HEAD`, `git diff --stat`, `git diff --cached --stat`, `git branch --list`, `node --version`, `npm --version`, `xcodebuild -version`, and `xcode-select -p`. `git diff --check` passed; a Markdown link check found all 25 relative links in the six scoped files; the scoped privacy-pattern scan found no matches.

No application tests, dependency installation, build, simulator run, signing inspection/change, device command, Waze, CarPlay, or vehicle check ran. No upstream project was built. These results establish the local documentation/toolchain baseline only.

## Recommendation

Keep v1.0 personal to the owner's iOS 27 phone, with no VPN, paid membership, or public release. The pinned Locus iOS 27 pairing path is a candidate only; validate free-team signing, pairing, output, and cleanup on the device under an explicitly approved NB-004 scope. Do not implement NB-003's embedded tunnel for v1.0. Q-02 and owner-operated stationary D-01 evidence are still needed for the external baseline, so NB-001 remains Blocked. NB-002 remains the next documented dependency after NB-001 acceptance; reconcile NB-003/NB-004 plans before any later implementation.
