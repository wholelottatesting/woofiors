---
title: Gate TP Fail Check
model: claude-sonnet-4-6
reasoning: low
effort: low
input: pr_metadata
requires:
  - "tp-fail"
---

Trivial test check gating on a third-party GitHub Actions job that fails. Always
conclude with state success and the one-sentence summary "Gate TP Fail Check ran."
Do not post any comments.
