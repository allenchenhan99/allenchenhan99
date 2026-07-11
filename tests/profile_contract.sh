#!/usr/bin/env bash
set -euo pipefail

workflow=".github/workflows/metrics.yml"

test -f README.md
test -f "$workflow"

rg -F 'src="/metrics.plugin.isocalendar.svg"' README.md
rg -F 'alt="Full-year isometric GitHub contribution calendar for AllenLin"' README.md
rg -F 'uses: lowlighter/metrics@latest' "$workflow"
rg -F 'filename: metrics.plugin.isocalendar.svg' "$workflow"
rg -F 'token: ${{ secrets.METRICS_TOKEN }}' "$workflow"
rg -F 'user: allenchenhan99' "$workflow"
rg -F 'base: ""' "$workflow"
rg -F 'plugin_isocalendar: yes' "$workflow"
rg -F 'plugin_isocalendar_duration: full-year' "$workflow"
rg -F 'contents: write' "$workflow"
rg -F 'workflow_dispatch:' "$workflow"
rg -F 'cron: "0 0 * * *"' "$workflow"

ruby -e 'require "yaml"; YAML.safe_load(File.read(ARGV.fetch(0)), aliases: true)' "$workflow"

if git grep -En 'github_pat_|gh[pousr]_[A-Za-z0-9]+' -- ':!tests/profile_contract.sh' ':!docs/**'; then
  echo "A GitHub token-like value is present in tracked content" >&2
  exit 1
fi
