# Acceptance and traceability

All implementation rows are currently **not implemented / not run**. The documentation foundation is reviewed through NB-000. Future plans are drafts; accepting these documents does not approve all future code changes.

| Requirement | Planned proof | Owner plan | Completion condition |
|---|---|---|---|
| R-01 React Native NavBridge | Template preservation; native bridge build; feature render | NB-002, NB-008 | Actual signed build and RN behavior checked |
| R-02 iOS 27 only | Device/version record; supported matrix | NB-001, NB-009 | Exact personal device validated; no implied Android support |
| R-03 Waze receives our position | Own-build stationary set/clear and route observation | NB-004, NB-009 | Transport and accuracy evidence recorded separately |
| R-04 Start/Stop | Native lifecycle race tests and physical cleanup | NB-002, NB-004, NB-008 | Correct authoritative state; no false Stop success |
| R-05 Manual coordinate correction | Draft/cancel/confirm behavior, atomic replay, device observation | NB-006, NB-007, NB-008 | Older generation cannot overwrite correction |
| R-06 Existing Viecar | Actual UUID/protocol capture, decoder tests, field speed | NB-005 | Compatibility measured on the owner's adapter/vehicle |
| R-07 Phone first, CarPlay later | Separate phone and head-unit reports | NB-009, NB-010 | Each support claim matches tested configuration |
| R-08 Detailed planning/testing/harness design | Link/scope review of docs and plans | NB-000 | Complete reviewable documentation staged |
| R-09 Persistent Git plans | Tracked plan index, statuses, session prompts | NB-000 | Plans retained across implementation and new sessions |
| R-10 English documentation | Document review | NB-000 | README, docs, harness conventions, and plans in English |

## Cross-cutting gates

| Gate | Proof required |
|---|---|
| Valid input | Missing/malformed/stale speed or motion cannot silently extend movement |
| Time correctness | Mapped monotonic timestamps; no integration across unobserved gap |
| Source independence | Injected/unknown system location excluded from reference/correction |
| Replay | Same production core and identical event/configuration outcomes under declared tolerance |
| Cleanup | Set/Stop/correction races covered; unknown clear remains cleanupRequired |
| Privacy | No credentials/real trips in staged files; explicit recording/export design |
| Background | Device results support intended Waze-foreground use; VPN survival alone insufficient |
| Usefulness | Owner-approved drift/duration/intervention targets and independent reference |
| Distribution | Actual signed personal install guide; commercial eligibility separately unresolved |

## Definition of done per implementation task

The task's approved scope is implemented, its specified authorized checks have actual results, relevant docs/contracts are updated, limitations are recorded, exact files are staged and the owner approves the complete diff. Only then can its persistent plan be marked Complete. Code merely compiling or a test being listed in a plan does not satisfy a device gate.
