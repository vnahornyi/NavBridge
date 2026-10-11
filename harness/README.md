# NavBridge harness

This directory establishes tracked conventions for the future deterministic test harness. There is no executable runner or completed dataset yet. Implementation belongs to NB-007 after NB-002 establishes the shared Swift core.

- [Design and scenario catalog](../docs/testing/harness.md)
- [Fixture conventions](fixtures/README.md)
- [Scenario conventions](scenarios/README.md)
- [Report conventions](reports/README.md)

Production and replay must use the same native estimator and session decisions. Replay never starts VPN/BLE or sends real system locations. Private recordings go to `recordings/private/` and raw reports to `reports/local/`; both are ignored. Do not create fake passing reports or placeholders that appear executable.
