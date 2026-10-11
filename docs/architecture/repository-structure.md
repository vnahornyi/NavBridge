# Repository structure

## Present after the documentation foundation

```text
NavBridge/
  AGENTS.md
  README.md
  App.tsx                         # unchanged RN template
  index.js                        # unchanged registration
  package.json / package-lock.json
  __tests__/App.test.tsx           # existing template smoke test
  ios/                            # unchanged generated iOS app
  android/                        # untouched template; outside product scope
  docs/
    product/                      # requirements, flows, business plan
    architecture/                 # design, contracts, positioning, lifecycle
    engineering/                  # integration, OBD, development, privacy
    testing/                      # strategy, harness, acceptance, device QA
    research/                     # evidence and open questions
  harness/
    README.md
    fixtures/README.md             # fixture conventions; no datasets yet
    scenarios/README.md            # scenario conventions; no runner yet
    reports/README.md              # evidence conventions; no reports yet
  plans/                          # persistent, tracked task plans
```

## Proposed implementation tree

The following paths do not exist yet. Create them only in the plan that owns actual code; avoid empty `.gitkeep` scaffolding.

```text
src/
  app/nav-bridge-app.tsx
  features/navigation-session/
    navigation-session-screen.tsx
    use-navigation-session.ts
    coordinate-picker.tsx
    heading-picker.tsx
    session-status.tsx
    session-toggle.tsx
    __tests__/
  native/
    nav-bridge-client.ios.ts
    nav-bridge-types.ts
specs/
  NativeNavBridge.ts
native/NavBridgeCore/
  Package.swift
  Sources/NavBridgeCore/
    Model/                        # input/output value types and validation
    Session/                      # pure transitions and effect descriptions
    Positioning/                  # pure geometry and motion integration
    Replay/                       # deterministic event ingestion
  Tests/NavBridgeCoreTests/
    SessionTests.swift
    PositioningTests.swift
    ReplayTests.swift
    ObdFrameDecoderTests.swift
ios/NavBridge/
  Bridge/                         # ObjC++ Codegen bridge, Swift module
  Session/                        # native serialized effect orchestration
  Obd/                            # CoreBluetooth and request framing
  Motion/                         # CoreMotion ingestion and clock mapping
  LocationOutput/                 # pairing, idevice wrapper, clear/recovery
  Tunnel/                         # main-app VPN configuration manager
  Recording/                      # local consented recording/export
ios/NavBridgeTunnel/
  PacketTunnelProvider.swift
  Info.plist
  NavBridgeTunnel.entitlements
harness/
  fixtures/synthetic/             # approved synthetic JSONL only
  scenarios/                     # versioned scenarios and expected outcomes
  reports/                       # sanitized, reviewed summaries
  recordings/private/            # local only; ignored
  reports/local/                 # local only; ignored
```

The native package owns executable decision logic used by live and replay sessions. TypeScript does not reimplement the estimator for test convenience. The iOS app hosts OS-specific effects. VPN extension code remains narrow and independent of React Native.

Do not create a generic `utils`, registry, plugin framework, or a shared cross-platform layer for hypothetical Android consumers. Files should declare their symbols; imports name those files. A new folder earns its place through actual code ownership, not through the diagram.

Tests live beside React features or in the Swift package test target. Raw protocol fixture data belongs under `harness/fixtures/`; private road recordings do not. Native simulator/device test targets and a replay executable will be added only after their build integration is proven in the relevant plans.
