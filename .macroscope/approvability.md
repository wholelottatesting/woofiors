---
onlyApprove:
  - "only-approve-smoke/**"
  - "always-approve-smoke/**"
  - "smoke/scoped-local-17606/**"
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

{{ if eq .RepoName "woofiors" }}
For the isolated local-build smoke fixture under `smoke/scoped-local-17606/`,
evaluate only the final contents of records in the current scope. A record is
eligible for approval only when its `status:` line is exactly `status: ready`.
Any record with `status: blocked` must receive a failure decision, even when its
other changes are harmless. Explain the status found in the reviewed record.
The Ready and Blocked records are independent; do not propagate a Blocked
record's failure into a scope that includes only a Ready record.
{{ end }}
