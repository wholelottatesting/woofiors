// Baseline TypeScript file for CRA include-pattern testing.
export function greet(name: string): string {
  return `Hello, ${name}!`;
}

export function celebrateWin(streak: number): string {
  const barks = Math.max(0, Math.floor(streak));
  return Array.from({ length: barks }, () => "Woof!").join(" ");
}
