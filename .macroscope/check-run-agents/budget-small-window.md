---
title: Budget Small Window
model: claude-opus-4-5
reasoning: low
effort: low
input: full_diff
---

SMOKE TEST — 155K context window (claude-opus-4-5).

On a PR whose diff exceeds this model's derived content budget, the diff should
be OMITTED and this check should still COMPLETE, not skip.

Report in one sentence whether a diff was inlined in your prompt. If it was not,
quote the sentence that told you so. Do not fetch the diff with git tools — the
point of this test is what the prompt contained, not what you can reconstruct.

Conclude with state success.
