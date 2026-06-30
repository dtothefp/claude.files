---
title: Do we still need the skwp Powerline fonts, and is Powerline the right tmux status bar in 2026
date: 2026-06-30
status: current
tags: [tmux, fonts, powerline, ghostty]
---

# Powerline fonts and the tmux status bar

## The question

The old setup installed three patched "for Powerline" fonts (from skwp/dotfiles,
the YADR set) into `~/Library/Fonts`. Now that the editor moved off vim-airline
to lualine and the prompt moved to Starship, are those fonts still needed?

## What actually consumes Powerline glyphs now

Three things historically wanted them. Two no longer do.

- **Editor (was vim-airline, now lualine).** lualine draws its separators from
  Nerd Font glyphs, which Ghostty covers with its bundled Nerd Font. No skwp
  font needed.
- **Prompt (was an OMZ theme, now Starship).** Starship's icons are Nerd Font
  private-use glyphs, again covered by Ghostty's fallback. No skwp font needed.
- **tmux status bar (unchanged).** This is the one that still needs a patched
  font, and only for two specific glyphs.

## The empirical finding

The kept tmux config uses five box-drawing arrows. Tested with
`fc-list :charset=<cp>`:

| Glyph | Codepoint | Used in | Covered by |
|-------|-----------|---------|------------|
| `⮃` | U+2B83 | `status-right` | 21 fonts incl. macOS Hiragino (system fallback) |
| `⮂` | U+2B82 | `status-right` | same system fallback |
| `⭤` | U+2B64 | (decorative) | same system fallback |
| `⮀` | U+2B80 | `window-status-current-format` | **only** the patched Powerline fonts (+ `.LastResort`) |
| `⮁` | U+2B81 | `window-status-current-format` | **only** the patched Powerline fonts (+ `.LastResort`) |

So the active-window separator (`⮀` ... `⮁`) is the single point of dependency.
Input Mono does not cover U+2B80/U+2B81. macOS system fonts do not. Ghostty's
bundled Nerd Font does not (Nerd Font separators live in the private-use area,
not at these legacy Unicode codepoints). Remove every patched font and that
separator degrades to `.LastResort` tofu, while the rest of the bar still
renders via Hiragino.

## Decision

Keep one patched font installed, vendored in the repo so the rebuild is
self-contained. `fonts/powerline/Inconsolata-dz-Powerline.otf` (SIL OFL,
redistributable) covers U+2B80/U+2B81 and is enough. `setup.sh` installs it if
no "for Powerline" font is present. Menlo-Powerline is deliberately not vendored
(Apple-proprietary base, not redistributable in a public repo).

## Is Powerline still the right choice for a tmux status bar in 2026

Short answer. The visual style is fine; the *legacy Unicode codepoints* are the
dated part. Worth knowing the landscape:

- **The original Powerline project** (the Python daemon that drove vim/tmux/shell
  prompts) is effectively dead. Nobody should adopt it new. This config does not
  use it, it only borrows Powerline's arrow *glyphs*, hardcoded as Unicode.
- **The modern default** is to render those same separators from **Nerd Font**
  private-use glyphs (`` U+E0B0, `` U+E0B2, plus the thin `` `` variants).
  Ghostty ships a Nerd Font and renders these natively, so a Nerd-Font-based bar
  needs zero extra font installs. This is where most setups have landed.
- **Modern tmux status frameworks**, if you ever want a richer bar than the
  hand-rolled one: catppuccin/tmux, dracula/tmux, tmux2k, or gitmux for a git
  segment. All assume Nerd Font glyphs, not the legacy codepoints.

### Recommendation

The current bar looks right and works, so there is no reason to touch it just to
modernize. But the *clean* end state, if David ever wants to drop the vendored
font entirely, is a two-character edit: swap `⮀`/`⮁` in
`window-status-current-format` for `` (U+E0B0) and `` (U+E0B2). Ghostty
renders those from its bundled Nerd Font with no external dependency, and the
other three arrows already have system fallback, so the whole skwp font set
could then be removed. That edits the otherwise-untouched tmux config, so it is
left as an explicit opt-in, not done silently here.
