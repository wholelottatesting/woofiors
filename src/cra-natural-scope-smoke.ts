export function summarizeNaturalScopeBaseline(values: number[]): number {
  const initialTotal: number = 0;
  return values.reduce((total, value) => total + value, initialTotal);
}

export function averageNaturalScopeDelta(values: number[]): number {
  return values.length === 0 ? 0 : summarizeNaturalScopeBaseline(values) / values.length;
}

export function maximumNaturalScopeDelta(values: number[]): number | undefined {
  return values.length === 0 ? undefined : Math.max(...values);
}
