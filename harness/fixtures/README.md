# Fixtures

No executable fixtures exist yet. NB-007 creates the first versioned synthetic JSONL fixtures after the event schema and replay boundary are implemented.

Each fixture needs a stable name, schema version, synthetic/real provenance, generator or capture method, units, clock mapping, configuration revision, tested input boundary, reference/oracle source, expected behavior, and completeness. Synthetic values are test choices, not observed hardware properties or product thresholds.

Track only approved synthetic inputs by default. Real vehicle trips, pairing/device identifiers, and reference tracks stay under ignored `harness/recordings/private/`. A transformed real route is not automatically anonymous or safe to commit.
