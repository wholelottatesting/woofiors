---
title: Disc Never Appears
model: claude-sonnet-4-6
reasoning: low
effort: low
input: pr_metadata
requires:
  - "Nonexistent Late Check ZZZ"
waitsForDiscoveryTimeout: 3
---

NEGATIVE PATH. The prerequisite never exists, so this must still conclude
SKIPPED with "Prerequisite check(s) not found" — but only after roughly three
minutes, not sixty seconds. The elapsed time is the evidence that the
configured window is honored rather than ignored on the failing path.

Always conclude with state success and the one-sentence summary
"Disc Never Appears ran." Do not post any comments.
