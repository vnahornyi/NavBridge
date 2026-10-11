# Persistent task plans

The owner explicitly requested repository plans that survive new sessions. These are tracked project assets, including after completion. This overrides generic temporary-plan deletion/ignore rules. All plans are English.

## Roadmap and status

| Task | Deliverable | Prerequisites | Status |
|---|---|---|---|
| [NB-000](NB-000-documentation-foundation.md) | Documentation foundation | — | Implemented — awaiting approval |
| [NB-001](NB-001-feasibility-and-baseline.md) | Feasibility and baseline | NB-000 | Draft |
| [NB-002](NB-002-native-session-contract.md) | Native core and session contract | NB-001 | Draft |
| [NB-003](NB-003-integrated-local-tunnel.md) | Integrated local tunnel | NB-001, NB-002 | Draft |
| [NB-004](NB-004-location-output-and-pairing.md) | Location output and pairing | NB-001, NB-002, NB-003 | Draft |
| [NB-005](NB-005-viecar-obd.md) | Viecar OBD discovery and speed | NB-001, NB-002 | Draft |
| [NB-006](NB-006-motion-and-dead-reckoning.md) | Motion and dead reckoning | NB-001, NB-002, NB-005 | Draft |
| [NB-007](NB-007-recording-and-replay-harness.md) | Recording and replay harness | NB-002, NB-004, NB-005, NB-006 | Draft |
| [NB-008](NB-008-control-screen-and-correction.md) | Control screen and correction | NB-002, NB-004, NB-005, NB-006, NB-007 | Draft |
| [NB-009](NB-009-background-and-device-validation.md) | Background and device acceptance | NB-003, NB-004, NB-005, NB-006, NB-007, NB-008 | Draft |
| [NB-010](NB-010-carplay-validation.md) | CarPlay validation | NB-009 | Draft |
| [NB-011](NB-011-personal-release-and-business-gate.md) | Personal release and business gate | NB-009 | Draft |

NB-010 is a separate CarPlay gate. NB-011 may deliver phone-only personal installation after NB-009, but it cannot claim CarPlay support without NB-010. Independent branches of the dependency graph may be worked sequentially in whichever approved order the owner chooses; no parallel-agent execution is assumed.

## How to use a new session

1. Read repository/global instructions and the chosen plan.
2. Inspect Git branch, HEAD, staged/working changes; preserve unrelated work.
3. Verify prerequisites in the actual tree and device reports. A plan listing a file/test does not mean it exists.
4. Resolve only that task's blocking decisions; obtain implementation approval for a Draft plan.
5. Implement the agreed task and run its authorized checks. Update actual evidence in the same plan.
6. Stage exact task files, show stat/full diff and propose a commit message. Stop for owner approval; never push.
7. Mark Complete only after the task outcome, required verification and complete-diff approval. Keep the plan and update this index.

Default next task after foundation approval: [NB-001](NB-001-feasibility-and-baseline.md). Do not start live code automatically when documentation is approved.

## Status semantics

- **Draft:** planned, not approved for implementation.
- **Approved:** owner approved this task and relevant decisions.
- **In progress:** authorized work has started.
- **Blocked:** a named prerequisite prevents this task's required next work.
- **Implemented — awaiting approval:** work/checks are ready for complete-diff review; no implicit commit approval.
- **Complete:** outcome and required checks are achieved, limits recorded, complete diff approved.

Update status in the task and index together. Keep one file per task named `NB-NNN-short-slug.md`. Correct it in place; no v2 copies, per-task state JSON, segment manifests, handoff files or extra review/fixes plans. Add a new task only for separately agreed scope, preserving existing IDs.

No runtime task currently has implementation approval or passing verification. NB-000 covers only the authorized documentation foundation. NB-001 includes a bounded execution guide for a smaller coding model; use its ready-to-paste prompt for the first new session.
