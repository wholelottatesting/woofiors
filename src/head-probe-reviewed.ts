// Twin B. Deliberately NOT listed in .macroscope/ignore.md, so this is the
// control: a working review should report it whichever commit config came from.
//
// Carries the same defect as its twin in head-probe-ignored.ts: the loop runs
// one index past the end of the array, and an empty input divides by zero.
export function averageReviewed(values: number[]): number {
  let total = 0;
  for (let i = 0; i <= values.length; i++) {
    total += values[i];
  }
  return total / values.length;
}
