---
title: Budget Large Window
model: claude-opus-4-6
reasoning: low
effort: low
input: full_diff
---

SMOKE TEST — 900K context window (claude-opus-4-6).

The same PR that overflows the 155K variant should fit here: the diff should be
INLINED and the run should stay under the context gate.

Report in one sentence whether a diff was inlined in your prompt, and roughly how
many files it covered. Do not fetch the diff with git tools.

Conclude with state success.
