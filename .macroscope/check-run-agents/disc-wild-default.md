---
title: Disc Wild Default
model: claude-sonnet-4-6
reasoning: low
effort: low
input: pr_metadata
waitsFor:
  - "*"
---

WILDCARD BASELINE. No discovery override, so the 60-second floor applies. In
wildcard mode the executor cannot enumerate what it waits for, so it waits for
every other check on the commit — here bounded by the ~3 minute conditional
job, not by the floor.

Compare its elapsed time against Disc Wild Floor on the same commit.

Conclude with state success and exactly the one-sentence summary
"Disc Wild Default ran." Do not post any comments.
