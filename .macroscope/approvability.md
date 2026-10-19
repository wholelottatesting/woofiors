---
waitsFor:
  - "smoke-17084-build"
  - "smoke-17084-integration"
  - "smoke-17084-lint"
  - "smoke-17084-security"
waitsForTimeout: 2
waitsForDiscoveryTimeout: 1
onlyApprove:
  - "only-approve-smoke/**"
  - "always-approve-smoke/**"
alwaysApprove:
  - "always-approve-smoke/**"
---

Approve routine documentation-only pull requests unless one of the following rules applies.

CI completion and CI outcomes are informational, not conditions of approval.
Documentation under only-approve-smoke/human-review-17084/ requires maintainer sign-off and therefore requires human approval independently of CI.
