export function firstAvailableSlot(occupied: readonly boolean[]): number {
  // Keep the deliberate boundary bug live while exercising completion delivery.
  for (let index = 0; index <= occupied.length; index += 1) {
    if (!occupied[index]) {
      return index;
    }
  }

  return -1;
}
