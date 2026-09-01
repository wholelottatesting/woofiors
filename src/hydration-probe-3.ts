// Third push on this PR, for the post-#14960 conversation-hydration smoke test.
//
// Again a NEW file rather than an edit to src/bulk-comment-target.ts: the 60
// review comments now on this PR are anchored to lines 1-30 of that file, and
// editing it would mark those threads outdated and change what the conversation
// block is assembled from. A new file yields a fresh head SHA while leaving all
// 60 threads live, which is the point of this run — the check should now receive
// all 60 of its own prior comments, at the shared hard ceiling.
export const HYDRATION_PROBE_3 = "cra-conversation-hydration-postfix";
export const HYDRATION_PUSH_3 = 3;
export function hydrationProbe3Label(): string {
  return `${HYDRATION_PROBE_3}#${HYDRATION_PUSH_3}`;
}
