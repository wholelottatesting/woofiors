---
title: CRA Workspace Cost Limit Smoke
model: claude-sonnet-4-6
reasoning: low
effort: low
input: pr_metadata
tools:
  - github_api_read_only
maxBudgetPerRun: 2
---

You are running a mechanical cost-limit smoke test. Do not review code, post
comments, or modify the pull request.

Call the read-only GitHub API tool exactly 20 times, sequentially. Every call
must read `README.md` from `wholelottatesting/woofiors`. Observe each result
before making the next call. Do not quote or reproduce the file contents.

After all 20 calls, conclude with state success, title
`CRA workspace cost smoke complete`, and the one-sentence summary
`Completed 20 read-only calls for the workspace cost-limit smoke test.`
