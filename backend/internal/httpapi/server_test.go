package httpapi

import (
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/wholelottatesting/woofiors/backend/internal/warriors"
	"github.com/wholelottatesting/woofiors/backend/internal/warriors/static"
)

// fakeService is a warriors.Service whose every method returns errBoom. It
// exercises the failure path that a static provider never triggers.
type fakeService struct{}

var errBoom = errors.New("upstream unavailable")

func (fakeService) Scores(context.Context) ([]warriors.Score, error)  { return nil, errBoom }
func (fakeService) News(context.Context) ([]warriors.NewsItem, error) { return nil, errBoom }
func (fakeService) Schedule(context.Context) ([]warriors.Game, error) { return nil, errBoom }

func get(t *testing.T, h http.Handler, method, path string) *httptest.ResponseRecorder {
	t.Helper()
	rec := httptest.NewRecorder()
	h.ServeHTTP(rec, httptest.NewRequest(method, path, nil))
	return rec
}

// Requirement: every API route answers a GET with 200 and a JSON body of the
// expected shape. This is the contract the web app codes against.
func TestRoutes_OK(t *testing.T) {
	srv := NewServer(static.New())

	cases := []struct {
		path string
		into any
	}{
		{"/healthz", &map[string]string{}},
		{"/api/scores", &[]warriors.Score{}},
		{"/api/news", &[]warriors.NewsItem{}},
		{"/api/schedule", &[]warriors.Game{}},
	}
	for _, tc := range cases {
		rec := get(t, srv, http.MethodGet, tc.path)
		if rec.Code != http.StatusOK {
			t.Errorf("%s: status = %d, want 200", tc.path, rec.Code)
		}
		if ct := rec.Header().Get("Content-Type"); ct != "application/json; charset=utf-8" {
			t.Errorf("%s: Content-Type = %q, want JSON", tc.path, ct)
		}
		if err := json.Unmarshal(rec.Body.Bytes(), tc.into); err != nil {
			t.Errorf("%s: body is not the expected JSON: %v", tc.path, err)
		}
	}
}

// Requirement: when the data provider fails, the API returns 502 with a JSON
// error envelope — never a 200 with an empty or partial body that the web app
// would misread as "no games".
func TestRoutes_ServiceError(t *testing.T) {
	srv := NewServer(fakeService{})

	for _, path := range []string{"/api/scores", "/api/news", "/api/schedule"} {
		rec := get(t, srv, http.MethodGet, path)
		if rec.Code != http.StatusBadGateway {
			t.Errorf("%s: status = %d, want 502", path, rec.Code)
		}
		var body struct {
			Error string `json:"error"`
		}
		if err := json.Unmarshal(rec.Body.Bytes(), &body); err != nil || body.Error == "" {
			t.Errorf("%s: want JSON error envelope, got %q (err=%v)", path, rec.Body.String(), err)
		}
	}
}

// Requirement: non-GET methods on API routes are rejected (405). The Warriors
// API is read-only; the method-aware mux must enforce that.
func TestRoutes_MethodNotAllowed(t *testing.T) {
	srv := NewServer(static.New())
	rec := get(t, srv, http.MethodPost, "/api/scores")
	if rec.Code != http.StatusMethodNotAllowed {
		t.Errorf("POST /api/scores: status = %d, want 405", rec.Code)
	}
}

// Requirement: unknown paths return 404, so typos surface as errors rather
// than silently matching some catch-all.
func TestRoutes_NotFound(t *testing.T) {
	srv := NewServer(static.New())
	rec := get(t, srv, http.MethodGet, "/api/bark")
	if rec.Code != http.StatusNotFound {
		t.Errorf("GET /api/bark: status = %d, want 404", rec.Code)
	}
}
