#!/usr/bin/env bash
set -euo pipefail
umask 077

scenario=${1:?Supply one or two}
case "$scenario" in one|two) ;; *) exit 2 ;; esac
test -n "${SMOKE_RUN_ID:?The composite Action must return its durable run ID}"
mapfile -t results < <(find "$RUNNER_TEMP" -maxdepth 2 -type f -path "$RUNNER_TEMP/macroscope-result-$SMOKE_RUN_ID-*/result.json")
test "${#results[@]}" = 1
mkdir -p "$RUNNER_TEMP/scoped-local-evidence/$scenario"
cp "${results[0]}" "$RUNNER_TEMP/scoped-local-evidence/$scenario/result.json"
jq -e --arg run "$SMOKE_RUN_ID" --arg scenario "$scenario" '
  .schemaVersion == 2 and .runId == $run and .status == "succeeded"
  and .scopedReview.schemaVersion == 2
  and (.scopedReview.parentSummary | .publicationStatus == "confirmed" and .publishedConclusion == "neutral" and .checkRunId > 0)
  and (.scopedReview.scopes | length == (if $scenario == "two" then 2 else 1 end))
  and all(.scopedReview.scopes[]; .publicationStatus == "confirmed" and .checkRunId > 0 and .executionError == null and .publishedConclusion == .conclusion)
  and ([.scopedReview.scopes[] | select(.name == "Ready")] | length == 1)
  and all(.scopedReview.scopes[] | select(.name == "Ready");
    .conclusion == "success" or (.conclusion == "neutral" and (.explanation | contains("correctness"))))
  and (if $scenario == "two" then
    .verdict == "failure"
    and ([.scopedReview.scopes[] | select(.name == "Blocked")] | length == 1)
    and all(.scopedReview.scopes[] | select(.name == "Blocked"); .conclusion == "failure")
    else .verdict == .scopedReview.scopes[0].conclusion end)
' "${results[0]}"
jq '{runId,status,verdict,agentCredits,scopedReview}' "${results[0]}" > "$RUNNER_TEMP/scoped-local-evidence/$scenario/verification.json"
printf 'Verified %s-scope terminal result, confirmed scope publications, and neutral parent summary.\n' "$scenario"
