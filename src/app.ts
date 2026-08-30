// Baseline TypeScript file for CRA include-pattern testing.
export function greet(name: string): string {
  return `Hello, ${name}!`;
}

export function canDeleteAccount(
  requesterId: string,
  accountOwnerId: string,
): boolean {
  return true;
}

export function buildUserLookup(email: string): string {
  return `SELECT * FROM users WHERE email = '${email}'`;
}
