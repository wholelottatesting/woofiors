# 🐕 Woofiors Backend

The Go service behind [Woofiors](../README.md). It fetches Golden State
Warriors data — scores, news, and schedules — and serves it to the web app over
a small JSON HTTP API.

> This is scaffolding: the data is a static, hand-curated stub so the API runs
> and the web app can integrate today. Swapping in a real Warriors data source
> is a matter of writing a new `warriors.Service` implementation — no HTTP code
> changes.

## Run it

```bash
cd backend
go run .
# WOOFIORS_ADDR=127.0.0.1:9000 go run .   # override the listen address
```

The server listens on `:8080` by default.

## API

| Method | Path            | Returns                        |
| ------ | --------------- | ------------------------------ |
| `GET`  | `/healthz`      | Liveness probe (`{"status":"ok"}`) |
| `GET`  | `/api/scores`   | Latest Warriors scores         |
| `GET`  | `/api/news`     | Latest Warriors headlines      |
| `GET`  | `/api/schedule` | Upcoming Warriors games        |

The API is read-only: non-`GET` methods return `405`. On a data-source failure
the API returns `502` with a JSON error envelope (`{"error":"…"}`) rather than a
misleading empty `200`.

## Layout

```
backend/
├── main.go                        # entrypoint: load config, wire, serve
└── internal/
    ├── config/                    # explicit, fail-fast env configuration
    ├── httpapi/                   # HTTP transport — routes & JSON encoding
    └── warriors/                  # domain types + Service interface
        └── static/                # static-data Service implementation
```

- **`warriors`** owns the domain (`Game`, `Score`, `NewsItem`) and the
  `Service` interface — the single seam between data providers and the API.
- **`httpapi`** is a thin edge: fetch from a `Service`, encode JSON. All data
  logic stays behind the interface.
- **`config`** loads settings from the environment. An unset variable takes its
  documented default; a variable set to an empty or invalid value fails loudly
  at startup instead of silently falling back.

## Configuration

| Variable        | Default  | Description                      |
| --------------- | -------- | -------------------------------- |
| `WOOFIORS_ADDR` | `:8080`  | TCP listen address (`host:port`) |

## Develop

```bash
go build ./...
go vet ./...
go test ./...
```

Requirements live in the tests: each test's doc comment states the requirement
it encodes. Add a feature by adding the test that specifies it. 🐾
