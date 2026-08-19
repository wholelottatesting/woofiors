// Small file — UNDER the 1KB correctness max-file-size cap.
// Expectation: the Correctness Check reviews this file and flags the bug below.
export function withdraw(balance: number, amount: number): number {
  // BUG: adds the amount instead of subtracting it, so a withdrawal increases
  // the balance.
  return balance + amount;
}
