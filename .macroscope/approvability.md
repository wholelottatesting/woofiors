---
waitsFor:
  - "smoke-17001-missing"
waitsForTimeout: 2
waitsForDiscoveryTimeout: 1
onlyApprove:
  - "only-approve-smoke/**"
  - "always-approve-smoke/**"
alwaysApprove:
  - "always-approve-smoke/**"
---

Approve routine documentation-only pull requests unless one of the following rules applies.

- Require human approval if a check explicitly named in waitsFor is unfinished, missing, or failed according to the supplied check observations.
- Documentation under only-approve-smoke/human-review-17001/ requires maintainer sign-off and therefore requires human approval, independently of CI.
