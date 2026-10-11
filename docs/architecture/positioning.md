# Positioning design

## Baseline and prerequisites

Proposed first estimator: a user-confirmed position and vehicle heading, OBD-derived speed, and relative yaw from a rigidly mounted phone. It is a measured baseline before choosing EKF/ESKF, road matching, or extra hardware.

It cannot recover an absolute position from speed alone. Initial heading is separate from coordinate selection. Standard speed does not identify reverse motion. Phone movement is not necessarily vehicle turning. These limitations must remain visible in acceptance and supported conditions.

## Coordinate and time conventions

Represent heading clockwise from true north and distance in meters. Convert speed units once at the input boundary. Use observed monotonic deltas; never integrate by a requested nominal sampling interval. Convert native sensor timestamps to the session clock with an explicit, recorded mapping. Do not assume unrelated clock APIs share an epoch or suspend behavior.

CoreMotion's gravity and rotation vectors are expressed in device coordinates. The proposed conversion projects angular velocity onto the normalized gravity/down direction to estimate yaw around local vertical. Validate sign and axis conventions using controlled left/right turn and mounting-orientation tests before live use. This alone does not guarantee roll/pitch isolation, bias removal, or true vehicle yaw accuracy.

The first geometry implementation should use a documented geodetic propagation formula rather than an unexplained meters-per-degree constant. Test cardinal headings, heading wrap, zero movement, and longitude wrap. Record the chosen Earth model and its source; numerical assumptions are not product accuracy claims.

## Integration and quality

1. Validate and order each input; reject duplicates, invalid values, and events from an old generation.
2. Establish calibration and valid initial position/heading.
3. Align speed and yaw by observed timestamps and the approved hold/interpolation policy.
4. Integrate heading and distance using a documented method with analytic synthetic cases.
5. Propagate position and emit a candidate only when required inputs remain valid.
6. Serialize output and record the actual acknowledgement separately from the estimate.

Freshness windows, delay compensation, interpolation, polling rates, and calibration duration remain unset until NB-001/NB-005/NB-006 measurements. Configure them explicitly with units, evidence, and a revision. For a gap outside the approved window, invalidate movement and require recovery; do not integrate the latest speed across the missing interval.

Stationary bias calibration requires confirmed stationary conditions; a disconnected adapter reporting no data is not stationary evidence. Calibration records include mount orientation and sample quality. Recalibrate after moving the phone. A magnetometer may be investigated later but is not an assumed reliable heading source inside the car.

## Correction and restart

A correction atomically replaces the confirmed position and/or heading, advances the generation, cancels older queued output, and resets the integration time baseline. Replay records the correction as an event. Position-only correction must not silently overwrite heading; the command must express which fields are supplied.

After stop, data loss, process restart, or an unobserved time gap, do not continue an old estimate by assuming the car stayed stationary. Require current inputs and a confirmed recovery anchor when needed.

## Measuring usefulness

Use independent reference trajectories and manual checkpoints. Report displacement error, heading error, along/cross-track error when reference geometry supports it, traveled-distance bias, turn timing, time without trustworthy inputs, and intervention frequency. Include reference uncertainty and alignment method.

Do not treat Waze's rendered marker or map snapping as ground truth. Do not use the same phone's simulated Core Location stream as its reference. A second independent reference device or a separate non-injected reference run must be specified, with the limitations of each comparison.

No numerical accuracy target or uncertainty covariance is currently validated. Quality labels should describe evidence (valid/stale/unavailable/unvalidated), not fabricate confidence. Define agreed use-case thresholds before claiming a field pass.
