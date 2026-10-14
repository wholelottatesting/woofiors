---
conclusion: '{{ if eq .RepoName "foundation-alpha" }}failure{{ else }}neutral{{ end }}'
alwaysApprove:
  - '{{ .RepoName }}/v2/**'
---
FOUNDATION-V2 approvability event={{ .RepoName }}.
