// Twin A. Listed in .macroscope/ignore.md on this branch, so a review that
// resolved config from the PR head should NOT report anything here.
//
// Carries the same defect as its twin in head-probe-reviewed.ts: the loop runs
// one index past the end of the array, and an empty input divides by zero.
export function averageIgnored(values: number[]): number {
  let total = 0;
  for (let i = 0; i <= values.length; i++) {
    total += values[i];
  }
  return total / values.length;
}
