# 🐕 Woofiors

> Latest scores, news, and schedules for the Golden State Warriors — with a good boy's twist.

**Woofiors** is a fan companion for the Golden State Warriors. Whether Steph Furry is raining threes from the parking lot or the Dubs are chasing another banner, Woofiors keeps you fetching the freshest scores, news, and schedules — all wrapped in an unapologetically playful dog theme. 🏀🐾

## What is this?

Woofiors is a small monorepo pairing a **Go backend** with a **React web app**. The backend does the digging (fetching and serving Warriors data), and the frontend puts on the good boy face (rendering it for fans).

## Features

- 🏀 **Latest Scores** — Live and recent game results. Did the Dubs win? Woof yeah.
- 📰 **News** — The latest Warriors headlines, rounded up so you never miss a beat (or a bark).
- 📅 **Schedules** — Upcoming games so you always know when it's time to howl at the arena.
- 🐶 **Dog Theme Everywhere** — Because a Warriors app is better with a wagging tail. Meet the starting lineup: Steph Furry, Draymond Grrreen, Klay Thompup, and Coach Steve Kennel.

## Repository Structure

This is a monorepo housing both the backend and the web app:

```
woofiors/
├── backend/    # Go API — fetches & serves Warriors scores, news, and schedules
├── web/        # React web app — the fan-facing frontend
└── README.md   # You are here 🐾
```

> Note: the `backend/` directory now has a runnable Go scaffold (see [backend/README.md](backend/README.md)); the `web/` app is still being scaffolded. This README describes the intended shape of the kennel.

### Backend (Go)

A Go service responsible for pulling Warriors data (scores, news, schedules) and exposing it through a clean HTTP API for the web app to consume.

### Web (React)

A React single-page app that fetches from the Go backend and presents scores, news, and schedules to fans — dog theme and all.

## Getting Started

Once the backend and web app land, you'll be able to run each side of the kennel:

```bash
# Backend (Go)
cd backend
go run .

# Web app (React)
cd web
npm install
npm run dev
```

## Contributing

Good dogs welcome. Keep the code clean, the puns groan-worthy, and the tail wagging. 🐕

---

Go Woofiors! 💙💛

## CRA test matrix (in `.macroscope/check-run-agents/`)

Test setup for Macroscope Check Run Agent `requiredStatusCheck` permutations.

| CRA | requiredStatusCheck | Gate | Expected when gate misses |
|---|---|---|---|
| Req TS Check | true | include `**/*.ts`,`**/*.tsx` / exclude `**/*.d.ts` | check created, concluded **skipped** |
| Ctrl TS Check | (absent) | same include/exclude | **no check run at all** (control) |
| Req Label Check | true | labels: `run-me` | **skipped** unless PR carries the label at open |
| Req Target Check | true | targets: `release` | **skipped** on PRs to main |
| Req Author Check | true | authors: never-matching | **skipped** always |
| Req Bare Check | true | none (parse warning expected) | runs everywhere; **skipped** (not absent) if a repo-level Skip-by excludes the PR |

Bot-author skip smoke test: automatic checks should stop before review execution.
