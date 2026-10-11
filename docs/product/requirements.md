# Product requirements

## Confirmed by the owner

| ID | Requirement | Provenance |
|---|---|---|
| R-01 | React Native application named NavBridge, in this repository | Conversation; owner-created template |
| R-02 | iPhone running iOS 27; Android is outside scope | Explicit platform answer |
| R-03 | Feed our estimated position to Waze through system location; Waze remains the navigator | Owner corrected the earlier standalone-map proposal |
| R-04 | One primary Start/Stop control | Original request |
| R-05 | A map for manually setting or correcting current position | Owner's explicit follow-up |
| R-06 | Connect to the existing Viecar VC100, advertised as ELM327 v1.5, Bluetooth 4.0, PIC18F25K80 | Owner-provided model; characteristics still require device verification |
| R-07 | Waze on the phone is sufficient for initial validation; CarPlay remains a later goal | Owner's scope clarification |
| R-08 | Plan thoroughly before runtime implementation; include structure, documentation, business, tests, harness | Current request |
| R-09 | Track plans in Git and continue through new sessions | Current explicit override |
| R-10 | Write all documentation and plans in English | Owner's answer during foundation planning |

## Desired design requiring task approval

| ID | Proposed decision | Agreement or evidence needed |
|---|---|---|
| P-01 | Embed the local VPN extension and Locus-style pairing/output in one application | Owner asked about feasibility; signing membership and own-build test remain unresolved |
| P-02 | User confirms both position and vehicle heading; heading correction is available | Coordinates alone do not determine forward direction |
| P-03 | Phone remains rigidly mounted; moving it requires recalibration | Installation procedure and detection behavior need agreement |
| P-04 | First estimator uses measured speed and relative yaw, with manual correction | No accuracy commitment until field measurements |
| P-05 | Initial baseline supports forward motion only, with an explicit reverse limitation | Needs agreement; standard speed alone cannot resolve signed motion |
| P-06 | Clear output on data failure and show an explicit recovery state if clear is not confirmed | Recovery behavior must be proven on the device |
| P-08 | Recording is explicit and local; no backend or automatic uploads | Product/privacy default proposed for approval |

Do not implement P-05 by silently treating reversing as forward motion. An alternative is a manual forward/reverse control; decide it in NB-001 and update the affected plans before code.

## Concept backlog, outside the initial baseline

The supplied concept mentions automatic GNSS anomaly detection, map matching, cellular/Wi-Fi positioning, external CAN/IMU hardware, and long outages. These are research directions, not accepted baseline features. No precise accuracy, sampling rate, outage duration, offline-map coverage, or automatic spoofing-detection promise has been established.

## Prototype acceptance

The owner can select a position and heading, start an authorized live session, observe Waze following the position, correct it, and stop with a verified clear or an explicit unresolved cleanup state. Missing/stale inputs must not silently produce continued dead reckoning. The same engine must support deterministic replay. Performance, duration, accuracy, and resource thresholds are defined from measurements and owner-approved use cases in NB-001/NB-009.

This does not claim that native GPS is universally disabled, every application accepts simulated location, or CarPlay uses the same source selection as phone Waze.
