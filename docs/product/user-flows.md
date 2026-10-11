# User flows

These flows are design proposals for the plans, not existing screens.

## First setup

Explain the local tunnel, device pairing, Bluetooth, motion, and any background location permission used by the chosen design. Ask for permissions when needed. An embedded VPN requires the system consent flow; pairing requires a system action. Do not promise a one-tap first install.

Record setup outcomes separately: permission missing, pairing missing, tunnel unavailable, OBD unavailable, or ready. A failed step has a specific retry or settings action. Do not request unrelated contacts, microphone, advertising, or account permissions.

## Establish position

The map selection is an editable draft. “I am here” confirms the geographic coordinate; heading selection confirms the vehicle body's heading clockwise from true north. Allow explicit coordinate entry when map tiles are unavailable. Record whether values are manual or derived from a trusted pre-session observation.

No automatic prefill may claim current Core Location data is independent after our injection starts. The last selection is a convenience, never an assertion that the vehicle has not moved.

## Start

Validate confirmed position/heading, mounting/calibration, permitted motion mode, device setup, tunnel, and fresh sensor inputs. Start shows a connecting state until the dependencies and first output are acknowledged. Keep Stop available during startup. Prevent repeated taps from creating competing sessions.

Open Waze on the phone and verify its vehicle marker, rather than only its destination pin. Waze route selection remains in Waze. Native work continues independently of the React screen lifecycle.

## Correct

Return to NavBridge and edit a position/heading draft. Cancelling leaves the live estimate unchanged. Confirmation creates one atomic correction with a new generation and time baseline; old queued output is rejected. Explain which fields are being corrected. Prefer correction while stationary; moving correction semantics require a separate decision.

## Stop and recovery

Stop cancels new estimation/output, clears the supplied system location while transport is still available, then closes the tunnel and sensors. Acknowledged clear is different from merely closing a handle. If clear fails, keep the UI in a recovery state with a retry action; disclose that system position may remain overridden. Never display a successful stop for an unconfirmed clear.

## Faults and relaunch

Show missing/stale data as missing/stale, not zero speed. On transport or permission loss, stop integrating and attempt output cleanup. Reconnection does not automatically resume motion from old inputs. After relaunch, inspect any outstanding cleanup marker before permitting Start. Forced termination recovery is an experiment, not a promised automatic clear.

## Accessibility and presentation

Use accessible names and disabled/busy states for controls; support Dynamic Type, light/dark themes, and small screens. Keep BLE UUIDs, tunnel IPs, and detailed traces in setup/diagnostics rather than the primary driving flow. UI language and map library are open decisions; no Figma or approved visual specification exists.
