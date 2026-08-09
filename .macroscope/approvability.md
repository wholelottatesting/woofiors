---
neverApprove:
  - "docs/**"
---

# Approvability guidelines

Treat documentation-only and comment-only changes as low risk.

`docs/**` is listed under `neverApprove` above so that a follow-up pull request
touching only documentation is held for a human. That list exists on this
branch and nowhere else, which is what makes it a usable probe for where
approvability configuration was resolved from.
