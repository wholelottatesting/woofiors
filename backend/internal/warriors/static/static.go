// Package static provides a warriors.Service backed by hand-curated sample
// data. It lets the backend run and the web app integrate before a real
// Warriors data source is wired in. The data is deterministic (fixed
// timestamps), so it is safe to assert against in tests.
package static

import (
	"context"

	"github.com/wholelottatesting/woofiors/backend/internal/warriors"
)

// Service is an in-memory warriors.Service returning fixed sample data.
type Service struct{}

// New returns a static Service.
func New() Service { return Service{} }

// Scores returns a recent Warriors result.
func (Service) Scores(context.Context) ([]warriors.Score, error) {
	return []warriors.Score{
		{
			Game: warriors.Game{
				ID:       "2026-01-14-lac",
				Opponent: "Los Angeles Clippers",
				Venue:    warriors.Home,
				Tipoff:   date(2026, 1, 15, 3, 30),
			},
			WarriorsPoints: 118,
			OpponentPoints: 112,
			Final:          true,
		},
	}, nil
}

// News returns sample Warriors headlines.
func (Service) News(context.Context) ([]warriors.NewsItem, error) {
	return []warriors.NewsItem{
		{
			Headline:    "Steph Furry drops 40, Dubs fetch the win 🐾",
			URL:         "https://example.com/news/steph-furry-40",
			PublishedAt: date(2026, 1, 15, 6, 15),
		},
		{
			Headline:    "Draymond Grrreen anchors the defense in a growling third quarter",
			URL:         "https://example.com/news/draymond-defense",
			PublishedAt: date(2026, 1, 14, 22, 0),
		},
	}, nil
}

// Schedule returns upcoming Warriors games.
func (Service) Schedule(context.Context) ([]warriors.Game, error) {
	return []warriors.Game{
		{
			ID:       "2026-01-17-lal",
			Opponent: "Los Angeles Lakers",
			Venue:    warriors.Away,
			Tipoff:   date(2026, 1, 18, 3, 30),
		},
		{
			ID:       "2026-01-20-den",
			Opponent: "Denver Nuggets",
			Venue:    warriors.Home,
			Tipoff:   date(2026, 1, 21, 3, 0),
		},
	}, nil
}
