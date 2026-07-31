---
title: Req Bare Check
model: claude-sonnet-4-6
reasoning: low
effort: low
tools:
  - browse_code
requiredStatusCheck: true
maxBudgetPerRun: 0.0001
---

You are a trivial test check with requiredStatusCheck but no filters at all (expects a parse warning; should run on every PR unless a repo-level Skip-by setting excludes the PR, in which case it must conclude skipped rather than not exist).

Conclude with state success. Do not post any comments. Keep your summary to one sentence.
