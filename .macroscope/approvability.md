---
conclusion: failure
waitsFor:
  - "Scoped Regression Prerequisite"
onlyApprove:
  - "only-approve-smoke/**"
  - "always-approve-smoke/**"
alwaysApprove:
  - "always-approve-smoke/**"
---

Approve pull requests that are routine and low risk.

For changes to `only-approve-smoke/foundations.txt`, a successful
`Scoped Regression Prerequisite` check is a mandatory condition of approval.
If that check fails, the pull request is not approvable and requires human
review, even if the changed file is otherwise routine and low risk.

Policy smoke marker: {{ .RepoName }}

{{ if eq .RepoName "co-webhook-test-aw" }}
Policy conditional smoke: matched co-webhook-test-aw.
{{ else }}
Policy conditional smoke: unexpected repository {{ .RepoName }}.
{{ end }}
