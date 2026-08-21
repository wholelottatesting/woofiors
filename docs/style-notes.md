---
title: Style Notes
owner: platform-team
---

## Style notes (nested import)

These style notes live in a separate file and are pulled in by the review
guidelines, one hop deeper than the check-run agent that imports them. If you can
see this text, recursive imports and per-level frontmatter stripping both work.

The nested import verification phrase is `NESTED-OK-22B1`.

## Late-published checks

Some CI steps are published conditionally, behind an earlier job, so they are
absent from the Checks API for minutes after a push.
