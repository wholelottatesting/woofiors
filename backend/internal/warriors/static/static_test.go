package static

import (
	"context"
	"testing"

	"github.com/wholelottatesting/woofiors/backend/internal/warriors"
)

// Requirement: the static Service satisfies warriors.Service. If the interface
// grows a method, this fails to compile — the scaffold's contract is enforced
// by the type system, not by hope.
var _ warriors.Service = Service{}

// Requirement: each endpoint's data source returns a non-empty, well-formed
// payload so the web app has something real to render against. Empty slices
// would let a broken provider masquerade as working.
func TestStaticData(t *testing.T) {
	ctx := context.Background()
	svc := New()

	scores, err := svc.Scores(ctx)
	if err != nil {
		t.Fatalf("Scores: %v", err)
	}
	if len(scores) == 0 {
		t.Error("Scores: want sample data, got none")
	}
	for i, s := range scores {
		if s.Game.ID == "" || s.Game.Opponent == "" {
			t.Errorf("scores[%d]: incomplete game %+v", i, s.Game)
		}
		if !validVenue(s.Game.Venue) {
			t.Errorf("scores[%d]: invalid venue %q", i, s.Game.Venue)
		}
	}

	news, err := svc.News(ctx)
	if err != nil {
		t.Fatalf("News: %v", err)
	}
	if len(news) == 0 {
		t.Error("News: want sample data, got none")
	}
	for i, n := range news {
		if n.Headline == "" || n.URL == "" || n.PublishedAt.IsZero() {
			t.Errorf("news[%d]: incomplete item %+v", i, n)
		}
	}

	schedule, err := svc.Schedule(ctx)
	if err != nil {
		t.Fatalf("Schedule: %v", err)
	}
	if len(schedule) == 0 {
		t.Error("Schedule: want sample data, got none")
	}
	for i, g := range schedule {
		if g.ID == "" || g.Opponent == "" || g.Tipoff.IsZero() {
			t.Errorf("schedule[%d]: incomplete game %+v", i, g)
		}
		if !validVenue(g.Venue) {
			t.Errorf("schedule[%d]: invalid venue %q", i, g.Venue)
		}
	}
}

// Requirement: the static data is deterministic. Two reads return identical
// results, which is what lets tests and the web app rely on it.
func TestStaticData_Deterministic(t *testing.T) {
	ctx := context.Background()
	svc := New()

	first, _ := svc.Schedule(ctx)
	second, _ := svc.Schedule(ctx)
	if len(first) != len(second) {
		t.Fatalf("Schedule length changed between reads: %d vs %d", len(first), len(second))
	}
	for i := range first {
		if first[i] != second[i] {
			t.Errorf("schedule[%d] changed between reads: %+v vs %+v", i, first[i], second[i])
		}
	}
}

func validVenue(v warriors.Venue) bool {
	return v == warriors.Home || v == warriors.Away
}
