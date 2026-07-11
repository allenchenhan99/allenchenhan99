# Text-First Profile README Design

## Goal

Replace the visual-first GitHub Profile README with a concise, text-first overview that presents Allen as a professional quantitative research and AI engineering profile.

## Approved Direction

Use a minimal researcher-style introduction rather than generated metrics cards, contribution graphics, badges, or decorative banners. The profile should make the professional signal clear in the first few lines and let repositories carry the deeper proof.

Approved profile copy:

```md
### Hi, I'm Allen

My academic background spans Mathematics and Data Science. I currently focus on quantitative research, with broader research interests at the intersection of financial markets, statistical learning, and AI engineering.
```

## Rationale

The prior isometric contribution calendar was visually dominant and did not communicate the user's target positioning as directly as a short, well-written introduction. A text-first README is closer to the professional profiles reviewed during brainstorming: it is restrained, fast to read, and avoids making activity graphics the main signal.

## Scope

- Replace the README image embed with the approved text.
- Remove the generated `metrics.plugin.isocalendar.svg` asset.
- Remove the Metrics GitHub Actions workflow because the profile will no longer use the isometric calendar.
- Update the profile contract test so it validates the new text-first README and guards against accidentally reintroducing generated metrics assets or token-like secrets.
- Clean up the repository secret `METRICS_TOKEN` after the workflow is removed.

## Non-Goals

- Do not add badges, GitHub stats cards, radar charts, contribution calendars, or banners in this iteration.
- Do not claim specific degree completion status beyond the confirmed academic background.
- Do not add contact links, CV links, or pinned repository guidance until the user explicitly chooses that next layer.

## Success Criteria

- `README.md` starts with `### Hi, I'm Allen`.
- The README includes the approved Mathematics, Data Science, quantitative research, financial markets, statistical learning, and AI engineering wording.
- The README does not embed Metrics SVGs, isometric calendars, or external stat cards.
- No Metrics workflow or generated SVG remains in the profile repository.
- The local contract test passes.
