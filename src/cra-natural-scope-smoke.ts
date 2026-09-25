export function summarizeNaturalScopeBaseline(values: number[]): number {
  const initialTotal: number = 0;
  return values.reduce((total, value) => total + value, initialTotal);
}

export function averageNaturalScopeDelta(values: number[]): number {
  return values.length === 0 ? 0 : summarizeNaturalScopeBaseline(values) / values.length;
}
