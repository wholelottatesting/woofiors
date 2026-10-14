---
title: 'Foundation V1 {{ .RepoName }}'
model: claude-sonnet-4-6
reasoning: low
effort: low
input: pr_metadata
include:
  - '{{ .RepoName }}/v1/**'
---
FOUNDATION-V1 CRA event={{ .RepoName }}.

@/policy/imported.md
