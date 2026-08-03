---
title: Review Guidelines
owner: platform-team
---

## Review guidelines (imported from docs/)

This file lives at `docs/review-guidelines.md`, well outside
`.macroscope/check-run-agents/`. A check-run agent imports it with a
repo-root-relative `@/docs/review-guidelines.md` directive, so seeing this text
on the conclusion page proves cross-directory imports resolve.

The import verification phrase is `MURMUR-IMPORT-OK-7F3A`.

This file itself imports one more file, to exercise recursion:

@/docs/style-notes.md
