---
title: CRA Wait Smoke
model: claude-sonnet-4-6
reasoning: low
input: pr_metadata
include:
  - "only-approve-smoke/cra-wait/**"
requires:
  - "cra-wait-smoke-prerequisite"
waitsForTimeout: 20
waitsForDiscoveryTimeout: 5
---

This is a staging scheduling smoke test. Conclude success with the summary "CRA Wait Smoke completed after its prerequisite." Do not post review comments or change anything.
