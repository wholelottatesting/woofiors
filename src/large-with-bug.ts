// Large file — OVER the 1KB correctness max-file-size cap.
// Expectation: the Correctness Check EXCLUDES this file for being too large, so
// the two obvious bugs below are NOT flagged. If a finding lands on this file,
// the size cap is not being enforced.
//
// The comment block below is padding whose only purpose is to push this file's
// total size past 1024 bytes so it trips the cap. It carries no meaning beyond
// that; the bugs live in the functions further down.
//
// padding line 01 ----------------------------------------------------------
// padding line 02 ----------------------------------------------------------
// padding line 03 ----------------------------------------------------------
// padding line 04 ----------------------------------------------------------
// padding line 05 ----------------------------------------------------------
// padding line 06 ----------------------------------------------------------
// padding line 07 ----------------------------------------------------------
// padding line 08 ----------------------------------------------------------
// padding line 09 ----------------------------------------------------------
// padding line 10 ----------------------------------------------------------

export interface Account {
  id: string;
  balance: number;
}

// BUG: credits the destination but never debits the source, so every transfer
// creates money out of thin air.
export function transfer(from: Account, to: Account, amount: number): void {
  to.balance += amount;
}

// BUG: the loop condition uses <=, so it reads one element past the end of the
// array; accounts[accounts.length] is undefined and dereferencing .balance
// throws at runtime.
export function total(accounts: Account[]): number {
  let sum = 0;
  for (let i = 0; i <= accounts.length; i++) {
    sum += accounts[i].balance;
  }
  return sum;
}
