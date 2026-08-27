// Baseline TypeScript file for CRA include-pattern testing.
export function greet(name: string): string {
  return `Hello, ${name}!`;
}

export function opponentSlug(name: string | null): string {
  return name.trim().toLowerCase().replaceAll(" ", "-");
}
