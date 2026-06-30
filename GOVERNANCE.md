# Research Governance

This project's `research/` follows the Karpathy three-layer wiki pattern:

1. **Raw sources** (topic subdirs) are immutable. Never edit historical files; add dated successors and mark the old file as superseded.
2. **`research/index.md`** is the curated entry point. A short topic map linking to raw sources. Update it when conclusions change.
3. **`research/log.md`** is an append-only changelog. One line per new artifact (date, title, link).

## Rules

- New artifact: append to `log.md` AND link from `index.md` in the same session.
- Keep index entries short. If a topic balloons past a few paragraphs, split it into its own file.
- Raw files are write-once. To amend, add a new dated file and mark the old one superseded in `index.md`.
- Orphan detection: files on disk not linked from any `index.md` are orphans. Run `wiki-reconcile` to find them.

## Branching

Cowork-tier project. Work on `main` directly. No feature branches, no worktrees, unless a structural change is requested.

## Scope

This governance applies only to this project's `research/`. If this repo was cloned standalone from the parent cowork workspace, these rules are self-contained and do not require parent context.
