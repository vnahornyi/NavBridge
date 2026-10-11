# Evidence register

Reviewed on 2026-10-11. External documentation and upstream code are evidence of a mechanism, not proof that NavBridge implements it. Recheck compatibility when code or OS versions change.

## Provenance categories

- **Owner-confirmed requirement:** explicit conversation decision.
- **Owner-reported observation:** behavior the owner saw; not independently reproduced here.
- **Repository observation:** file/version directly inspected in the current tree.
- **Upstream evidence:** primary documentation or pinned upstream code.
- **Proposed design:** needs the relevant plan's approval.
- **Measured result:** reproducible experiment with environment/configuration and actual outcome; none exists yet for NavBridge runtime.

## Local baseline

At planning start, branch `main` was clean at `289d710aac77cfa3e8b4985201ca8285e33fabb8`. Recheck Git rather than assuming this remains current.

| Observation | Evidence |
|---|---|
| RN 0.87.1, React 19.2.3, Node >=22.11.0 | `package.json`, tracked `package-lock.json` |
| Existing lint/start/iOS/Jest commands | `package.json`; Jest config and template test |
| Generated app and smoke test only | `App.tsx`, `__tests__/App.test.tsx` |
| iOS 15.1 deployment, Swift 5.0 setting, generated bundle identifier | `ios/NavBridge.xcodeproj/project.pbxproj` |
| Swift RN host | `ios/NavBridge/AppDelegate.swift` |
| Xcode 27.0 build 27A266a | Local `xcodebuild -version` observation |
| No product runtime or harness implementation | Scoped repository inspection before documentation change |

The owner-supplied concept describes autonomous vehicle navigation during GNSS disruption and a Polo Sedan/RCD 360 Pro configuration. It proposes several research directions; it is not a measured accuracy report. The owner then narrowed the immediate product to an iPhone Waze companion, accepted manual coordinates, and requested documentation first.

### NB-001 repository audit

At revision `0023ac72ebfe8625190833953725e7a770970ba9`, `main` was clean before the NB-001 documentation edits. The local toolchain reported Node `v22.14.0`, npm `10.9.2`, Xcode `27.0` build `27A266a`, and developer directory `/Applications/Xcode.app/Contents/Developer`. The template reports React Native `0.87.1` and React `19.2.3`; the Xcode project has one app target, generated bundle identifier `org.reactjs.native.example.$(PRODUCT_NAME:rfc1034identifier)`, and deployment target `15.1`. No NavBridge tunnel target or location-output source is present. No build, simulator, or device command was run.

The statement “works, Waze sees it” is an owner-reported external-tool observation on iOS 27. Exact tool/build, continuous-update duration, clear behavior, background operation, and CarPlay outcome are not yet documented. NB-001 is intended to record a reproducible baseline; the current report remains blocked on the exact tool/build and repeat-update/clear evidence.

## Primary sources

| Source | What it supports | Limits |
|---|---|---|
| [Apple packet tunnel provider](https://developer.apple.com/documentation/NetworkExtension/packet-tunnel-provider) | Network Extension packet-tunnel capability and provider model | Does not grant continuous execution to the RN host |
| [Apple configuring network extensions](https://developer.apple.com/documentation/xcode/configuring-network-extensions), [supported iOS capabilities](https://developer.apple.com/help/account/reference/supported-capabilities-ios) | Extension/signing/capability requirements | Actual owner's membership/provisioning remains unverified |
| [Apple NSLocalNetworkUsageDescription](https://developer.apple.com/documentation/bundleresources/information-property-list/nslocalnetworkusagedescription) | Purpose text shown when an app requests local-network access; applies to direct and indirect local-network use | The current owner-edited Info.plist key has an empty value; no permission prompt was tested |
| [Apple enrollment](https://developer.apple.com/programs/enroll/) | Published USD 99/year membership fee, local currency where available | Not the owner's actual bill or a total project budget |
| [CoreMotion device motion](https://developer.apple.com/documentation/coremotion/cmdevicemotion), [gravity](https://developer.apple.com/documentation/coremotion/cmdevicemotion/gravity), [timestamps](https://developer.apple.com/documentation/coremotion/cmlogitem/timestamp) | Motion/gravity data and seconds-since-boot timestamp semantics | Vehicle yaw conversion, bias, clock mapping and suspension need testing |
| [CoreBluetooth background processing](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothBackgroundProcessingForIOSApps/PerformingTasksWhileYourAppIsInTheBackground.html) | Limited background event behavior and modes | Not proof of indefinite polling/IMU/output execution |
| [Core Location accessory source flag](https://developer.apple.com/documentation/corelocation/cllocationsourceinformation/isproducedbyaccessory) | Accessory-supplied location can be distinguished in source information | Does not prove source precedence on this CarPlay setup |
| [React Native Turbo Native Modules](https://reactnative.dev/docs/turbo-native-modules-introduction) | Codegen/native-module architecture | Verify generated types against installed 0.87.1 |
| [RN Swift module reference, version 0.84](https://reactnative.dev/docs/0.84/the-new-architecture/turbo-modules-with-swift) | Swift through native bridge example | Older version; not a compatibility guarantee for this template |
| [Waze deep links](https://developers.google.com/waze/deeplinks) | Opening Waze locations/destinations | Does not document a live location-provider API |
| [OBD Auto Doctor supported adapters](https://www.obdautodoctor.com/help/articles/supported-obd-adapters/) | Vendor application reports Viecar BLE iOS support | Not validation of this exact VC100/firmware/vehicle |
| [Viecar application listing](https://apps.apple.com/gb/app/viecar/id1474737022) | Manufacturer application's advertised adapter support | Marketing/listing evidence, not measured protocol behavior |
| [ELM327 emulator](https://github.com/Ircama/ELM327-emulator/blob/master/README.md) | Example `41 0D` vehicle-speed interoperability frames | Not authoritative proof of ELM firmware or physical timing |

An authoritative ELM/OBD protocol reference for the exact command/configuration assumptions has not yet been verified. Resolve this and collect actual adapter frames in NB-005 before declaring compatibility. Do not infer an official firmware version solely from the “v1.5” advertisement.

## Platform and upstream evidence

### Apple signing capability and owner constraint

On 2026-10-11, the owner confirmed v1.0 is for their own iPhone on iOS 27, without paid Apple Developer Program membership, VPN, or public release. Apple's [Supported capabilities (iOS)](https://developer.apple.com/help/account/reference/supported-capabilities-ios/) states provisioning capabilities depend on program membership; its Network Extensions row is available for Apple Developer Program and Apple Developer Enterprise Program memberships, but not for ordinary Apple Developer account holders. Apple's [Network Extensions Entitlement](https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.developer.networking.networkextension) lists packet-tunnel-provider as an entitlement value. This means an embedded packet-tunnel extension is outside the confirmed v1.0 scope; the entitlement limit no longer blocks the selected no-VPN scope. The owner's free-team signing, on-device pairing, and location-output path have not been tested. No account, profile, signing configuration, or entitlement was inspected or changed.

### Locus

Pinned revision: `83c8fb324983728e8f44759cfd834dc637ee38b5`.

- [Repository at revision](https://github.com/ChrisMack32/Locus/tree/83c8fb324983728e8f44759cfd834dc637ee38b5)
- [LocationEngine.swift](https://github.com/ChrisMack32/Locus/blob/83c8fb324983728e8f44759cfd834dc637ee38b5/Locus/Engine/LocationEngine.swift): serialized native location set/clear and idevice FFI connection flow.
- [License](https://github.com/ChrisMack32/Locus/blob/83c8fb324983728e8f44759cfd834dc637ee38b5/LICENSE): MIT notices to preserve if reused.

The pinned LocationEngine.swift uses a serial queue. Clear calls location_simulation_clear only through the current simulation handle; when no handle exists it returns an error. After attempting clear, it frees local handles even when the clear call returns an error. This file contains no fresh-handle clear or process-restart recovery path, and releasing local handles does not establish that system location was restored. The pinned README says a source build uses XcodeGen and an Apple Developer account (free or paid) for code signing, and that its published IPA does not require an account. These are Locus instructions; they do not prove NavBridge signing or output.

The pinned [Locus README](https://github.com/ChrisMack32/Locus/blob/83c8fb324983728e8f44759cfd834dc637ee38b5/README.md) distinguishes OS paths: for iOS 27 it describes Settings → “Pair on this iPhone” and confirmation in Developer Mode → “Pair with Host”; for iOS 18–26 it describes importing an RPPairing file and installing LocalDevVPN. The owner has excluded VPN from v1.0, so only the iOS 27 path is relevant to the selected scope. These remain upstream instructions, not a measured NavBridge result. Inspected engine cleanup depends on a usable simulation handle; freeing local resources is not proof of restored system location. The repository includes background keepalive helpers and a large bundled idevice FFI archive. Neither is automatically adopted: NB-004 must establish reproducible build/provenance and recovery; NB-009 measures background behavior.

### LocalDevVPN

Pinned revision: `af3fd697803ada4ac2b8d518358f5ab0a534844c`.

- [Repository at revision](https://github.com/jkcoxson/LocalDevVPN/tree/af3fd697803ada4ac2b8d518358f5ab0a534844c)
- [PacketTunnelProvider.swift](https://github.com/jkcoxson/LocalDevVPN/blob/af3fd697803ada4ac2b8d518358f5ab0a534844c/TunnelProv/PacketTunnelProvider.swift): local packet routing/transformation reference.
- [License](https://github.com/jkcoxson/LocalDevVPN/blob/af3fd697803ada4ac2b8d518358f5ab0a534844c/LICENSE): custom StosVPN License; attribution/notices/branding conditions.

At the pinned provider file, the included IPv4 route is the configured peer endpoint and the default route is excluded; packets are read, transformed, and written back through the packet flow. The route and transformation are specific to that upstream transport and are not NavBridge requirements. The license requires the notice, prominent attribution, and a statement that derived code is based on or uses the original; it also restricts re-uploading/rebranding the whole or a substantially similar project under the same or similar name/branding without written permission. This is an engineering source audit, not a legal conclusion.

Inspected app code manages VPN configuration/start/stop and the extension uses packet-tunnel entitlements. NavBridge v1.0 will not use or reuse this VPN mechanism. No LocalDevVPN installation, configuration, route, or integration was performed.

## Evidence still required

Exact external tool baseline; free-team signing and iOS 27 pairing/output behavior on the owner's phone; actual BLE services/frames/timing; valid motion conversion/calibration; independent trajectory reference; output clear/restart semantics; Waze-foreground execution; CarPlay source selection; map provider terms. Public distribution is outside v1.0. See [open questions](open-questions.md) and the task plans.
