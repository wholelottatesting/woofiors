#!/usr/bin/env bash
set -euo pipefail
umask 077
scenario=${1:?Specify a bounded scenario}
evidence="$RUNNER_TEMP/deployed-staging-evidence"
mkdir -p "$evidence"
github_state() {
  gh api "repos/wholelottatesting/woofiors/pulls/$SMOKE_PR/reviews" --jq '[.[]|{id,state,commit_id,submitted_at,user:.user.login}]' > "$evidence/reviews-$1.json"
  gh api --paginate --slurp "repos/wholelottatesting/woofiors/commits/$SMOKE_HEAD/check-runs?filter=all&per_page=100" --jq '[.[].check_runs[]|{id,node_id,name,status,conclusion,external_id,started_at,completed_at,app_id:.app.id,title:.output.title,summary:.output.summary}]' > "$evidence/checks-$1.json"
}
case "$scenario" in
  prerequisite)
    curl --silent --show-error --fail --connect-timeout 10 --max-time 20 "$SMOKE_API/ready"
    curl --silent --show-error --fail --max-time 20 "$SMOKE_API/" > "$evidence/webhook-before.json"
    curl --silent --show-error --fail --max-time 20 https://primary.lb.billing.staging.back.nonprod.prasso.ai/ > "$evidence/billing-before.json"
    jq -n --arg api "$SMOKE_API" --arg head "$SMOKE_HEAD" --arg base "$SMOKE_BASE" --arg pr "$SMOKE_PR" --arg run "$GITHUB_RUN_ID" --arg source 949ac7ad24a9348dc35c852dab22e88a8cc8b742 '{api:$api,head:$head,base:$base,pullRequest:$pr,actionsRun:$run,actionSource:$source,execution:"deployed-staging-not-loopback"}' > "$evidence/context.json"
    for attempt in {1..96}; do
      github_state prerequisite
      if jq -e 'any(.[]; .name=="Macroscope - Correctness Check" and .status=="completed" and .conclusion=="success")' "$evidence/checks-prerequisite.json" >/dev/null; then
        exit 0
      fi
      sleep 5
    done
    echo '::error::No successful native correctness prerequisite was observed within eight minutes.'
    exit 1
    ;;
  collect)
    github_state final
    curl --silent --show-error --fail --max-time 20 "$SMOKE_API/" > "$evidence/webhook-after.json"
    curl --silent --show-error --fail --max-time 20 https://primary.lb.billing.staging.back.nonprod.prasso.ai/ > "$evidence/billing-after.json"
    mkdir -p "$evidence/results" "$evidence/summaries"
    while IFS= read -r -d '' result; do
      cp "$result" "$evidence/results/$(basename "$(dirname "$result")").json"
    done < <(find "$RUNNER_TEMP" -path '*/macroscope-result-*/result.json' -print0)
    while IFS= read -r -d '' summary; do
      if grep -q '^## Macroscope result$' "$summary"; then
        cp "$summary" "$evidence/summaries/$(basename "$summary").md"
      fi
    done < <(find "$RUNNER_TEMP/_runner_file_commands" -name 'step_summary_*' -print0)
    exit 0
    ;;
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
GITHUB_ACTION="deployed-staging-$scenario"
case "$scenario" in
  scoped)
    github_state before-scoped
    IN_SCOPES='[{"name":"ReadyA","checkName":"Staging 17606 Ready A","analysis":"parent","files":["only-approve-smoke/staging-17606-a.txt"]},{"name":"ReadyB","checkName":"Staging 17606 Ready B","analysis":"parent","files":["only-approve-smoke/staging-17606-b.txt"]}]'
    validate_run_inputs
    private=$(mktemp -d "$RUNNER_TEMP/staging-auth.XXXXXXXX")
    trap 'rm -rf -- "$private"' EXIT
    deadline=$((SECONDS + IN_TIMEOUT))
    oidc=$(mint_oidc_token "$private/oidc.json" "$private/oidc.headers" "$private/oidc.config" "$deadline")
    payload=$(start_payload)
    start_run "$oidc" "$payload" "$private/start.json" "$private/start.headers" "$private/start.config" "$deadline"
    run_id=$(jq -r .runId "$private/start.json")
    token=$(jq -r .jobToken "$private/start.json")
    jq -n --arg run "$run_id" '{runId:$run}' > "$evidence/scoped-admitted.json"
    start_run "$oidc" "$payload" "$private/rejoin.json" "$private/rejoin.headers" "$private/rejoin.config" "$deadline"
    test "$(jq -r .runId "$private/rejoin.json")" = "$run_id"
    poll_run "$run_id" "$token" "$private/poll.json" "$private/poll.headers" "$private/poll.config" "$deadline"
    for attempt in {1..20}; do
      if jq -e 'all(.scopedReview.scopes[]; .publicationStatus=="confirmed") and .scopedReview.parentSummary.publicationStatus=="confirmed"' "$private/poll.json" >/dev/null; then
        break
      fi
      sleep 2
      poll_run "$run_id" "$token" "$private/poll.json" "$private/poll.headers" "$private/poll.config" "$deadline"
    done
    cp "$private/poll.json" "$evidence/scoped-terminal.json"
    emit_terminal_outputs "$private/poll.json" "$run_id"
    jq -e '.status=="succeeded" and .verdict=="success" and (.scopedReview.scopes|length==2) and all(.scopedReview.scopes[]; .conclusion=="success" and .publicationStatus=="confirmed" and .publishedConclusion=="success") and (.scopedReview.parentSummary|.publicationStatus=="confirmed" and .publishedConclusion=="neutral")' "$private/poll.json" >/dev/null
    github_state before-replay
    oidc=$(mint_oidc_token "$private/replay-oidc.json" "$private/replay-oidc.headers" "$private/replay-oidc.config" "$deadline")
    start_run "$oidc" "$payload" "$private/replay.json" "$private/replay.headers" "$private/replay.config" "$deadline"
    test "$(jq -r .runId "$private/replay.json")" = "$run_id"
    replay_token=$(jq -r .jobToken "$private/replay.json")
    poll_run "$run_id" "$replay_token" "$private/replay-poll.json" "$private/replay-poll.headers" "$private/replay-poll.config" "$deadline"
    cp "$private/replay-poll.json" "$evidence/scoped-replayed.json"
    github_state after-scoped
    jq -e -s '.[0]==.[1]' "$evidence/reviews-before-scoped.json" "$evidence/reviews-after-scoped.json" >/dev/null
    jq -e -s 'map(map(select(.external_id//""|startswith("macroscope-actions:")))|sort_by(.id))|.[0]==.[1]' "$evidence/checks-before-replay.json" "$evidence/checks-after-scoped.json" >/dev/null
    jq -n --arg run "$run_id" '{runId:$run,inFlightRejoinSameRun:true,terminalReplaySameRun:true,noAdditionalPRReview:true,remoteChecksUnchangedByReplay:true}' > "$evidence/replay-assertions.json"
    ;;
  ordinary)
    run_action
    cp "$RUN_ACTION_TMP/poll.json" "$evidence/ordinary-terminal.json"
    jq -e '.status=="succeeded" and .verdict=="success"' "$RUN_ACTION_TMP/poll.json" >/dev/null
    github_state after-ordinary
    ;;
  cra)
    IN_REVIEW=cra
    IN_AGENT='Deployed staging 17606'
    IN_TIMEOUT=300
    run_action
    cp "$RUN_ACTION_TMP/poll.json" "$evidence/cra-terminal.json"
    jq -e '.status=="succeeded" and .verdict=="success"' "$RUN_ACTION_TMP/poll.json" >/dev/null
    github_state after-cra
    ;;
  *)
    echo 'Unknown bounded scenario' >&2
    exit 1
    ;;
esac
