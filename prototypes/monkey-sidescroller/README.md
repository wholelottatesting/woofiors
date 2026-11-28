# Monkey Jungle Dash 🐒

A 2D side-scrolling platformer built to be played in a browser on an iPhone.
Old-school pixel art, a procedurally generated jungle, and a chiptune soundtrack —
all in a single self-contained HTML file with no build step and no dependencies.

## Play it

```bash
cd prototypes/monkey-sidescroller
python3 -m http.server 8411
```

Then open `http://<host>:8411/` on a phone. Hold it **sideways** — the game is
16:9, and portrait letterboxes into a narrow band (it says so on screen).

## Controls

| Input | Action |
|---|---|
| Tap **left half** | Jump |
| Hold **right half** | Run (release to stop) |
| On a ladder | Hold = travel forward (up an up-ladder, down a down-ladder); release = backtrack |
| Tap left on a ladder | Leap off |
| Speaker icon (top centre) | Mute / unmute |
| `DAY/NITE` button (title screen) | Force the time of day |

Keyboard equivalents for desktop testing: `→`/`D` to run, `Space`/`↑`/`W` to
jump, `M` to mute.

## Levels

Levels are finite and end at a **GOAL** gate worth a bonus of `20 + level × 10`
bananas. The difficulty curve adds one idea at a time rather than scaling
randomly:

| Level | Adds | Length |
|---|---|---|
| 1 | Gaps and gentle steps only — no obstacles at all | 2200px |
| 2 | Obstacles (sparse) and floating pillars | 2950px |
| 3 | Ladders | 3700px |
| 4+ | Three-in-a-row obstacle runs | +750px each, capped at 6400px |

## Characters

The roster appears before every level once more than one character is
unlocked — including after a game over. Your pick and your unlocks persist in
`localStorage`.

| Character | Unlocked by |
|---|---|
| **Mono** — the grey stuffed monkey | default |
| **Arthur** — five years old, dark blonde hair, red shoes | beating level 1 |
| **Mommy** — dark curly hair, fairy wings, tiara and star wand | beating level 2 |
| **Daddy** — tall, short black hair, jersey, carrying a basketball | beating level 3 |
| **Toby** — merle tri-colour bernedoodle | beating level 4 |
| **Nana** — grandma in a lion costume, mane and glasses | beating level 5 |
| **Gammy** — grandma in a whale costume, hood, spout and fluke | beating level 6 |
| **Zayde** — grandpa in a black bear costume, glasses and moustache | beating level 7 |
| **Hellen** — five years old, brown bob and a bow | beating level 8 |

Add a character by adding a `SKINS` entry and one line to `UNLOCK_AT`; the
roster order, the unlock panel and the grid layout all derive from those.

All characters share one animation rig and one hitbox, so they play
identically. A skin swaps colours and toggles features — `muzzle`, `tail`,
`curly` / `shortHair` / `longHair`, `hat`, `crown`, `wings`, `wand`, `ball`,
`mane`, `hood`, `spout`, `fluke`, `animalEar`, `glasses`, `moustache`, `bow`,
and `lift` for a taller build. Toby sets `quad: true` and takes a separate
four-legged body plan that reuses the same animation parameters, so his run
and jump timing match everyone else's.

The roster grid reflows to the viewport: one row in landscape, wrapping to
more rows as the cast grows. When cells get too short for a whole body it
switches to clipped head-and-shoulders portraits rather than overflowing, so
it stays correct in portrait at nine characters and beyond.

## Level-generation invariants

The generator is constrained by the jump arc so it cannot produce an unfair
layout. With `JUMP_V = -278` and `GRAV = 920`:

- apex ≈ **42px**, airtime ≈ **0.60s**, horizontal reach ≈ **81px** at full speed

From which:

- `LANDING_MARGIN = 48` — no obstacle within 48px of a platform's left edge, so
  you always get run-up after a gap or ledge
- `EDGE_MARGIN = 34` — no obstacle that close to a right edge
- `OBSTACLE_SPACING = 96` — wider than one jump arc, so one jump clears exactly
  one obstacle
- gaps are capped per level and never exceed 46px
- ladder walls are **48px**, deliberately taller than the apex, so a ladder is
  genuinely the only way up
- no obstacles in the first 420px of a level or the last 400px before the goal

## Theme

Follows the OS `prefers-color-scheme` live (light → day, dark → night), with a
manual `AUTO / DAY / NITE` override on the title screen.

## iOS notes

A plain WebAudio context lands in iOS's *ambient* audio session, which the
physical Ring/Silent switch mutes regardless of the volume buttons. The game
asks for the `playback` session (`navigator.audioSession`, iOS 16.4+) and keeps
a silent looping `<audio>` element playing so older iOS moves to the media
session too. An on-screen readout under the speaker icon reports the audio state
when it is not running.

## Testing

There is no test runner in the page. Harnesses live outside the repo (they stub
the DOM/canvas and drive the game headlessly, plus Playwright scripts for real
browser runs and screenshots). The page exposes a `globalThis.MJD` debug hook —
game state, the level config, the character roster and `audioInfo()` — which is
what those harnesses read.
