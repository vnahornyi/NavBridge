# NavBridge project instructions

## Scope and source of truth

NavBridge is an iOS 27 personal prototype built with React Native. Waze on iPhone is the first target; CarPlay is a separate validation milestone. Do not introduce Android implementation, a backend, accounts, analytics, automatic road matching, cellular positioning, or a commercial distribution promise without the owner's agreement.

Read `docs/product/requirements.md`, `docs/research/evidence.md`, and the current task plan before implementation. Separate owner-confirmed requirements, proposed decisions, external documentation, user-reported observations, and measured results. Never describe a planned folder or test as implemented.

## Persistent plans: explicit owner instruction

The owner explicitly requested a tracked `plans/` directory and execution through new sessions. This project-specific instruction overrides generic skill guidance to keep only a temporary plan, ignore plans in Git, or delete plans after implementation.

- Keep one Markdown plan per task in `plans/`, named `NB-NNN-short-slug.md`.
- `plans/README.md` is the dependency index, not an additional implementation plan.
- Keep completed plans. Correct the same file; do not create v2 copies, state JSON, segment manifests, handoff files, or separate review/fixes files.
- Update status and actual verification in the task plan and its index entry together.
- Status is a human-reviewed summary. Git and actual evidence determine what exists.
- Use `Draft`, `Approved`, `In progress`, `Blocked`, `Implemented — awaiting approval`, or `Complete`. Do not mark a task approved merely because its documentation was accepted.
- Each new session reads the applicable instructions, checks Git status/branch/HEAD and the exact plan, verifies prerequisites against the current tree, and states the remaining scope.
- Stop for unresolved blocking questions that affect that task. Continue unrelated authorized documentation work.
- Implementation requires owner approval of the task scope. New dependencies and product decisions must be visible before coding.

## Git boundaries

Follow the user's global Git rules. Stage only exact task files, show the staged stat and full diff, propose a commit message, and stop. Do not commit without explicit approval for that staged set or scoped autoapproval. Never push from this repository. Subagents never stage, commit, or push. Preserve unrelated changes.

## Engineering rules

- React Native owns presentation, editable drafts, and user commands. Native Swift owns the live session, sensor ingestion, clock mapping, estimation, and location output. Live movement must not depend on JS timers or a mounted screen.
- Use a small code-generated native interface compatible with the installed React Native version. Verify Codegen types instead of assuming every TypeScript union can cross it directly.
- Keep pure estimator and session decision logic testable without UIKit, BLE, VPN, Waze, or React Native. Production and replay use the same implementation.
- Import declaring files directly; do not add re-export-only barrels or speculative registries/frameworks.
- English code, identifiers, README, documentation, and task plans, as explicitly requested by the owner. UI locale selection remains a separate product question.
- Do not invent polling rates, freshness limits, calibration windows, tolerances, retention quotas, or positioning-accuracy claims. Record each value's source or measurement and approval.
- Never use our injected Core Location output as an independent navigation measurement or ground truth.
- Serialize session effects; tag asynchronous work by session/generation. Stop and correction must not permit old callbacks to resume movement.
- A failed clear is an explicit `cleanupRequired` outcome. Do not claim normal system location was restored merely because a local handle or VPN was closed.
- Do not edit generated Codegen output or vendor opaque libraries without recording source revision, license, build recipe, architecture slices, and artifact verification.

## Testing and records

Follow `docs/testing/strategy.md` and `docs/testing/harness.md`. Add the meaningful tests specified by an approved implementation plan. For this documentation-only stage, run document/link/scope checks; do not run application tests or install dependencies.

Synthetic fixtures may be tracked with clear provenance. Pairing records, certificates, provisioning profiles, live device logs, and real trip recordings remain local and outside Git. See `.gitignore` and `docs/engineering/privacy-and-licensing.md`.

Report exactly which automated, simulator, device, Waze, CarPlay, and vehicle checks ran, and which did not. A replay pass is not a device validation pass. Do not mutate the owner's Waze installation or collect private trip data without an explicit task instruction.
