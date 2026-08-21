---
title: Disc Wild Floor
model: claude-sonnet-4-6
reasoning: low
effort: low
input: pr_metadata
waitsFor:
  - "*"
waitsForDiscoveryTimeout: 6
---

WILDCARD FLOOR. Six-minute discovery window on a go-last CRA. The documented
behavior is that in wildcard mode the window is a FLOOR rather than a deadline,
so this should NOT finish when the other checks do (~3 minutes) — it should
wait out the full six minutes on every run.

If it finishes alongside Disc Wild Default, the window behaves as a deadline in
wildcard mode and the documentation is wrong. If it takes ~6 minutes, the floor
is real — and that is a latency cost a customer can set without realising it.

Conclude with state success and exactly the one-sentence summary
"Disc Wild Floor ran." Do not post any comments.
