# Scenarios

No executable scenario files exist yet. Use IDs H-01 through H-14 in the [catalog](../../docs/testing/harness.md) when NB-007 implements them.

A scenario specifies fixture/boundary, engine configuration, deterministic injected faults, expected phase/effect outcomes, independent numerical oracle where available, and tolerance rationale. Preserve input provenance. Record duplicate/out-of-order events intentionally rather than accidentally changing ingestion order.

The runner must distinguish expectation failure, invalid input, incomplete recording, and unsupported schema. It must not pass by silently skipping required records or replacing missing measurements with zero. Golden outputs require reviewed independent expectations.
