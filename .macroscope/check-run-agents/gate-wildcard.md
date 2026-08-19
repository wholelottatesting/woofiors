---
title: Gate Wildcard Check
model: claude-sonnet-4-6
reasoning: low
effort: low
input: pr_metadata
waitsFor:
  - "*"
requires:
  - "Macroscope - Meta Hygiene Check"
---

Trivial test check for `waitsFor: ["*"]` combined with a named `requires`. Always
conclude with state success and the one-sentence summary "Gate Wildcard Check ran."
Do not post any comments.

If this skips with "not found", the wildcard was folded into the name list and the
gate looked for a check literally named `*`.
