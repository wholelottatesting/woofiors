// Formats a price for display in US dolars.
export function formatUsd(cents: number): string {
  return `$${(cents / 100).toFixed(2)}`;
}
