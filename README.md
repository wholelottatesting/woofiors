# woofiors

> Latest scores, news, and schedules for the Dubs.

A monorepo housing a Go backend and React frontend that aggregates Golden State Warriors scores, upcoming schedules, and news from public APIs into a single clean dashboard.

---

## What it does

| Feature | Detail |
|---|---|
| **Live & recent scores** | Game results with box-score summaries |
| **Upcoming schedule** | Next games with tip-off times and opponents |
| **News feed** | Latest Warriors headlines pulled from public sports news APIs |

---

## Architecture

```
woofiors/
├── backend/        # Go HTTP API server
│   ├── cmd/        # Entry points (server)
│   ├── internal/   # Business logic, API clients, handlers
│   └── ...
└── frontend/       # React single-page app
    ├── src/
    │   ├── components/
    │   ├── hooks/
    │   └── ...
    └── ...
```

The backend proxies and caches requests to public sports APIs — keeping API keys off the client and responses snappy. The frontend talks only to the backend.

### Public APIs used

| API | Data |
|---|---|
| [NBA Stats (nba.com)](https://www.nba.com/stats) | Scores, schedules, standings |
| [balldontlie](https://www.balldontlie.io/) | Game results and player stats |
| [SportsData.io](https://sportsdata.io/) | Supplemental scores and news |

---

## Getting started

### Prerequisites

- Go 1.22+
- Node 20+ / npm 10+

### Backend

```bash
cd backend
cp .env.example .env   # fill in API keys
go run ./cmd/server
# → http://localhost:8080
```

### Frontend

```bash
cd frontend
npm install
npm run dev
# → http://localhost:5173
```

---

## Development

```
make dev       # start both backend and frontend in watch mode
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

1. Fork the repo and create a feature branch.
2. Write tests first — requirements live in tests.
3. Run `make test && make lint` before pushing.
4. Open a PR against `main`.
