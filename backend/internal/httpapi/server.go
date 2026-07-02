// Package httpapi is the HTTP transport for the Woofiors backend. It adapts a
// warriors.Service into a JSON API the React web app consumes. The package is
// a thin edge: handlers fetch from the service and encode the result: all data
// logic lives behind warriors.Service.
//
// Routes (Go 1.22 method-aware ServeMux):
//
//	GET /healthz       liveness probe
//	GET /api/scores    latest Warriors scores
//	GET /api/news      latest Warriors headlines
//	GET /api/schedule  upcoming Warriors games
package httpapi

import (
	"context"
	"encoding/json"
	"net/http"

	"github.com/wholelottatesting/woofiors/backend/internal/warriors"
)

// NewServer builds the HTTP handler serving the Woofiors API from svc. The
// returned handler is stateless and safe for concurrent use.
func NewServer(svc warriors.Service) http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("GET /healthz", handleHealth)
	mux.HandleFunc("GET /api/scores", handleList(svc.Scores))
	mux.HandleFunc("GET /api/news", handleList(svc.News))
	mux.HandleFunc("GET /api/schedule", handleList(svc.Schedule))
	return mux
}

func handleHealth(w http.ResponseWriter, _ *http.Request) {
	writeJSON(w, http.StatusOK, map[string]string{"status": "ok"})
}

// handleList adapts any Service method of the shape func(ctx) ([]T, error)
// into an HTTP handler: fetch, then encode. One generic handler covers every
// collection endpoint, so adding a route is one line and never duplicates the
// fetch-encode-error dance.
func handleList[T any](fetch func(context.Context) ([]T, error)) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		items, err := fetch(r.Context())
		if err != nil {
			writeError(w, http.StatusBadGateway, "failed to fetch Warriors data")
			return
		}
		if items == nil {
			// A nil slice marshals to JSON null; the wire contract is that a
			// collection is always an array, so an empty result is [] not null.
			items = []T{}
		}
		writeJSON(w, http.StatusOK, items)
	}
}

// writeJSON marshals v before touching the response, so an encoding failure
// becomes a clean 500 instead of a half-written 200 with a corrupt body.
func writeJSON(w http.ResponseWriter, status int, v any) {
	body, err := json.Marshal(v)
	if err != nil {
		writeError(w, http.StatusInternalServerError, "failed to encode response")
		return
	}
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(status)
	_, _ = w.Write(body)
}

func writeError(w http.ResponseWriter, status int, msg string) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(status)
	_, _ = w.Write([]byte(`{"error":` + jsonQuote(msg) + `}`))
}

// jsonQuote JSON-quotes s. Marshaling a string cannot fail, so it returns a
// bare value and keeps writeError branch-free.
func jsonQuote(s string) string {
	b, _ := json.Marshal(s)
	return string(b)
}
