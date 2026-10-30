---
conclusion: failure
waitsFor:
  - "Scoped Regression Prerequisite"
neverApprove:
  - "only-approve-smoke/foundations.txt"
onlyApprove:
  - "only-approve-smoke/**"
  - "always-approve-smoke/**"
alwaysApprove:
  - "always-approve-smoke/**"
---

Approve pull requests that are routine and low risk.

Policy smoke marker: {{ .RepoName }}

{{ if eq .RepoName "co-webhook-test-aw" }}
Policy conditional smoke: matched co-webhook-test-aw.
{{ else }}
Policy conditional smoke: unexpected repository {{ .RepoName }}.
{{ end }}
