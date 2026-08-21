---
title: Disc Configured Window
model: claude-sonnet-4-6
reasoning: low
effort: low
input: pr_metadata
requires:
  - "tp-late"
waitsForDiscoveryTimeout: 5
---

THE TEST. Same prerequisite as Disc Default Window, but with a five-minute
discovery window. `tp-late` appears at ~3 minutes, inside the window, so this
check should discover it, wait for it to pass, and RUN.

Compare against Disc Default Window on this same commit: same prerequisite,
same timing, different outcome. That difference is the feature.

Always conclude with state success and the one-sentence summary
"Disc Configured Window ran." Do not post any comments.
