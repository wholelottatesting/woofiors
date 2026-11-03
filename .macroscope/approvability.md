---
onlyApprove:
  - "only-approve-smoke/**"
  - "always-approve-smoke/**"
alwaysApprove:
  - "always-approve-smoke/**"
---

Approve pull requests that are routine and low risk.

Policy repository: {{ .RepoName }}. Policy scope: {{ .ScopeName }}.

{{ if eq .ScopeName "Amber" }}
AMBER_POLICY: Check that the currency formatter change is documentation-only and preserves executable behavior. Routine spelling corrections can be approved.
{{ else if eq .ScopeName "Birch" }}
BIRCH_POLICY: Subscription prices are consequential customer-facing decisions. Withhold approval of a changed price unless explicit business authorization and customer-impact evidence are present. A correct implementation alone is insufficient.
{{ else if eq .ScopeName "Cobalt" }}
COBALT_POLICY: Check that the receipt label documentation change preserves its runtime value. Routine comment-only spelling corrections can be approved.
{{ else }}
ORDINARY_POLICY: Approve only routine and low-risk changes. Consequential subscription price changes require human review.
{{ end }}
