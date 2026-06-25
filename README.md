# Portfolio Refurbish — Drop-in Pack

This folder is a ready-to-merge version of your portfolio: same content,
reorganized by **theme** instead of week, with a new warm editorial/zine
stylesheet.

## What's inside

```
mkdocs.yml                  ← new nav, grouped by topic
migrate.sh                  ← git mv commands for your REAL repo
docs/
  index.md                  ← updated home page
  stylesheets/extra.css     ← new warm editorial/zine theme
  javascripts/mathjax.js    ← unchanged
  foundations/              ← tooling, hardware basics, architecture, git
  code-and-logic/           ← C & Python fundamentals, memory, compilation
  inputs-and-control/       ← buttons, state logic, traffic light
  sensing-the-world/        ← DHT22, ultrasonic / time-of-flight
  going-wireless/           ← SPI/UART/I2C, Pico W Wi-Fi init
  capstone/                 ← the IoT irrigation proposal
```

## How to apply it to your actual repo

1. Copy `migrate.sh` into the root of your real repo and run it:
   ```bash
   bash migrate.sh
   ```
   This uses `git mv` to rename/relocate your existing files, preserving
   git history, and deletes the empty week07–week09 placeholder files that
   had no content yet.

2. Copy these two files over (overwrite the originals):
   - `mkdocs.yml`
   - `docs/index.md`
   - `docs/stylesheets/extra.css`

3. Your `docs/assets/` folder does **not** need to move. Every page sits
   one folder under `docs/` in both the old and new layout, so the
   `../../assets/...` relative image paths still resolve correctly.

4. Preview locally:
   ```bash
   mkdocs serve
   ```

5. Commit:
   ```bash
   git add -A
   git commit -m "Reorganize portfolio by theme, restyle to editorial/zine"
   git push
   ```

## What changed

- **Navigation** is now grouped into six themed tabs (Foundations, Code &
  Logic, Inputs & Control, Sensing the World, Going Wireless, Capstone)
  instead of nine week folders.
- Every page keeps a small rotated **stamp tag** under the title (e.g.
  `Week 05 · Monday`) so you can still trace it back to when it was
  originally logged.
- **Styling** moved from the dark CRT/terminal look to a warm,
  cream-paper editorial/zine theme: `Fraunces` for headings, `Literata`
  for body text, `Space Mono` for code, with washi-tape code labels,
  a "FIELD NOTE" stamp on blockquotes, and a torn-paper card for the
  main content area.
- The nine empty placeholder files (`week07/wednesday.md`,
  `week07/friday.md`, `week08/*`, `week09/monday.md`,
  `week09/wednesday.md`, `week09/friday.md`) were dropped since they had
  no content — re-add them under whichever theme folder fits once you've
  written them.
