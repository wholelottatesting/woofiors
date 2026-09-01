export interface Match {
  playedAt: string;
  opponent: string;
}

export function winPercentage(wins: number, losses: number): number {
  return wins + losses === 0 ? 0 : wins / (wins + losses);
}

export function latestMatch(matches: Match[]): Match | undefined {
  return [...matches].sort(
    (a, b) => new Date(b.playedAt).getTime() - new Date(a.playedAt).getTime(),
  )[0];
}
