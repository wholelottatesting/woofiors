// Small code change to trigger a correctness review run (max-runs cap test).
export function clampBudget(cents: number, cap: number): number {
  if (cap <= 0) return cents;
  return Math.min(cents, cap);
}
