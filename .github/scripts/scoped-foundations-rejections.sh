#!/usr/bin/env bash
set -euo pipefail
mkdir -p smoke-evidence
oidc_response=$(curl --fail --silent --show-error -H "Authorization: Bearer $ACTIONS_ID_TOKEN_REQUEST_TOKEN" "${ACTIONS_ID_TOKEN_REQUEST_URL}&audience=macroscope")
oidc_token=$(jq -er .value <<<"$oidc_response")
echo "::add-mask::$oidc_token"
auth_config="$RUNNER_TEMP/scoped-smoke-auth.config"
umask 077
printf 'header = "Authorization: Bearer %s"\nheader = "Content-Type: application/json"\nheader = "X-Macroscope-Action-Version: v1"\n' "$oidc_token" > "$auth_config"
trap 'rm -f "$auth_config"' EXIT
gh api "repos/$GITHUB_REPOSITORY/commits/$SMOKE_COMMIT/check-runs?per_page=100" > smoke-evidence/checks-before.json
gh api "repos/$GITHUB_REPOSITORY/pulls/$SMOKE_PR/reviews?per_page=100" > smoke-evidence/reviews-before.json
for variant in nonempty empty null; do
  case "$variant" in
    nonempty) scopes='[{"name":"smoke","checkName":"Unexpected scoped smoke","files":["always-approve-smoke/foundations.txt"]}]'; expected=422 ;;
    empty) scopes='[]'; expected=422 ;;
    null) scopes='null'; expected=400 ;;
  esac
  jq -n --arg repository "$GITHUB_REPOSITORY" --arg commit "$SMOKE_COMMIT" --arg base "$SMOKE_BASE" --argjson pullRequest "$SMOKE_PR" --argjson scopes "$scopes" --arg discriminator "rejection-$variant" '{repository:$repository,review:{kind:"cra"},agent:"Foundations Smoke CRA",commit:$commit,base:$base,pullRequest:$pullRequest,scopes:$scopes,idempotencyDiscriminator:$discriminator}' > "smoke-evidence/request-$variant.json"
  status=$(curl --silent --show-error --max-time 60 --config "$auth_config" --data-binary "@smoke-evidence/request-$variant.json" -o "smoke-evidence/response-$variant.json" -w '%{http_code}' https://primary.lb.webhook.staging.back.nonprod.prasso.ai/api/v1/github-actions/agent-runs)
  jq -n --arg variant "$variant" --arg status "$status" --arg expected "$expected" '{variant:$variant,status:$status,expected:$expected}' | tee "smoke-evidence/status-$variant.json"
  cat "smoke-evidence/response-$variant.json"
  test "$status" = "$expected"
  jq -e 'has("runId") | not' "smoke-evidence/response-$variant.json"
  if test "$variant" = null; then
    grep -q 'scopes must be an array' "smoke-evidence/response-$variant.json"
  else
    grep -q 'scoped reviews through GitHub Actions are not available yet' "smoke-evidence/response-$variant.json"
  fi
done
sleep 15
gh api "repos/$GITHUB_REPOSITORY/commits/$SMOKE_COMMIT/check-runs?per_page=100" > smoke-evidence/checks-after-rejections.json
gh api "repos/$GITHUB_REPOSITORY/pulls/$SMOKE_PR/reviews?per_page=100" > smoke-evidence/reviews-after-rejections.json
jq -s -e '(.[0].check_runs | map(.id) | sort) == (.[1].check_runs | map(.id) | sort)' smoke-evidence/checks-before.json smoke-evidence/checks-after-rejections.json
jq -s -e '(.[0] | map(.id) | sort) == (.[1] | map(.id) | sort)' smoke-evidence/reviews-before.json smoke-evidence/reviews-after-rejections.json
