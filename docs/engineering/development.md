# Development and delivery

## Verified starting point

The repository begins with a React Native CLI template. `package.json`, `package-lock.json`, `Gemfile.lock`, and `ios/Podfile.lock` are tracked. `App.tsx` displays the template, and `__tests__/App.test.tsx` is its render smoke test. There is no product bridge, Swift package, packet-tunnel target, replay executable, or CI pipeline yet.

Current local Xcode was observed as 27.0 (27A266a). Recheck the active toolchain in a new session. The checked-in deployment target is 15.1, Swift setting is 5.0, and bundle identifier is generated. These are template settings to revisit in NB-001/NB-002; none defines the supported product device matrix.

## Template commands

From the root, `npm ci` installs locked JavaScript dependencies and `bundle install` installs Ruby dependencies. Then run `bundle exec pod install` inside `ios/`. Start Metro with `npm start` and run `npm run ios`, or use `ios/NavBridge.xcworkspace` in Xcode. Verify signing before a physical-device run.

Existing check commands are `npx --no-install tsc --noEmit`, `npm run lint`, and `npm test -- --runInBand`. They are available commands, not recorded passes. Do not run them for this documentation-only change. No native replay or Swift test command is usable until its package/target exists.

## Future build integration

NB-002 adds the pure Swift package and Codegen spec, wires the package into the iOS host, and records exact working commands. Once the package exists, `swift test --package-path native/NavBridgeCore` is the intended unit-test entry point, subject to toolchain verification. Do not advertise it as an existing script before that task.

NB-003 adds the embedded extension with owner-approved identifiers/signing. NB-004 records reproducible idevice builds and dependency provenance. NB-007 adds a replay executable and only then documents its actual invocation and exit codes. No speculative npm aliases or empty CI workflows are added now.

Introduce CI after deterministic tests run locally: locked JS checks and Swift package tests can run without a physical vehicle. Native build checks need a suitable macOS/Xcode runner. Signing secrets, pairing files, physical-device testing, Waze, and CarPlay stay outside an unattended hosted CI baseline. Choose runner/service and budgets before enabling paid jobs.

## Session workflow

Read `AGENTS.md`, `plans/README.md`, and the selected plan. Inspect branch/HEAD, staged/working changes, prerequisite plans, and current device evidence. State the task's scope and unresolved decisions. Do not switch branches, overwrite user changes, or begin another task implicitly.

Update the task plan in place with decisions, actual files, commands/results, skipped checks, and residual limits. Stage exact task files, show the staged stat/full diff, propose a commit message, and stop. Keep plans in Git, including completed ones. Commit approval covers only the reviewed staged set; no push is performed.

## Version and installation records

For each personal build record Git revision, dependency locks, Xcode/iOS/device versions, identifiers, install method, entitlements, and configuration revision. Keep signing credentials private. A device installation guide is delivered in NB-011 after the actual install path is proven; the template commands are not that guide.
