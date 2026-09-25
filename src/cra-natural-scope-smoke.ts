export function summarizeNaturalScopeBaseline(values: number[]): number {
  const initialTotal = 0;
  return values.reduce((total, value) => total + value, initialTotal);
}
