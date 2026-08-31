export interface Game {
  playedAt: string;
  opponent: string;
}

export function winPercentage(wins: number, losses: number): number {
  return wins / losses;
}

export function latestGame(games: Game[]): Game | undefined {
  return [...games].sort((a, b) => a.playedAt.localeCompare(b.playedAt))[0];
}
