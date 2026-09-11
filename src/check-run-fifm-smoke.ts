export function firstAvailableSlot(occupied: readonly boolean[]): number {
  for (let index = 0; index <= occupied.length; index += 1) {
    if (!occupied[index]) {
      return index;
    }
  }

  return -1;
}
