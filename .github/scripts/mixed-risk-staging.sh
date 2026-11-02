#!/usr/bin/env bash
set -euo pipefail
umask 077
scenario=${1:?Specify a bounded scenario}
evidence="$RUNNER_TEMP/mixed-risk-evidence"
mkdir -p "$evidence"
github_state() {
  gh api "repos/wholelottatesting/woofiors/pulls/$SMOKE_PR/reviews" --jq '[.[]|{id,state,commit_id,submitted_at,user:.user.login}]' > "$evidence/reviews-$1.json"
  gh api --paginate --slurp "repos/wholelottatesting/woofiors/commits/$SMOKE_HEAD/check-runs?filter=all&per_page=100" | jq '[.[].check_runs[]|{id,node_id,name,status,conclusion,external_id,started_at,completed_at,app_id:.app.id,title:.output.title,summary:.output.summary}]' > "$evidence/checks-$1.json"
}
case "$scenario" in
  prerequisite)
    curl --silent --show-error --fail --connect-timeout 10 --max-time 20 "$SMOKE_API/ready"
    curl --silent --show-error --fail --max-time 20 "$SMOKE_API/" > "$evidence/webhook-before.json"
    curl --silent --show-error --fail --max-time 20 https://primary.lb.billing.staging.back.nonprod.prasso.ai/ > "$evidence/billing-before.json"
    jq -n --arg api "$SMOKE_API" --arg head "$SMOKE_HEAD" --arg base "$SMOKE_BASE" --arg pr "$SMOKE_PR" --arg run "$GITHUB_RUN_ID" --arg source 949ac7ad24a9348dc35c852dab22e88a8cc8b742 '{api:$api,head:$head,base:$base,pullRequest:$pr,actionsRun:$run,actionSource:$source,execution:"deployed-staging-not-loopback",analysis:"parent"}' > "$evidence/context.json"
    for attempt in {1..144}; do
      if (( attempt % 12 == 1 )); then
        printf 'Awaiting native prerequisites (%d/144).\n' "$attempt"
      fi
      github_state prerequisite
      if jq -e 'any(.[]; .name=="Macroscope - Correctness Check" and .status=="completed" and .conclusion=="success") and any(.[]; .name=="Macroscope - Approvability Check" and .status=="completed") and any(.[]; .name=="correctness-prerequisite" and .status=="completed" and .conclusion=="success")' "$evidence/checks-prerequisite.json" >/dev/null; then
        exit 0
      fi
      sleep 5
    done
    echo '::error::Clean native correctness and settled prerequisite checks were not observed within twelve minutes.'
    exit 1
    ;;
  collect)
    mkdir -p "$evidence/results" "$evidence/summaries"
    while IFS= read -r -d '' result; do
      cp "$result" "$evidence/results/$(basename "$(dirname "$result")").json"
    done < <(find "$RUNNER_TEMP" -path '*/macroscope-result-*/result.json' -print0)
    while IFS= read -r -d '' summary; do
      if grep -q '^## Macroscope result$' "$summary"; then
        cp "$summary" "$evidence/summaries/$(basename "$summary").md"
      fi
    done < <(find "$RUNNER_TEMP/_runner_file_commands" -name 'step_summary_*' -print0)
    github_state final
    curl --silent --show-error --fail --max-time 20 "$SMOKE_API/" > "$evidence/webhook-after.json"
    curl --silent --show-error --fail --max-time 20 https://primary.lb.billing.staging.back.nonprod.prasso.ai/ > "$evidence/billing-after.json"
    exit 0
    ;;
  scoped) ;;
  *) exit 1 ;;
esac
source macroscope-actions/run/run.sh
IN_API_URL=$SMOKE_API
IN_REPOSITORY=wholelottatesting/woofiors
IN_REVIEW=approvability
IN_COMMIT=$SMOKE_HEAD
IN_BASE=$SMOKE_BASE
IN_PULL_REQUEST=$SMOKE_PR
IN_TIMEOUT=600
IN_POLL_INTERVAL=5
IN_ACTION_VERSION=v1
IN_FAIL_ON=never
IN_SCOPES='[{"name":"CommentOnly","checkName":"Staging Mixed Risk - Comment","analysis":"parent","files":["only-approve-smoke/mixed-risk/format.ts"]},{"name":"SubscriptionPricing","checkName":"Staging Mixed Risk - Pricing","analysis":"parent","files":["only-approve-smoke/mixed-risk/subscription.ts"]}]'
GITHUB_ACTION=deployed-staging-mixed-risk
github_state before-scoped
run_action
cp "$RUN_ACTION_TMP/poll.json" "$evidence/scoped-terminal.json"
github_state after-scoped
jq -e '.status=="succeeded" and .verdict=="neutral" and (.scopedReview.scopes|length==2) and any(.scopedReview.scopes[]; .name=="CommentOnly" and .analysis=="parent" and .conclusion=="success" and .publicationStatus=="confirmed" and .publishedConclusion=="success") and any(.scopedReview.scopes[]; .name=="SubscriptionPricing" and .analysis=="parent" and .conclusion=="neutral" and .publicationStatus=="confirmed" and .publishedConclusion=="neutral") and (.scopedReview.parentSummary|.publicationStatus=="confirmed" and .publishedConclusion=="neutral")' "$evidence/scoped-terminal.json" >/dev/null
jq -e -s '(.[0]|map(.id)|sort)==(.[1]|map(.id)|sort)' "$evidence/reviews-before-scoped.json" "$evidence/reviews-after-scoped.json" >/dev/null
