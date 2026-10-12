# Privacy, dependencies, and licensing

## Data policy proposal

The baseline has no account, backend, telemetry, advertising, or automatic upload. Recording is an explicit local action; default diagnostic text excludes real coordinates and pairing contents. The owner approves the final consent/export/retention behavior before NB-007 implementation.

| Data | Proposed handling | Git policy |
|---|---|---|
| Pairing records and device authentication keys | Keychain generic-password item, `AfterFirstUnlockThisDeviceOnly`, not synchronized (NB-004 decision, 2026-10-12); explicit Forget pairing; no automatic deletion on transport errors; stale item removed on first launch after reinstall | Never track or paste into plans |
| Certificates, signing keys, provisioning profiles | Owner-managed signing storage | Never track |
| Adapter/device identifiers | Local diagnostics only, redact for sharing | Do not publish raw identifiers |
| Live positions, motion and speed recordings | Explicit local recording/export | Private ignored folder; no automatic upload |
| Synthetic scenarios | Clearly labelled, invented data | Track after review |
| Reviewed test summaries | Minimum necessary evidence, redacted | Track only after privacy review |
| Outstanding-output recovery marker | Minimal state, no coordinates/keys | Application storage, not repository |

`.gitignore` is a convenience, not a credential protection system. Inspect staged files and exports. Choose storage quotas, retention, and encryption/protection settings based on measured use and device requirements; no arbitrary quota is established here. Recorder failure must not silently masquerade as a successful recording, and must not block an urgent Stop.

## Dependency register

| Component | Role | Observed licensing / current action |
|---|---|---|
| React Native and existing template dependencies | Existing host | Inspect installed package licenses and lockfile versions before distribution |
| Locus | Reference pairing and developer-output integration | MIT at the pinned revision; preserve copyright and permission notices if code is reused |
| idevice and its transitive dependencies | Native protocol/FFI dependency | Audit selected source revision, all linked dependencies, build provenance, and redistribution conditions before vendoring |
| LocalDevVPN | Reference local tunnel | Custom StosVPN License at pinned revision, not simply MIT; attribution, notices, and name/branding restrictions require review |
| Map provider/library | Manual coordinate selection | Not selected; assess tile/data license, offline behavior, keys and costs |
| NavBridge's own code | Project | License not selected; no open-source publication implied |

Read the exact upstream license files in [the evidence register](../research/evidence.md). LocalDevVPN's conditions include prominent attribution and preserving notices, with restrictions on distributing the entire/substantially similar project under the same or similar name/branding without permission. Confirm applicability to the exact reused portion before copying. A README summary does not replace the license.

No upstream code or binary is copied by the documentation foundation. The app name NavBridge is a working project name; no trademark/name-availability research has been completed.

## Distribution gates

A personal signed prototype does not establish App Store acceptability. Developer location simulation, background execution approach, VPN capability, dependency terms, and support expectations all need a separate commercial/distribution review. Choose the intended distribution before spending on publication or marketing. No legal conclusion or certification is claimed by these engineering notes.

## Review before sharing

Check pairing files, key material, device identifiers, route coordinates, screenshots, logs, build products, and metadata. Real trajectory translation alone may preserve a recognizable route; do not call it anonymous without review. Sharing a private report or contacting an upstream author requires explicit owner authorization.
