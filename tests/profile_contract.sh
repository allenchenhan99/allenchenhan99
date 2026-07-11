#!/usr/bin/env bash
set -euo pipefail

test -f README.md
test ! -f .github/workflows/metrics.yml
test ! -f metrics.plugin.isocalendar.svg

rg -F "### Hi, I'm Allen" README.md
rg -F "My academic background spans Mathematics and Data Science." README.md
rg -F "I currently focus on quantitative research, with broader research interests at the intersection of financial markets, statistical learning, and AI engineering." README.md

if rg -n 'metrics|isocalendar|isometric|github-readme-stats|src="|<img|<picture' README.md; then
  echo "README.md contains a generated metrics or image embed that is outside the approved text-first design" >&2
  exit 1
fi

if git grep -En 'github_pat_|gh[pousr]_[A-Za-z0-9]+' -- ':!tests/profile_contract.sh' ':!docs/**'; then
  echo "A GitHub token-like value is present in tracked content" >&2
  exit 1
fi
