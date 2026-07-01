# 🐕 Woofiors

> Latest scores, news, and schedules for the Golden State Warriors — with a good boy's twist.

**Woofiors** is a fan companion for the Golden State Warriors. Whether Steph Furry is raining threes from the parking lot or the Dubs are chasing another banner, Woofiors keeps you fetching the freshest scores, news, and schedules — all wrapped in an unapologetically playful dog theme. 🏀🐾

---

## Features

- 🏀 **Latest Scores** — Live and recent game results. Did the Dubs win? Woof yeah.
- 📰 **News** — The latest Warriors headlines, rounded up so you never miss a beat (or a bark).
- 📅 **Schedules** — Upcoming games so you always know when it's time to howl at the arena.
- 🐶 **Dog Theme Everywhere** — Because a Warriors app is better with a wagging tail. Meet the starting lineup: Steph Furry, Draymond Grrreen, Klay Thompup, and Coach Steve Kennel.

---

## Architecture

This is a monorepo housing both the backend and the web app:

```
woofiors/
├── backend/    # Go API — fetches & serves Warriors scores, news, and schedules
│   ├── cmd/    # Entry points (server)
│   └── internal/  # Business logic, API clients, handlers
├── web/        # React web app — the fan-facing frontend
│   └── src/
│       ├── components/
│       └── hooks/
└── README.md   # You are here 🐾
```

> Note: the `backend/` and `web/` directories are still being scaffolded. This README describes the intended shape of the kennel.

The backend proxies and caches requests to public sports APIs — keeping API keys off the client and responses snappy. The frontend talks only to the backend.

### Public APIs used

| API | Data |
|---|---|
| [NBA Stats (nba.com)](https://www.nba.com/stats) | Scores, schedules, standings |
| [balldontlie](https://www.balldontlie.io/) | Game results and player stats |
| [SportsData.io](https://sportsdata.io/) | Supplemental scores and news |

---

## Getting Started

### Prerequisites

- Go 1.22+
- Node 20+ / npm 10+

### Backend (Go)

```bash
cd backend
cp .env.example .env   # fill in API keys
go run ./cmd/server
# → http://localhost:8080
```

### Web app (React)

```bash
cd web
npm install
npm run dev
# → http://localhost:5173
```

---

## Development

```
make dev       # start both backend and web app in watch mode
make test      # run all tests (Go + Vitest)
make lint      # golangci-lint + eslint
make build     # production binaries
```

---

## Configuration

Backend configuration is read from environment variables (no silent fallbacks — missing required values cause a startup error):

| Variable | Required | Description |
|---|---|---|
| `PORT` | no | HTTP listen port (default `8080`) |
| `NBA_API_KEY` | yes | API key for SportsData.io |
| `CACHE_TTL_SECONDS` | no | Response cache TTL (default `60`) |

---

## Team

| GitHub | Role |
|---|---|
| [@stephfurry](https://github.com/stephfurry) | Co-founder |
| [@dogmond](https://github.com/dogmond) | Co-founder |
| [@iguodoggo](https://github.com/iguodoggo) | Co-founder |

---

## Contributing

Good dogs welcome. Keep the code clean, the puns groan-worthy, and the tail wagging. 🐕

1. Fork the repo and create a feature branch.
2. Write tests first — requirements live in tests.
3. Run `make test && make lint` before pushing.
4. Open a PR against `main`.

---

Go Woofiors! 💙💛
