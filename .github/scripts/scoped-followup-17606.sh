#!/usr/bin/env bash
set -euo pipefail
umask 077

source /home/murmur/workspace/back/macroscope-actions/run/run.sh
scenario=${1:?Specify success or freshness}
private=$(mktemp -d "$RUNNER_TEMP/followup-auth.XXXXXXXX")
trap 'rm -r -- "$private"' EXIT
evidence="$RUNNER_TEMP/scoped-followup-evidence"
mkdir -p "$evidence"
IN_API_URL=https://127.0.0.1:18443
IN_REPOSITORY=wholelottatesting/woofiors
IN_REVIEW=approvability
IN_COMMIT=$SMOKE_HEAD
IN_BASE=$SMOKE_BASE
IN_PULL_REQUEST=$SMOKE_PR
IN_TIMEOUT=900
IN_POLL_INTERVAL=5
IN_ACTION_VERSION=v1
IN_FAIL_ON=never
IN_SCOPES=$(jq -nc --arg scenario "$scenario" '[{name:"Ready",checkName:("Bounded 17606 " + $scenario + " Ready"),analysis:"parent",files:["smoke/scoped-followup-17606/ready.txt"]}]')
validate_run_inputs
deadline=$((SECONDS + IN_TIMEOUT))
oidc=$(mint_oidc_token "$private/oidc.json" "$private/oidc.headers" "$private/oidc.config" "$deadline")
payload=$(start_payload)
start_run "$oidc" "$payload" "$private/start.json" "$private/start.headers" "$private/start.config" "$deadline"
run_id=$(jq -r .runId "$private/start.json")
token=$(jq -r .jobToken "$private/start.json")
write_auth_config "$private/poll.config" "$token" "$IN_ACTION_VERSION"
poll_request_or_retry "${IN_API_URL}/api/v1/github-actions/agent-runs/${run_id}" "$private/initial.json" "$private/initial.headers" "$private/poll.config" "$deadline"
test "$HTTP_STATUS" = 202

if [[ "$scenario" == success ]]; then
  start_run "$oidc" "$payload" "$private/rejoin.json" "$private/rejoin.headers" "$private/rejoin.config" "$deadline"
  test "$(jq -r .runId "$private/rejoin.json")" = "$run_id"
  jq -n --arg run "$run_id" '{runId:$run,inFlightRejoinSameRun:true}' > "$evidence/rejoin.json"
elif [[ "$scenario" == freshness ]]; then
  jq -n --arg run "$run_id" --arg head "$SMOKE_HEAD" '{runId:$run,head:$head}' > /home/murmur/workspace/scoped-e2e-verification/followup-runner/signals/freshness-start.json
else
  echo 'Unknown smoke scenario' >&2
  exit 1
fi

poll_run "$run_id" "$token" "$private/poll.json" "$private/poll.headers" "$private/poll.config" "$deadline"
cp "$private/poll.json" "$evidence/${scenario}.json"
emit_terminal_outputs "$private/poll.json" "$run_id"
if [[ "$scenario" == success ]]; then
  jq -e '.status == "succeeded" and .verdict == "success" and (.scopedReview.scopes | length == 1) and (.scopedReview.scopes[0] | .conclusion == "success" and .publicationStatus == "confirmed" and .publishedConclusion == "success")' "$private/poll.json" >/dev/null
  start_run "$oidc" "$payload" "$private/replay.json" "$private/replay.headers" "$private/replay.config" "$deadline"
  test "$(jq -r .runId "$private/replay.json")" = "$run_id"
  jq '. + {terminalReplaySameRun:true}' "$evidence/rejoin.json" > "$private/rejoin-safe.json"
  cp "$private/rejoin-safe.json" "$evidence/rejoin.json"
else
  jq -e '(.status == "cancelled" or .status == "failed") and (.scopedReview.scopes | length == 1)' "$private/poll.json" >/dev/null
fi
printf 'PASS: %s run %s\n' "$scenario" "$run_id"
