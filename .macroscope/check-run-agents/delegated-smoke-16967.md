---
title: Delegated CRA Smoke 16967
model: claude-sonnet-4-6
reasoning: low
effort: low
input: pr_metadata
include:
  - "smoke/delegated-cra-16967.txt"
---

This is a smoke test of inherited CRA configuration. Do not review code or post comments.

{{ if eq .RepoName "co-webhook-test-aw" }}
The repository template marker is TEMPLATE_EVENT_REPO_16967_OK.
{{ else }}
The repository template marker is TEMPLATE_WRONG_REPO_16967_FAIL.
{{ end }}

@/smoke/delegated-cra-guidance-16967.md

Conclude with state success. In your summary, report the repository template marker and the import source marker present above. Report any missing marker explicitly.
