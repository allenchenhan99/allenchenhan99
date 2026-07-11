# Text-First Profile README Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the visual Metrics-based profile with a concise text-first GitHub Profile README for Allen.

**Architecture:** The profile repository will become static Markdown only. The README carries the professional positioning, while the Metrics workflow and generated SVG are removed because no generated visual asset is part of the approved design.

**Tech Stack:** GitHub Profile README, Bash contract validation, GitHub CLI

## Global Constraints

- Keep the approved copy exact unless the user gives new wording.
- Do not add badges, GitHub stats cards, radar charts, contribution calendars, or banners.
- Do not claim completed degree credentials beyond the confirmed Mathematics and Data Science background.
- Use `apply_patch` for manual file edits.
- Preserve existing historical design and implementation docs.

---

## File Structure

- `README.md`: the public GitHub profile README shown on the Overview page.
- `tests/profile_contract.sh`: validates that the profile README follows the approved text-first contract and that token-like secrets are not committed.
- `.github/workflows/metrics.yml`: delete; no generated Metrics asset is needed.
- `metrics.plugin.isocalendar.svg`: delete; no longer embedded or generated.
- `docs/plans/2026-07-11-text-first-profile-readme-design.md`: already committed design record.
- `docs/superpowers/plans/2026-07-11-text-first-profile-readme.md`: this implementation plan.

### Task 1: Replace Metrics profile with text-first README

**Files:**
- Modify: `README.md`
- Modify: `tests/profile_contract.sh`
- Delete: `.github/workflows/metrics.yml`
- Delete: `metrics.plugin.isocalendar.svg`
- Test: `tests/profile_contract.sh`

**Interfaces:**
- Consumes: the approved copy from `docs/plans/2026-07-11-text-first-profile-readme-design.md`
- Produces: a static README with no generated Metrics dependency

- [ ] **Step 1: Update the profile contract first**

Replace `tests/profile_contract.sh` with:

```bash
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
```

- [ ] **Step 2: Run the contract to verify it fails against the current profile**

Run:

```bash
./tests/profile_contract.sh
```

Expected: FAIL because `.github/workflows/metrics.yml` and `metrics.plugin.isocalendar.svg` still exist and README still contains the image embed.

- [ ] **Step 3: Replace README with approved copy**

Replace `README.md` with:

```md
### Hi, I'm Allen

My academic background spans Mathematics and Data Science. I currently focus on quantitative research, with broader research interests at the intersection of financial markets, statistical learning, and AI engineering.
```

- [ ] **Step 4: Remove generated Metrics files**

Run:

```bash
git rm .github/workflows/metrics.yml metrics.plugin.isocalendar.svg
```

- [ ] **Step 5: Run the contract to verify it passes**

Run:

```bash
./tests/profile_contract.sh
```

Expected: PASS and the three approved README text checks are printed by `rg`.

- [ ] **Step 6: Commit the local profile change**

Run:

```bash
git add README.md tests/profile_contract.sh docs/superpowers/plans/2026-07-11-text-first-profile-readme.md
git commit -m "feat: switch to text-first profile readme"
```

### Task 2: Publish cleanup to GitHub

**Files:**
- No file edits expected after Task 1

**Interfaces:**
- Consumes: the committed text-first README change from Task 1
- Produces: the public `allenchenhan99/allenchenhan99` profile showing the text-first README

- [ ] **Step 1: Push the branch**

Run:

```bash
git push origin main
```

Expected: push succeeds and the remote `main` branch contains the text-first README.

- [ ] **Step 2: Delete the unused repository secret**

Run:

```bash
gh secret delete METRICS_TOKEN --repo allenchenhan99/allenchenhan99
```

Expected: `gh` removes the secret or reports that no matching secret exists.

- [ ] **Step 3: Confirm no Metrics workflow remains on the remote**

Run:

```bash
gh workflow list --repo allenchenhan99/allenchenhan99
```

Expected: no active workflow named `Metrics` is listed after the deleted workflow is pushed.

- [ ] **Step 4: Confirm the public README content**

Run:

```bash
gh api repos/allenchenhan99/allenchenhan99/readme --jq .content | base64 --decode
```

Expected output:

```md
### Hi, I'm Allen

My academic background spans Mathematics and Data Science. I currently focus on quantitative research, with broader research interests at the intersection of financial markets, statistical learning, and AI engineering.
```

## Self-Review

- Spec coverage: the plan covers README replacement, Metrics workflow removal, generated SVG removal, contract validation, secret cleanup, push, and remote verification.
- Placeholder scan: no `TBD`, `TODO`, or unspecified implementation steps remain.
- Interface consistency: the approved README copy is identical across the design and implementation plan.
