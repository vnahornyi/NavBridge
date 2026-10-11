# iOS integration

## Feasibility boundary

The desired one-app package contains a React Native host, native positioning/session code, and a signed Network Extension target. System location output uses a developer location-simulation mechanism, not a public Waze streaming API. This is an experimental personal installation path; App Store eligibility and long-term OS compatibility are unconfirmed.

The owner reports a successful external-tool test on iOS 27. Record the exact tool, version, setup, and behavior in NB-001 before using it as a reproducible control. Signing the embedded packet tunnel requires appropriate Apple Developer Program capabilities; membership and provisioning are currently unknown. Do not change the global developer account or an unrelated project's signing.

## Native bridge

Use the installed React Native 0.87.1 New Architecture and Codegen. `specs/NativeNavBridge.ts`, an ObjC++ bridge, and a Swift implementation are proposed new files. Confirm actual supported event/Promise/record representations with the installed generator before settling the transport. Swift owns the live session; JS submits commands and displays snapshots.

Keep subscriptions and initial snapshot acquisition consistent: a JS reload cannot miss a native transition or accidentally create another session. A bridge invalidation must release its subscriptions without silently clearing the independently owned session. The explicit Stop policy determines live cleanup. No generated output is hand-edited.

## Embedded tunnel

`ios/NavBridgeTunnel/` is a proposed extension target using `NEPacketTunnelProvider`. The app manages only its own `NETunnelProviderManager` configuration. Validate entitlements, unique app/extension identifiers, provisioning, user consent, and packet routing together.

LocalDevVPN demonstrates a local routing/packet transformation mechanism. Copying that mechanism needs license compliance and a narrow review. Derive any route/subnet requirements from the selected transport; do not invent addresses. Prove ordinary Internet access, Waze traffic, DNS, and device pairing traffic still work. Test coexistence with another VPN as an explicit supported/unsupported configuration. Never remove another app's VPN configuration.

## Pairing and output

Locus and its idevice FFI are the reference implementation. Pin revisions and build the needed library from auditable source; check device/simulator slices, linkage, toolchain, transitive licenses, and hashes. Do not copy the large opaque upstream archive without provenance.

Pairing material is secret and device-specific. Design its persistence and deletion around the upstream connection requirements, using the most restrictive storage compatible with the actual app/extension boundary. An App Group is needed only if both processes genuinely need shared material; the packet forwarding extension should not receive pairing keys by default.

Output operations must expose set and clear acknowledgements and retain enough transport state for cleanup. Test clear on a fresh connection, clear after failed set, repeated clear, app restart with an outstanding marker, and cleanup after tunnel interruption. Do not inject a coordinate merely to initialize a handle used for recovery.

## Background execution

Waze is normally foreground while NavBridge is background. A native implementation removes the JS dependency but does not guarantee continuous execution. CoreBluetooth modes permit certain events; they are not a general unlimited runtime. CoreMotion, BLE polling, pairing transport, and output must each be measured under actual app state.

Locus contains background-location and near-silent-audio helpers. Their presence is not a justification to copy them or to claim supported background behavior. Choose a legitimate background mechanism with appropriate permission descriptions, record the reason, and prove it in NB-009. If it does not work reliably, narrow the supported operating conditions rather than hiding gaps.

## CarPlay

The first goal uses Waze on the phone. Running Waze on CarPlay does not require building a NavBridge CarPlay interface. It does require testing which location source Waze uses for the actual head unit/connection. Do not add CarPlay entitlements or templates without a separate approved need.

Sources and pinned upstream revisions are in [the evidence register](../research/evidence.md). NB-003 owns the tunnel, NB-004 pairing/output, NB-009 background, and NB-010 CarPlay validation.
