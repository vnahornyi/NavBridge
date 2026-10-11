# NavBridge

An experimental iPhone positioning companion for Waze, using vehicle speed from a Viecar VC100 OBD adapter and motion measurements from a mounted phone.

**Status: planning.** The repository currently contains the React Native template and project documentation. OBD integration, dead reckoning, local VPN integration, pairing, and location output are not implemented in NavBridge.

The owner reported that Waze on their iOS 27 phone follows coordinates supplied by an external location-simulation tool. This validates one integration observation; it does not validate continuous updates, background operation, CarPlay, positioning accuracy, or our own implementation.

## Intended experience

1. Complete the initial device pairing and permissions setup.
2. Select the actual vehicle position on the map and confirm the vehicle heading.
3. Press **Start** to connect to the OBD adapter and start the positioning session.
4. Open Waze, which receives the position through iOS system location services.
5. Return to NavBridge for a manual position or heading correction when necessary.
6. Press **Stop** to clear the supplied location and release session resources. If clearing fails, show an explicit recovery state rather than claiming the session is fully stopped.

The desired packaging is one application with an embedded local VPN extension. Signing feasibility remains an open dependency. Waze on the phone is the first integration target; CarPlay is a later validation task. Android is outside the product scope; the generated Android template remains untouched.

## Read first

- [Project instructions](AGENTS.md)
- [Documentation index](docs/README.md)
- [Requirements and their provenance](docs/product/requirements.md)
- [System architecture](docs/architecture/system-design.md)
- [Repository structure: existing versus planned](docs/architecture/repository-structure.md)
- [Business plan](docs/product/business-plan.md)
- [Testing strategy](docs/testing/strategy.md) and [replay harness](docs/testing/harness.md)
- [Evidence and sources](docs/research/evidence.md)
- [Open questions](docs/research/open-questions.md)
- [Persistent implementation plans](plans/README.md)

## Current development setup

Verified from the template: React Native `0.87.1`, React `19.2.3`, Node `>=22.11.0`, npm lockfile, CocoaPods, TypeScript, ESLint, and Jest. The checked-in Xcode project still has its generated bundle identifier and iOS deployment target `15.1`; the intended prototype device runs iOS 27. These are different facts, not evidence that NavBridge supports older iOS versions.

```bash
npm ci
bundle install
cd ios
bundle exec pod install
```

From the repository root, start Metro with `npm start`; use `npm run ios` or open `ios/NavBridge.xcworkspace` in Xcode. These commands currently run the template, not the proposed product.

Existing checks, to be run only for an authorized implementation scope:

```bash
npx --no-install tsc --noEmit
npm run lint
npm test -- --runInBand
```

No Swift package, replay CLI, device test runner, or CI workflow exists yet. Their proposed paths and installation steps belong to the corresponding plans. Simulator tests will not prove Waze injection or BLE compatibility.

## Working across sessions

Start a new session with: “Read AGENTS.md, plans/README.md, and plans/NB-001-feasibility-and-baseline.md. Continue that task; inspect Git and its open questions before making changes.”

Plans are tracked project assets. Keep completed plans, update them in place, and record evidence and remaining limitations inside the relevant plan. Do not create a second state system. Implementation starts only after the owner approves the relevant plan and its unresolved product decisions.

## Licensing

The license for NavBridge itself has not been selected. Upstream components retain their own conditions; see [privacy, dependencies, and licensing](docs/engineering/privacy-and-licensing.md). No upstream source or binary is vendored in this documentation change.
