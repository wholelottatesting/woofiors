// Second push on this PR, added for the #14915 conversation-hydration smoke test.
//
// This is a NEW file rather than an edit to src/bulk-comment-target.ts on
// purpose. The 30 review comments already on this PR are anchored to lines
// 1-30 of that file; editing it would mark those threads outdated and change
// what the conversation block is built from. Adding a separate file leaves all
// 30 threads live while still producing a fresh head SHA, and the PR diff
// still contains bulk-comment-target.ts, so the check's include filter (which
// runs against the whole PR diff, not just the newest commit) still matches.
export const HYDRATION_PROBE = "cra-conversation-hydration";
export const HYDRATION_PUSH = 2;
export function hydrationProbeLabel(): string {
  return `${HYDRATION_PROBE}#${HYDRATION_PUSH}`;
}
