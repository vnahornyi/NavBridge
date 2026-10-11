# Documentation

All documents describe the intended design unless they explicitly say **observed**, **implemented**, or **measured**. Plans are drafts until individually approved.

## Product

- [Requirements](product/requirements.md): provenance, scope, acceptance, exclusions.
- [User flows](product/user-flows.md): setup, start, correction, stop, recovery.
- [Business plan](product/business-plan.md): personal value, hypotheses, costs, commercial gates.

## Architecture

- [System design](architecture/system-design.md): ownership and data flow.
- [Repository structure](architecture/repository-structure.md): existing tree and proposed paths.
- [Contracts](architecture/contracts.md): commands, events, units, errors, versions.
- [Positioning](architecture/positioning.md): baseline algorithm and limits.
- [Session lifecycle](architecture/session-lifecycle.md): transitions, cancellation, cleanup.

## Engineering

- [iOS integration](engineering/ios-integration.md): RN bridge, tunnel, pairing, output, background.
- [OBD protocol](engineering/obd-protocol.md): discovery, framing, sampling, recovery.
- [Development](engineering/development.md): current commands and future tooling.
- [Privacy and licensing](engineering/privacy-and-licensing.md): records, upstream components, distribution.

## Verification

- [Strategy](testing/strategy.md): tests by responsibility.
- [Harness design](testing/harness.md): deterministic replay and fault injection.
- [Device validation](testing/device-validation.md): physical procedures and evidence.
- [Acceptance matrix](testing/acceptance.md): requirements mapped to proof.
- [Harness folder contract](../harness/README.md): what is present now.

## Research and execution

- [Evidence](research/evidence.md): primary sources and verified repository baseline.
- [Open questions](research/open-questions.md): decisions and measurement blockers.
- [Plans](../plans/README.md): task order and new-session workflow.

Update the document owning a decision and the affected task plan together. Link to evidence rather than copying an old assumption into several independent requirements.
