# package-terminal-migration: Terminal & shell environment migration playbook

Shareability: internal

> `CLAUDE.md` and `GEMINI.md` are symlinks to this file. Edit `AGENTS.md` directly so Claude Code, Cursor, Codex CLI, and Gemini CLI all read identical content.

## What this is

A reproducible migration playbook for David's terminal and shell environment. The goal is one command (`setup.sh`) that stands up the whole stack on any fresh Mac, plus the research and decision notes that explain every choice.

Moving FROM:
- iTerm2 (terminal emulator)
- Oh My Zsh (zsh framework)
- Vim (editor)

Moving TO:
- Ghostty (GPU-accelerated terminal emulator)
- A fast zsh stack: antidote (plugin manager) + Starship (cross-shell prompt)
- Neovim with the LazyVim distro

Keeping:
- The existing tmux config, unchanged. tmux is the one piece that carries over as-is.

David already did this migration on another machine but lost access to it. This project reconstructs and documents every step so the whole environment can be re-run from scratch.

## Deliverables

- Per-tool research and decision notes under `research/` and `decisions/` (why Ghostty over iTerm2, why antidote over Oh My Zsh, why Starship, why LazyVim over a hand-rolled Neovim config).
- Captured dotfiles under `assets/` or `context/` (`.zshrc`, `.zsh_plugins.txt`, `starship.toml`, Ghostty `config`, Neovim/LazyVim overrides, the kept tmux config).
- A reproducible `setup.sh` at the project root that installs the toolchain (via Homebrew where possible) and drops the dotfiles into place idempotently.

## Tool routing

Google Workspace (Gmail / Drive / Calendar): `../../scripts/gws-multi.sh personal <command>` (account `dtothefp@gmail.com`). Always pass the `personal` alias so calls route to the right Google account.

Linear / Slack / Notion: not used for this project. Task tracking is local `TODO.md` only (no Notion hub by design).

## Branching rules

This is a cowork-tier project. **Work on `main` directly.** No feature branches, no worktrees. Branch only if David explicitly asks or for a structural decision (rename, shareability flip, directory restructure).

## Directory enforcement (strict)

Allowed paths: `assets/`, `context/`, `research/`, `content/`, `decisions/`, `notes/dfp/`, `.claude/`, `.obsidian/`, plus the root `setup.sh` deliverable and the three `.md` governance/agent files.

Never create ad-hoc directories (`tmp/`, `output/`, `data/`, etc.). Temp files go in `context/`. Captured dotfiles are deliverables, store them under `assets/` (or `context/` for working copies), referenced from research notes.

## Wiki layer (Karpathy pattern)

`research/` has three layers. Raw sources in topic subdirs (immutable), `research/index.md` as the curated entry point, `research/log.md` as the append-only changelog. New artifact: append one line to `log.md` and link it from `index.md` in the same session. Never edit a historical source, add a dated successor and mark the old one superseded. See `GOVERNANCE.md` for the full rules.

## Hard rules on this project

- **Idempotency is the point.** `setup.sh` must be safe to re-run. Guard every install and every dotfile copy so a second run does not clobber or duplicate.
- **Capture, don't guess.** Dotfiles in this repo should be the actual files David runs, captured verbatim, not reconstructed from memory or defaults.
- **tmux config is carried over untouched.** Document where it lives and how `setup.sh` restores it, but do not redesign it.
