/**
 * Returns the index of the first unoccupied smoke slot, or -1 when every slot
 * is occupied (an empty array is, vacuously, fully occupied).
 *
 * `findIndex` already has exactly this contract, so there is no loop bound to
 * get wrong: the hand-rolled loop this replaces ran to `index <= length` and
 * read one past the end, where `occupied[length]` is `undefined` and therefore
 * looked open — returning `length` instead of the documented -1.
 */
export function firstOpenSmokeSlot(occupied: readonly boolean[]): number {
  return occupied.findIndex((slot) => !slot);
}
