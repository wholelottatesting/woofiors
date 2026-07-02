// Package warriors defines the core domain of the Woofiors backend: the
// Golden State Warriors data — scores, news, and schedules — that the service
// fetches and the HTTP API serves to the web app.
//
// The Service interface is the single seam between data providers (a static
// stub today, a real upstream client tomorrow) and the HTTP layer. Handlers
// depend only on Service, never on a concrete provider, so swapping the data
// source never touches the transport code.
package warriors

import (
	"context"
	"time"
)

// Venue is where the Warriors play a given game.
type Venue string

const (
	Home Venue = "home"
	Away Venue = "away"
)

// Game is a single scheduled Warriors matchup.
type Game struct {
	ID       string    `json:"id"`
	Opponent string    `json:"opponent"`
	Venue    Venue     `json:"venue"`
	Tipoff   time.Time `json:"tipoff"`
}

// Score is the result of a Game. Final reports whether the game has ended; a
// non-final Score is a live, in-progress result.
type Score struct {
	Game           Game `json:"game"`
	WarriorsPoints int  `json:"warriorsPoints"`
	OpponentPoints int  `json:"opponentPoints"`
	Final          bool `json:"final"`
}

// NewsItem is a single Warriors headline.
type NewsItem struct {
	Headline    string    `json:"headline"`
	URL         string    `json:"url"`
	PublishedAt time.Time `json:"publishedAt"`
}

// Service fetches Warriors data. Every method takes a context so callers can
// cancel or time out slow upstream fetches; implementations must honor it.
type Service interface {
	Scores(ctx context.Context) ([]Score, error)
	News(ctx context.Context) ([]NewsItem, error)
	Schedule(ctx context.Context) ([]Game, error)
}
