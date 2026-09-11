// Requirements for `firstOpenSmokeSlot`, encoded as tests.
//
// The repo carries no JS toolchain (no package.json, no CI test job — the
// workflow's check-run set is itself a fixture, so adding a job would perturb
// the CRA matrix in README.md). Run these by hand on Node >= 22.6:
//
//   node --test --experimental-strip-types src/check-run-fifm-fresh-smoke.test.ts

import assert from 'node:assert/strict';
import test from 'node:test';

import { firstOpenSmokeSlot } from './check-run-fifm-fresh-smoke.ts';

/**
 * A fully occupied array has no open slot, so the documented -1 fallback is the
 * only correct answer. This is the regression: the previous loop ran to
 * `index <= occupied.length`, read the `undefined` one past the end as an open
 * slot, and returned `occupied.length` — an in-range-looking index that callers
 * would happily write to.
 */
test('reports -1 when every slot is occupied', () => {
  assert.equal(firstOpenSmokeSlot([true]), -1);
  assert.equal(firstOpenSmokeSlot([true, true, true]), -1);
});

/**
 * An empty array has no slot to open, so it must also take the -1 fallback and
 * never the index 0 the off-by-one loop reported.
 */
test('reports -1 for an empty slot array', () => {
  assert.equal(firstOpenSmokeSlot([]), -1);
});

/**
 * The answer must be the *first* open slot, not any open slot: callers fill
 * slots in order, so a later index would leave a hole behind.
 */
test('reports the lowest open slot index', () => {
  assert.equal(firstOpenSmokeSlot([false]), 0);
  assert.equal(firstOpenSmokeSlot([true, false, false]), 1);
  assert.equal(firstOpenSmokeSlot([true, true, false]), 2);
});

/**
 * The function is a pure query: it reports a slot without claiming it, so
 * repeated calls agree and the caller's array is untouched.
 */
test('leaves its input unchanged and is repeatable', () => {
  const occupied: readonly boolean[] = [true, false];

  assert.equal(firstOpenSmokeSlot(occupied), 1);
  assert.equal(firstOpenSmokeSlot(occupied), 1);
  assert.deepEqual(occupied, [true, false]);
});
