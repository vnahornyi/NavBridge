# OBD integration

## Known and unknown

The owner has a Viecar VC100 advertised as Bluetooth 4.0 / ELM327 v1.5 / PIC18F25K80. This label does not establish actual firmware, BLE service UUIDs, characteristic properties, command echo behavior, vehicle PID support, sampling rate, or response latency. No vehicle capture has been collected for NavBridge.

Use CoreBluetooth for the planned iOS path. Discover the actual peripheral services and readable/writable/notifying characteristics. Record UUIDs, properties, adapter identifier response, ignition/engine state, and vehicle support evidence in NB-005. Do not substitute a common ELM adapter's UUIDs as a default for this device.

## Command scope

Start with adapter identification, supported-PID discovery, and read-only standard vehicle-speed requests. The expected speed request is `01 0D`, with a successful payload of the form `41 0D A`, interpreted as unsigned kilometers/hour before conversion to meters/second. Treat this as a protocol expectation to confirm against authoritative ELM/OBD documentation and actual frames; the cited emulator is interoperability evidence, not proof of this adapter.

Do not send fault-clear, actuator, coding, proprietary ECU, or CAN transmit commands. Adapter configuration commands must be documented, reversible where supported, and validated on the exact adapter. `ATZ`, echo, line endings, headers, spaces, and protocol selection behavior are not assumed universal.

## Framing and request ownership

BLE notifications are byte fragments, not response boundaries. A response may span multiple notifications or contain several lines. The decoder must handle echo, CR/LF, optional spaces/headers, the prompt delimiter, status lines, and empty/error responses. Preserve raw bytes in opt-in local diagnostics.

Allow one request in flight. Associate decoded results with the requested PID and current connection generation. Never interpret an unrelated ECU response, adapter identification, `NO DATA`, `STOPPED`, `?`, malformed hex, or a timeout as zero speed. A measured zero speed is valid; missing speed is unavailable.

After a timeout or interrupted frame, a late reply must not satisfy the next request. Enter an explicit resynchronization state: drain to a verified prompt or reset/reconnect according to the measured protocol policy before submitting a new request. Bound buffer size and waits with documented measured configuration, not unexplained constants.

## Timing and quality

Record request-send and response-receive monotonic times. The vehicle measurement instant is generally not supplied by this PID; timestamp interpretation and estimated delay must be documented rather than treating receive time as perfect capture time. Measure latency distribution, fragmentation, successful sample intervals, and dropouts while stationary and during authorized driving tests.

Choose polling, freshness, retry, and resynchronization settings from those measurements. Avoid unbounded retries or overlapping polling loops after reconnect. Old-generation replies are discarded. Missing input halts valid integration and triggers the session recovery policy.

The speed byte is unsigned and quantized; it cannot distinguish reverse gear or recover absolute heading. Resolve the motion-mode decision before road integration. A forward-only limit must be visible and relies on the agreed operator procedure; this PID cannot automatically enforce it or detect reversing. Additional PIDs are not assumed to expose steering angle or gear on the owner's vehicle.

## Required tests

Pure decoder tests cover fragmented prompts, multiple frames, echo on/off, whitespace/header variants supported by the selected configuration, explicit errors, unrelated PID, invalid bytes, zero/max byte values, timeout plus late reply, disconnect, and reconnect. Synthetic frames are labelled synthetic. A compatibility claim additionally requires a reviewed capture from the actual adapter/vehicle.
