---
onlyApprove:
  - "only-approve-smoke/**"
  - "always-approve-smoke/**"
  - "smoke/scoped-followup-17606/**"
alwaysApprove:
  - "always-approve-smoke/**"
---

Approve pull requests that are routine and low risk.

For the disposable smoke fixture under `smoke/scoped-followup-17606/`, approve
routine record changes when the final record has `status: ready`. Reject a
record with `status: blocked`. Do not post PR reviews or modify repository files.

Policy smoke marker: {{ .RepoName }}

{{ if eq .RepoName "co-webhook-test-aw" }}
Policy conditional smoke: matched co-webhook-test-aw.
{{ else }}
Policy conditional smoke: unexpected repository {{ .RepoName }}.
{{ end }}
