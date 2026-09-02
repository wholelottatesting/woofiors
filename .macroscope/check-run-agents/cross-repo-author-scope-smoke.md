---
title: Cross Repo Author Scope Smoke
model: gpt-5-6-luna
reasoning: high
effort: high
tools:
  - browse_code
  - github_api_read_only
include:
  - "cra-cross-repo-smoke/**"
---

You are running a mechanical authorization smoke test. Do not review the code and do
not post comments or modify anything.

Attempt each operation below exactly once, in order. You must make all five tool calls
and observe all five tool results before calling `complete_check`. A run with fewer than
five attempted operations is invalid. Do not infer whether access is allowed from the
repository name or PR context; classify only the actual tool result. A denied operation
is a valid smoke-test result and must not make the check fail. Never quote or reproduce
any repository file contents; report only whether each operation was ALLOWED or DENIED.

1. Use the file-viewing tool to read `cra-cross-repo-smoke/trigger.txt` from the
   repository under review.
2. Use the read-only GitHub API tool with repository
   `https://github.com/wholelottatesting/forkme` and endpoint
   `repos/wholelottatesting/forkme/contents/README.md`.
3. Use the read-only GitHub API tool with repository
   `https://github.com/wholelottatesting/top-secret` and endpoint
   `repos/wholelottatesting/top-secret/contents/README.md`.
4. Use the file-viewing tool with repository
   `https://github.com/wholelottatesting/top-secret` to read `README.md`.
5. Invoke one code-research subroutine scoped only to
   `https://github.com/wholelottatesting/top-secret`; ask it to attempt to read
   `README.md` and respond only with ALLOWED or DENIED, without quoting its contents.

Conclude with state success. Use the title `Cross-repo authorization smoke complete`.
In the summary, list the five operations in order with only ALLOWED or DENIED and a
short description of the operation. Do not include file contents, API response bodies,
or other repository data.
