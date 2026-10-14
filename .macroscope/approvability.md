---
conclusion: '{{ if eq .RepoName "foundation-alpha" }}failure{{ else }}neutral{{ end }}'
alwaysApprove:
  - '{{ .RepoName }}/v1/**'
---
FOUNDATION-V1 approvability event={{ .RepoName }}.
