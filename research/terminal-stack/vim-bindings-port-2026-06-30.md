---
title: Porting the old Vim bindings into LazyVim
date: 2026-06-30
status: current
tags: [neovim, lazyvim, keymaps, migration]
---

# Old vimrc bindings, ported to Neovim/LazyVim

Source of truth for what came across from `~/dev/dotfiles/vim/vimrc.symlink`,
what LazyVim already covers natively, and what was deliberately dropped. The
live config is `config/nvim/lua/config/keymaps.lua` plus the `fugitive.lua` and
`tabular.lua` plugin specs.

## Ported (now in keymaps.lua)

| Old binding | Behavior | Notes |
|---|---|---|
| `imap jk <Esc>` | exit insert | |
| `j`/`k` -> `gj`/`gk` | move by display line | made count-aware (`5j` still works) |
| `Y` -> `y$` | yank to EOL | |
| `n`/`N` -> `nzzzv` | centered search | |
| `* ` -> `*<c-o>` | search word, stay put | |
| `< `/`>` (visual) | shift, keep selection | |
| `<leader>P` | paste system clipboard | |
| `zl`/`zh` -> `zL`/`zH` | horizontal scroll | |
| `<leader>r` | `:checktime` reload buffers | |
| `<leader>d` (NERDTreeTabsToggle) | toggle file tree | LazyVim 16 ships the Snacks explorer (not neo-tree); `<leader>d`/`<leader>v` both remap to `<leader>e`. Explorer keys remapped to NERDTree habits in `plugins/snacks-explorer.lua` (`o` open/toggle, `s` vsplit, `i` split, `t` tab, `R` refresh) since stock `o` was bound to system-open. Same spec also binds `<C-h/j/k/l>` in the explorer to the TmuxNavigate commands, because Snacks stole `<c-j>`/`<c-k>` for list scrolling and the left-edge `<C-h>` handoff into the tmux pane was unreliable from the tree |
| `<S-h>`/`<S-l>` -> `gT`/`gt` | prev/next tab | OVERRIDES LazyVim's S-h/S-l buffer cycling |
| `<c-w>;` + lasttab autocmd | jump to last tab | |
| `<leader>+`/`-`/`L`/`H` | resize splits | LazyVim also has `<C-arrows>` |
| `%%` + `<leader>e{w,s,v,t}` | edit file in current dir | |
| `<leader>ve` | edit init.lua | was `$MYVIMRC` |
| `cwd`/`cd.` cabbrev, `w!!` sudo-write | command-line helpers | |
| `:W :Wq :WQ :Wa :WA :Q :QA :Qa :E` | shouty-typo command fixes | |
| `<leader>g{s,d,c,b,l,p}` | fugitive git | added `tpope/vim-fugitive`; overrides gitsigns on `<leader>gb` |
| `<leader>a{&,=,:,::,comma,bar,-}` | tabular align | added `godlygeek/tabular` |
| coc `gi`, `[g`/`]g`, `<leader>rn`, `<leader>qf`, `<leader>cl` | LSP impl/diag/rename/fix/codelens | rebound to native LSP, set on LspAttach |

## Already native in LazyVim (not re-declared)

- `<C-h/j/k/l>` split+tmux nav: handled by `vim-tmux-navigator` (own spec).
- `gd`/`gr`/`gy`/`K` and `]d`/`[d`: LazyVim LSP defaults (kept; added `gi`,`[g`,`]g` as the old aliases).
- CtrlP (`<D-t>`/`<D-r>`): replaced by Telescope (`<leader>ff`, `<leader>fr`).
- `if`/`af`/`ic`/`ac` function/class text objects: provided by mini.ai.
- Completion `<cr>`/`<tab>`: handled by LazyVim's completion engine, not coc.

## Deliberately dropped

- `[F`/`[H` home/end terminal hacks: artifacts of GNU screen / old terminals, irrelevant under Ghostty.
- Emmet `<c-g>` leader: no emmet plugin installed (add `mattn/emmet-vim` if HTML work needs it).
- `<leader>f` IndentLinesToggle and `<leader>w` StripWhitespace: both collide with LazyVim's `<leader>f` (find) and `<leader>w` (window) groups. Indent guides ship on by default (toggle under `<leader>u`); trailing whitespace is handled by format-on-save (conform).
- coc `<space>`-prefixed CocList UI (diagnostics/extensions/commands/outline/symbols): replaced by Telescope under `<leader>s`.
- `<C-s>` coc range-select, coc completion plumbing: coc-specific, gone with the LSP move.
- `<leader>sv` source vimrc: not meaningful for a Lua config; restart or `:Lazy reload`.

## Open follow-ups

- vim-surround muscle memory (`cs"'`, `ds"`, `ysiw)`): LazyVim ships mini.surround
  with different keys (`gsa`/`gsd`/`gsr`). If the old `ys`/`cs`/`ds` are wanted,
  either add `tpope/vim-surround` or remap mini.surround. Left out for now since
  the old vimrc declared no explicit surround mappings.
