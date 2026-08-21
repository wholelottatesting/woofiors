---
title: Disc Default Window
model: claude-sonnet-4-6
reasoning: low
effort: low
input: pr_metadata
requires:
  - "tp-late"
---

CONTROL for waitsForDiscoveryTimeout. No override, so the default 60-second
discovery window applies. `tp-late` is published conditionally behind a
three-minute job, so it should NOT be discovered in time and this check should
conclude SKIPPED with "Prerequisite check(s) not found".

If this check actually RUNS, the default window is no longer 60 seconds.

Always conclude with state success and the one-sentence summary
"Disc Default Window ran." Do not post any comments.
