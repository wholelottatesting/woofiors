---
title: Disc Warnings
model: claude-sonnet-4-6
reasoning: low
effort: low
input: pr_metadata
requires:
  - "tp-pass"
waitsForTimeout: 10
waitsForDiscoveryTimeout: 99
---

PARSE WARNINGS. 99 is above the maximum, so it should clamp to 60 with a
warning carrying the discovery trade-off sentence. The clamped 60 then exceeds
waitsForTimeout (10), so a second warning should name the 10-minute cap.

Both warnings should be prepended to this check run's details page. The
prerequisite `tp-pass` is immediate, so the check itself should still RUN.

Always conclude with state success and the one-sentence summary
"Disc Warnings ran." Do not post any comments.
