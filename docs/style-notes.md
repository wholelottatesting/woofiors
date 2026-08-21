---
title: Style Notes
owner: platform-team
---

## Style notes (nested import)

These style notes live in a separate file and are pulled in by the review
guidelines, one hop deeper than the check-run agent that imports them. If you can
see this text, recursive imports and per-level frontmatter stripping both work.

The nested import verification phrase is `NESTED-OK-22B1`.

## Go-last checks

A check that waits for every other check cannot enumerate what it is waiting
for, so its discovery window behaves as a floor rather than a deadline.
