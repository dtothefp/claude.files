---
title: Neovim via vendored LazyVim, leader kept as comma
date: 2026-06-30
status: accepted
---

# 0002: Neovim + LazyVim, leader = comma

## Context

The old editor was Vim (MacVim) with vim-plug, coc.nvim, and ~30 plugins, leader
set to comma. Moving to Neovim, the choice was a distro vs a hand-rolled config.

## Decision

- **LazyVim**, vendored into `config/nvim` with its git history stripped, so the
  plugin set is version-pinned via `lazy-lock.json` and reproducible. It gets to
  a working IDE (LSP, treesitter, Telescope, neo-tree) immediately and maps
  cleanly onto the old plugin set.
- **Leader stays comma**, set in `lua/config/options.lua` before any plugin
  loads. LazyVim defaults to space, but preserving the old muscle memory won out.
  The trade-off is accepted: some LazyVim docs and which-key groups assume space.
- Old habits preserved: `jk` -> Esc, centered search jumps, `Y` to end of line,
  2-space indent, system clipboard.
- `vim-tmux-navigator` added so `C-h/j/k/l` crosses nvim splits and tmux panes,
  matching the kept tmux config.

## Old-plugin mapping

CtrlP -> Telescope, NERDTree -> neo-tree, coc.nvim -> native LSP, airline ->
lualine, fugitive/gitgutter -> gitsigns + lazygit, solarized -> solarized-osaka.

## Consequences

If the comma leader causes friction against LazyVim defaults over time, flipping
to space is a one-line change in `options.lua`. Everything else stays.
