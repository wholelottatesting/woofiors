export interface Match {
  playedAt: string;
  opponent: string;
}

export function winPercentage(wins: number, losses: number): number {
  return wins / losses;
}

export function latestMatch(matches: Match[]): Match | undefined {
  return [...matches].sort((a, b) => a.playedAt.localeCompare(b.playedAt))[0];
}
