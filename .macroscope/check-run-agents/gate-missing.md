---
title: Gate Missing Check
model: claude-sonnet-4-6
reasoning: low
effort: low
input: pr_metadata
requires:
  - "Nonexistent CI Check ZZZ"
---

Trivial test check for the `requires` fail-closed path. Always conclude with state
success and the one-sentence summary "Gate Missing Check ran." Do not post any comments.

If you are reading this, the gate did NOT fail closed on a prerequisite that never appears.
