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

**This package IS David's new dotfiles repo.** It is structured as a clonable dotfiles repo (clean top-level layout, real configs, one `setup.sh`) and will be pushed to GitHub. It supersedes the old `~/dev/dotfiles` (the holman-style `.symlink` repo at `dtothefp/dotfiles`).

## Layout

The actual dotfiles live in a conventional, clonable structure (not buried under `assets/`):

- `home/` maps to `~/.<name>`. So `home/zshrc` -> `~/.zshrc`, `home/tmux.conf` -> `~/.tmux.conf`, `home/zsh_plugins.txt` -> `~/.zsh_plugins.txt`.
- `config/` maps to `~/.config/<name>`. So `config/ghostty` -> `~/.config/ghostty`, `config/nvim` -> `~/.config/nvim` (vendored LazyVim), `config/zsh` -> `~/.config/zsh`, `config/starship.toml` -> `~/.config/starship.toml`.
- `install/link.sh` is the XDG-aware symlink engine (backs up anything it would overwrite to `*.bak`).
- `Brewfile` is the declarative install list. `setup.sh` (root) is the idempotent orchestrator.
- `secrets/zsh_secrets.example` is the template for machine-local secrets. The real file lives at `~/.zsh_secrets` and is never committed.

## Deliverables

- The clonable dotfiles tree above plus a reproducible `setup.sh` that installs the toolchain (Homebrew) and links everything idempotently.
- Per-tool research and decision notes under `research/` and `decisions/` (why Ghostty over iTerm2, why antidote over Oh My Zsh, why Starship, why LazyVim over a hand-rolled Neovim config). Documenting the dotfiles is part of the repo.

## Tool routing

Google Workspace (Gmail / Drive / Calendar): `../../scripts/gws-multi.sh personal <command>` (account `dtothefp@gmail.com`). Always pass the `personal` alias so calls route to the right Google account.

Linear / Slack / Notion: not used for this project. Task tracking is local `TODO.md` only (no Notion hub by design).

## Branching rules

This is a cowork-tier project. **Work on `main` directly.** No feature branches, no worktrees. Branch only if David explicitly asks or for a structural decision (rename, shareability flip, directory restructure).

## Directory enforcement (strict)

Allowed paths: the dotfiles tree (`home/`, `config/`, `install/`, `secrets/`), root files (`setup.sh`, `Brewfile`), plus the cowork wiki/governance dirs (`context/`, `research/`, `content/`, `decisions/`, `notes/dfp/`, `assets/`, `.claude/`, `.obsidian/`) and the three `.md` governance/agent files.

Never create ad-hoc directories (`tmp/`, `output/`, `data/`, etc.). Temp files go in `context/`. The dotfiles themselves are the deliverable and live in `home/` and `config/`, not `assets/`.

## Wiki layer (Karpathy pattern)

`research/` has three layers. Raw sources in topic subdirs (immutable), `research/index.md` as the curated entry point, `research/log.md` as the append-only changelog. New artifact: append one line to `log.md` and link it from `index.md` in the same session. Never edit a historical source, add a dated successor and mark the old one superseded. See `GOVERNANCE.md` for the full rules.

## Hard rules on this project

- **Idempotency is the point.** `setup.sh` must be safe to re-run. Guard every install and every dotfile copy so a second run does not clobber or duplicate.
- **Capture, don't guess.** Dotfiles in this repo should be the actual files David runs, captured verbatim, not reconstructed from memory or defaults.
- **tmux config is carried over untouched.** Document where it lives and how `setup.sh` restores it, but do not redesign it.
