# Always-approve smoke

`.macroscope/approvability.md` lists `always-approve-smoke/**` under
`alwaysApprove`. This directory is the fixture that glob points at: a place to
put small, routine, zero-risk changes whose pull requests should be approved
without a judgement call.

Nothing here is product code, and nothing here is imported by `src/`. A change
confined to this directory cannot affect the build, so "approve it" is always
the correct answer — which is what makes it a usable smoke test for the
auto-approval path.
