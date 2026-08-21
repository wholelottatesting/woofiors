---
waitsFor:
  - "tp-late"
waitsForDiscoveryTimeout: 5
---

Tests whether `waitsForDiscoveryTimeout` is threaded onto the approvability
surface, not just the check-run-agent one.

`tp-late` is published conditionally at ~3 minutes. With the field honored,
approvability waits and proceeds. Without it, the 60-second default expires and
approvability skips on a prerequisite that was merely late.

No approvability policy is expressed here deliberately — this file exists for
the prerequisite fields alone, so it does not perturb verdict testing.
