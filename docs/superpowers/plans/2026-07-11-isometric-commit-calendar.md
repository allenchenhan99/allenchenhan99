# Isometric Commit Calendar Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Publish a GitHub Profile README for `allenchenhan99` that displays a daily refreshed, full-year isometric contribution calendar including eligible private contribution counts.

**Architecture:** A public profile repository contains a small README and a GitHub Actions workflow. The workflow invokes the stable `lowlighter/metrics@latest` action with only the isocalendar plugin enabled, writes a repository-local SVG, and uses an encrypted `METRICS_TOKEN` repository secret for contribution data.

**Tech Stack:** GitHub Profile README, GitHub Actions YAML, `lowlighter/metrics`, Bash contract validation, GitHub CLI

## Global Constraints

- The public repository name must be exactly `allenchenhan99/allenchenhan99`.
- The calendar duration must be `full-year`.
- Eligible private contribution counts must be included without exposing private repository names or content.
- The token must exist only as the encrypted repository secret `METRICS_TOKEN` and must never be committed or printed.
- This iteration must contain only the calendar; banners, badges, prose sections, and other metric plugins remain out of scope.
- The workflow must run daily, allow manual execution, and avoid rerunning when its generated SVG is committed.

---

## File map

- `README.md`: centers and displays the generated calendar on the GitHub Overview.
- `.github/workflows/metrics.yml`: schedules and configures the Metrics isocalendar render.
- `tests/profile_contract.sh`: checks the README/workflow contract and guards against committed GitHub token formats.
- `docs/plans/2026-07-11-isometric-commit-calendar-design.md`: records the approved design.
- `docs/superpowers/plans/2026-07-11-isometric-commit-calendar.md`: records this execution plan.

### Task 1: Add an executable profile contract test

**Files:**
- Create: `tests/profile_contract.sh`
- Test: `tests/profile_contract.sh`

**Interfaces:**
- Consumes: the planned paths `README.md` and `.github/workflows/metrics.yml`
- Produces: a zero exit status only when the profile embed and Metrics configuration satisfy the approved contract

- [ ] **Step 1: Create the contract test before the profile files exist**

```bash
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
```

- [ ] **Step 2: Make the validator executable and run it to verify it fails**

Run:

```bash
chmod +x tests/profile_contract.sh
./tests/profile_contract.sh
```

Expected: FAIL because `README.md` does not exist yet.

### Task 2: Add the minimal README and full-year Metrics workflow

**Files:**
- Create: `README.md`
- Create: `.github/workflows/metrics.yml`
- Test: `tests/profile_contract.sh`

**Interfaces:**
- Consumes: encrypted repository secret `METRICS_TOKEN`
- Produces: `metrics.plugin.isocalendar.svg`, committed by the Metrics action and embedded by `README.md`

- [ ] **Step 1: Create the minimal profile README**

```markdown
<p align="center">
  <picture>
    <img src="/metrics.plugin.isocalendar.svg" alt="Full-year isometric GitHub contribution calendar for AllenLin" width="100%">
  </picture>
</p>
```

- [ ] **Step 2: Create the Metrics workflow**

```yaml
name: Metrics

on:
  schedule:
    - cron: "0 0 * * *"
  workflow_dispatch:
  push:
    branches:
      - main
    paths:
      - ".github/workflows/metrics.yml"

jobs:
  isometric-calendar:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - name: Generate full-year isometric calendar
        uses: lowlighter/metrics@latest
        with:
          filename: metrics.plugin.isocalendar.svg
          token: ${{ secrets.METRICS_TOKEN }}
          user: allenchenhan99
          base: ""
          plugin_isocalendar: yes
          plugin_isocalendar_duration: full-year
```

- [ ] **Step 3: Run the profile contract**

Run:

```bash
./tests/profile_contract.sh
```

Expected: PASS with exit status 0; matching contract lines are printed and no token warning appears.

- [ ] **Step 4: Inspect and commit the implementation**

Run:

```bash
git diff --check
git status -sb
git add README.md .github/workflows/metrics.yml tests/profile_contract.sh docs/superpowers/plans/2026-07-11-isometric-commit-calendar.md
git commit -m "feat: add full-year isometric calendar"
```

Expected: one commit containing only the README, workflow, validator, and implementation plan.

### Task 3: Authenticate and publish the profile repository

**Files:**
- No file changes

**Interfaces:**
- Consumes: an authenticated `gh` session for `allenchenhan99`
- Produces: public GitHub repository `allenchenhan99/allenchenhan99` with local `main` pushed to `origin`

- [ ] **Step 1: Confirm GitHub CLI availability and authentication**

Run:

```bash
gh --version
gh auth status
```

Expected: `gh` is installed and the active `github.com` account is `allenchenhan99`. If authentication is invalid, run `gh auth login -h github.com -w` and complete the browser authorization without printing a token.

- [ ] **Step 2: Create the public profile repository and push `main`**

Run:

```bash
gh repo create allenchenhan99/allenchenhan99 --public --source=. --remote=origin --push
```

Expected: repository URL `https://github.com/allenchenhan99/allenchenhan99`, an `origin` remote, and `main` tracking `origin/main`.

### Task 4: Configure private contribution access and run Metrics

**Files:**
- No file changes

**Interfaces:**
- Consumes: a least-privilege personal access token entered interactively and GitHub's "Include private contributions on my profile" setting
- Produces: encrypted repository secret `METRICS_TOKEN` and the first successful Metrics render

- [ ] **Step 1: Confirm private contributions are enabled on the public profile**

Open `https://github.com/settings/profile` and ensure "Include private contributions on my profile" is enabled. This setting exposes counts only, not private repository identities.

- [ ] **Step 2: Create a least-privilege Metrics token**

Create a personal access token from `https://github.com/settings/tokens` for Metrics. Leave classic-token scopes unchecked for the initial isocalendar-only workflow, matching the Metrics plugin's documented scopeless support. Do not paste the token into a file or chat.

- [ ] **Step 3: Store the token without echoing it**

Run:

```bash
gh secret set METRICS_TOKEN --repo allenchenhan99/allenchenhan99
```

Expected: the command prompts for the secret value and confirms `METRICS_TOKEN` was set without displaying it.

- [ ] **Step 4: Trigger the workflow and watch it complete**

Run:

```bash
gh workflow run Metrics --repo allenchenhan99/allenchenhan99
gh run list --workflow Metrics --repo allenchenhan99/allenchenhan99 --limit 1
gh run watch --repo allenchenhan99/allenchenhan99 --exit-status
```

Expected: the latest `Metrics` run finishes with `success` and commits `metrics.plugin.isocalendar.svg` to `main`.

### Task 5: Verify the public Overview

**Files:**
- No file changes

**Interfaces:**
- Consumes: public GitHub repository and generated SVG
- Produces: evidence that the requested Overview calendar is live

- [ ] **Step 1: Update the local checkout after the Action commit**

Run:

```bash
git pull --ff-only
```

Expected: `metrics.plugin.isocalendar.svg` is added locally with a fast-forward update.

- [ ] **Step 2: Re-run local validation and inspect the SVG**

Run:

```bash
./tests/profile_contract.sh
test -s metrics.plugin.isocalendar.svg
git status -sb
```

Expected: validation passes, the SVG is non-empty, and `main` is clean and synchronized with `origin/main`.

- [ ] **Step 3: Verify public URLs**

Open:

```text
https://github.com/allenchenhan99/allenchenhan99/blob/main/metrics.plugin.isocalendar.svg
https://github.com/allenchenhan99
```

Expected: the SVG renders and the full-year isometric calendar appears at the top of the public Overview.
