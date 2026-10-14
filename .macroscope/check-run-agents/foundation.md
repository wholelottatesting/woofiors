---
title: 'Foundation V2 {{ .RepoName }}'
model: claude-sonnet-4-6
reasoning: low
effort: low
input: pr_metadata
include:
  - '{{ .RepoName }}/v2/**'
---
FOUNDATION-V2 CRA event={{ .RepoName }}.

@/policy/imported.md
