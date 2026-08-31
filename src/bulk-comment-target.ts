// Fixture for the "Bulk 30 Comments Check" check run agent smoke test.
// This file is added whole by the trigger PR, so every one of its 30
// lines is an added line on the RIGHT side of the diff. That matters:
// the review tool falls back to a file-level comment when a line lands
// outside the diff hunk, and a file-level comment carries no line
// anchor to order by. Keeping all 30 lines addable pins comment N to
// line N, which is what makes the ordering verifiable at a glance.
//
// The code below is deliberately inert and obviously correct so the
// built-in Correctness check finds nothing to report. Every review
// comment on this PR should be one of the 30 numbered ones.
export const SMOKE_NAME = "bulk-30-comments";
export const SMOKE_EXPECTED_COMMENTS = 30;
export const SMOKE_ANCHOR_FILE = "src/bulk-comment-target.ts";
export const SMOKE_TEAM = "woofiors";
export const SMOKE_SEASON = 2026;
export const SMOKE_COLORS: readonly string[] = ["blue", "gold"];
export const SMOKE_VENUE = "Testing Arena";
export const SMOKE_TIMEZONE = "America/Los_Angeles";
export const SMOKE_ENABLED = true;
export function smokeLabel(): string {
  return `${SMOKE_NAME}/${SMOKE_SEASON}`;
}
export function smokeExpectedComments(): number {
  return SMOKE_EXPECTED_COMMENTS;
}
export function smokeAnchorFile(): string {
  return SMOKE_ANCHOR_FILE;
}
export const SMOKE_SUMMARY = smokeLabel();
