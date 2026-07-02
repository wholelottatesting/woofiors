// Command woofiors-backend is the HTTP entrypoint for the Woofiors backend.
// It loads configuration, wires the static data provider into the HTTP API,
// and serves until the process is killed.
package main

import (
	"log"
	"net/http"
	"os"

	"github.com/wholelottatesting/woofiors/backend/internal/config"
	"github.com/wholelottatesting/woofiors/backend/internal/httpapi"
	"github.com/wholelottatesting/woofiors/backend/internal/warriors/static"
)

func main() {
	cfg, err := config.Load(os.LookupEnv)
	if err != nil {
		log.Fatalf("woofiors: %v", err)
	}

	srv := httpapi.NewServer(static.New())

	log.Printf("woofiors backend fetching on %s 🐾", cfg.Addr)
	if err := http.ListenAndServe(cfg.Addr, srv); err != nil {
		log.Fatalf("woofiors: server stopped: %v", err)
	}
}
