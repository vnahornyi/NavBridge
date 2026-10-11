# Business plan

## Current business objective

Build a useful personal prototype for the owner before deciding whether a commercial product exists. The immediate value hypothesis is continuity of vehicle positioning in Waze when satellite-derived position is unreliable, using equipment the owner already has.

This is a hypothesis, not a claim of proven navigation accuracy or product-market fit. The first user is the owner, with a Volkswagen Polo Sedan 2013 and a Viecar VC100 described in the supplied concept. Vehicle identity and adapter compatibility must be verified during field work.

## Customer and problem hypotheses

| Segment | Hypothesized problem | Validation needed |
|---|---|---|
| Owner/personal use | Waze position becomes unusable during GNSS disruption | Record reproducible examples and whether the prototype improves them |
| Technical iPhone users | Will accept pairing, special installation, and calibration | Direct interviews or an explicitly authorized pilot |
| General drivers | Want reliable one-button navigation continuity | Distribution, usability, support, and accuracy requirements not yet established |

Do not infer a market size from the number of iPhone owners or drivers. No TAM/SAM/SOM, willingness-to-pay, retention, revenue, or conversion data has been collected. No external interviews or messages are authorized by this document.

## Proposed value and differentiation

An integrated local application could combine manual anchoring, measured vehicle speed, relative turn tracking, visible quality status, and reproducible session diagnostics. Its usefulness must be compared with the owner's normal Waze behavior and a simple manual-anchor baseline on the same routes.

Competition research is pending. Existing location simulators demonstrate a transport mechanism; they do not prove a competing dead-reckoning product. Existing GPS/INS accessories may solve different installation and accuracy problems. Do not claim NavBridge is unique without a source-backed comparison.

## Delivery gates

| Gate | Evidence required | Decision |
|---|---|---|
| Personal feasibility | Own signed tunnel/output build; Waze phone tests; stop/restore proof | Proceed with personal integration or retain a documented blocker |
| Positioning usefulness | Independent references and repeatable drift measurements | Improve algorithm, narrow supported conditions, or stop |
| One-app usability | Setup and session flow work without switching between helper apps after setup | Keep integrated packaging or revisit it with owner agreement |
| CarPlay | Own device/head-unit experiment | Claim support only for verified configurations |
| Commercial feasibility | Distribution path, licensing, accuracy/support obligations, demand evidence | Separate commercial decision; not implied by prototype success |

## Cost model

| Cost | Current evidence | Treatment |
|---|---|---|
| Existing phone, vehicle, OBD adapter | Owner reports ownership | Record incremental cost separately from sunk hardware cost |
| Apple Developer Program | Apple lists USD 99 per membership year, or local currency where available | Membership status, taxes, payment currency, and actual charge remain unconfirmed |
| Development and research | No measured task throughput or agreed budget yet | Track actual session effort; estimate after feasibility tasks |
| Vehicle tests | Fuel, travel, tester time, mounting hardware | Enter actual local amounts; do not invent a fuel price |
| Maps and commercial services | Provider not chosen | Check license and actual tariff before adoption |
| Hosting/backend | Not part of proposed personal baseline | Do not add a recurring service without a demonstrated need |
| Support, maintenance, distribution | Unknown compatibility burden | Include in any later commercial scenario |

Membership source checked on 2026-10-11: [Apple enrollment](https://developer.apple.com/programs/enroll/). This is a published list fee, not a project quotation.

Use variables until measured:

```text
personal_incremental_cost = membership + test_costs + new_hardware + paid_services
development_cost = recorded_hours × agreed_hourly_cost
commercial_margin_per_customer = net_price - variable_service_cost - support_cost - distribution_cost
break_even_customers = fixed_commercial_cost / positive_commercial_margin_per_customer
```

Commercial equations are scenario definitions, not forecasts. Keep taxes and platform fees explicit once a distribution model exists. A non-positive margin has no finite break-even value.

## Revenue hypotheses and go-to-market

Possible later models are a personal tool, a paid enthusiast application, or software bundled with validated hardware. Each requires separate evidence. No subscription, paid release, advertising campaign, partner contact, publication, or hardware purchase is approved here.

Start with the owner's measured results. Only after a commercialization decision should the owner authorize interviews, pilot recruitment, pricing experiments, or a distribution experiment. App Store eligibility of the developer-simulation approach is unconfirmed and is a commercial gating risk.

## Success and stop criteria

Technical usefulness, acceptable setup burden, measurable recovery behavior, and an attainable distribution path precede revenue planning. The owner must agree on acceptable drift, duration, and intervention frequency before a field pass/fail is meaningful. Suspend expansion if the current iOS mechanism is unstable, input quality is insufficient, or setup/support costs exceed the owner's chosen value.
