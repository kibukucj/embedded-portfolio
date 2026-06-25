#!/usr/bin/env bash
# Run this from the ROOT of your actual portfolio repo (where mkdocs.yml lives).
# It renames/moves your existing week-based files into the new theme-based folders
# using `git mv`, so history is preserved. Empty placeholder files are deleted.

set -e

mkdir -p docs/foundations docs/code-and-logic docs/inputs-and-control \
         docs/sensing-the-world docs/going-wireless docs/capstone

# Foundations
git mv docs/week01/friday.md         docs/foundations/portfolio-setup.md
git mv docs/week02/wednesday.md      docs/foundations/hardware-fundamentals.md
git mv docs/week02/friday.md         docs/foundations/architecture-bare-metal.md
git mv docs/week02/monday.md         docs/foundations/version-control.md

# Code & Logic
git mv docs/week02/assignment.md     docs/code-and-logic/oop-shapes-python.md
git mv docs/week03/monday.md         docs/code-and-logic/c-fundamentals.md
git mv docs/week03/wednesday.md      docs/code-and-logic/modular-c-compilation.md
git mv docs/week04/monday.md         docs/code-and-logic/data-structures-memory.md

# Inputs & Control
git mv docs/week05/monday.md         docs/inputs-and-control/buttons-state-logic.md
git mv docs/week06/extra.md          docs/inputs-and-control/traffic-light-controller.md

# Sensing the World
git mv docs/week04/wednesday.md      docs/sensing-the-world/dht22-temperature-humidity.md
git mv docs/week06/wednesday.md      docs/sensing-the-world/ultrasonic-distance.md

# Going Wireless
git mv docs/week05/wednesday.md      docs/going-wireless/serial-protocols.md
git mv docs/week06/monday.md         docs/going-wireless/picow-wifi-init.md

# Capstone
git mv docs/week09/proposal.md       docs/capstone/iot-irrigation-proposal.md

# Empty placeholder files (never had content) — remove. Comment these out
# if you'd rather keep them as drafts for future weeks.
git rm -f docs/week07/wednesday.md docs/week07/friday.md \
          docs/week08/monday.md docs/week08/wednesday.md docs/week08/friday.md \
          docs/week09/monday.md docs/week09/wednesday.md docs/week09/friday.md \
          2>/dev/null || true

# Remove now-empty week folders (git won't track empty dirs anyway, this just tidies the working tree)
rmdir docs/week01 docs/week02 docs/week03 docs/week04 docs/week05 \
      docs/week06 docs/week07 docs/week08 docs/week09 2>/dev/null || true

echo "Done. Now copy in the new mkdocs.yml and docs/stylesheets/extra.css,"
echo "review with 'mkdocs serve', then commit:"
echo "  git add -A && git commit -m 'Reorganize portfolio by theme, restyle to editorial/zine'"
