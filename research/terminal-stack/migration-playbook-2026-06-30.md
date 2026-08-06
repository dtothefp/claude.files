---
title: Terminal/shell migration playbook
date: 2026-06-30
status: current
tags: [ghostty, zsh, antidote, starship, neovim, lazyvim, tmux]
---

# Migration playbook: iTerm2 + Oh My Zsh + Vim  ->  Ghostty + antidote/Starship + Neovim

The step-by-step reconstruction of the migration David did on a prior machine.
The whole thing is automated in `setup.sh`; this doc explains what each step does
and why, so it can be understood and debugged, not just run blindly.

## Starting point (captured 2026-06-30)

- macOS, Apple Silicon, Homebrew at `/opt/homebrew`, zsh 5.9.
- Old dotfiles repo: `~/dev/dotfiles` (`dtothefp/dotfiles`), holman-style `.symlink` topics linked into `~` by `scripts/symlink_dotfiles`. That scheme only links `~/.<name>`, so it could not reach `~/.config/<name>` XDG paths. This repo replaces it.
- Oh My Zsh loaded from machine-local `~/.zshrc.user` (theme `robbyrussell`, plugins `(git)` only). That file also mixed in live secrets (AWS keys, Apify/Terraform/ngrok tokens, an RDS password).
- Vim aliased to `mvim -v` (MacVim), vim-plug + coc.nvim + ~30 plugins, leader = comma.
- tmux config solid and already Neovim-aware (the `is_vim` regex matches nvim, vim-tmux-navigator wired both sides). Prefix `C-Space`, TPM + sensible/copycat/yank.
- iTerm2 installed. No Ghostty/Neovim/Starship/antidote/fzf/zoxide/eza/bat. Input fonts present (`InputMono` already in `~/Library/Fonts`, full family at `~/dev/Input-Font`). No Nerd Font.

## The seven steps (what setup.sh does)

1. **Homebrew check.** Bail with the install one-liner if `brew` is missing.
2. **`brew bundle`** from the `Brewfile`: ghostty (cask), antidote, starship, neovim, ripgrep, fd, lazygit, tmux, reattach-to-user-namespace, fzf, zoxide, eza, bat, git.
3. **Input font.** If `InputMono` is not already in `~/Library/Fonts`, copy from `~/dev/Input-Font/Input_Fonts`. Ghostty's `font-family = Input Mono`.
4. **Symlink** via `install/link.sh`: `home/*` -> `~/.*`, `config/*` -> `~/.config/*`. Existing files are backed up to `*.bak` first, so it is non-destructive.
5. **TPM** cloned to `~/.tmux/plugins/tpm` (the path the kept tmux config expects), then plugins installed.
6. **antidote bundle** primed: `~/.zsh_plugins.txt` compiled to `~/.zsh_plugins.zsh`.
7. **Secrets check.** Reminds you to create `~/.zsh_secrets` from `secrets/zsh_secrets.example`.

## Per-tool detail

### Terminal: iTerm2 -> Ghostty
- Config is a single file at `~/.config/ghostty/config`, `key = value`. Reload in-app with `cmd+shift+,`.
- Font: `Input Mono`. Ghostty bundles a Nerd Font and uses it as **symbol fallback**, so Starship and LazyVim icons render without patching Input. This is why no Nerd Font install is needed.
- Theme set to a Solarized Dark variant to match the old Vim colors. Verify the exact name with `ghostty +list-themes`.
- The old iTerm-level keymaps (shift-ctrl-hjkl to resize) are unnecessary: tmux does pane resize via its own prefix bindings, which are unchanged.

### Shell: Oh My Zsh -> antidote + Starship
- **antidote** replaces `oh-my-zsh.sh`. Plugin list in `~/.zsh_plugins.txt`, compiled once to a static `~/.zsh_plugins.zsh` and sourced flat (fast). The OMZ `git` aliases (`gst`, `gco`, ...) are kept by loading `ohmyzsh/ohmyzsh path:plugins/git` through antidote, so muscle memory survives without all of OMZ's load cost. Added: autosuggestions, syntax-highlighting, completions, history-substring-search.
- **Starship** replaces the `robbyrussell` theme. `~/.config/starship.toml` keeps the green arrow + git branch/status and adds command duration.
- `~/.zshrc` is rebuilt clean: Homebrew, secrets, history, options, cached compinit, antidote, modular `~/.config/zsh/*.zsh`, Starship, then zoxide/fzf init.
- **nvm is lazy-loaded** (stub functions in `functions.zsh` that source nvm on first use). Eager nvm sourcing was most of the old shell's startup lag. Set a default once with `nvm alias default 24`.
- **Keybindings restored (2026-06-30).** OMZ silently ran `bindkey -e` (emacs mode). The hand-rolled zshrc dropped it, so with `EDITOR=nvim` (the string contains "vi") zsh booted into vi-insert and Ctrl-P/Ctrl-N self-inserted a literal `^P` instead of walking history. Added `bindkey -e`, plus the Up/Down and Ctrl-P/Ctrl-N bindings for `zsh-history-substring-search`, which was loaded but never wired (so it did nothing). The bindings sit right after the antidote source block so the plugin's widgets already exist. On an empty line they walk history like before; with a typed prefix they cycle only matching commands.
- **fzf-tab completion (2026-06-30).** Tab listed candidates but didn't let you pick one (plain `menu select` needs a second Tab to enter the highlighted menu). Added `Aloxaf/fzf-tab` to `zsh_plugins.txt` (ordered after `zsh-completions`, before autosuggestions/syntax-highlighting, since those wrap the same ZLE widgets fzf-tab must wrap first) so Tab opens an fzf popup with fuzzy filter, preview, and Enter to select. Switched `zstyle ':completion:*' menu select` to `menu no` because `menu select` conflicts with fzf-tab, and added fzf-tab zstyles (eza directory preview with ls fallback, min-height 15, `<`/`>` to switch groups). antidote auto-rebuilds the bundle on next shell start (it clones fzf-tab once, needs network); `exec zsh` to apply.

### Editor: Vim -> Neovim (LazyVim)
- LazyVim starter is **vendored** into `config/nvim` (git history stripped) so plugins are version-pinned via `lazy-lock.json`, not refetched at install.
- Overrides preserve muscle memory: leader = comma (`options.lua`), `jk` -> Esc, centered search jumps, `Y` to end of line (`keymaps.lua`), 2-space indent + system clipboard.
- `vim-tmux-navigator` plugin added so `C-h/j/k/l` moves across nvim splits and tmux panes, matching the kept tmux side.
- Solarized colorscheme via `solarized-osaka.nvim`.
- Old plugins map to LazyVim built-ins: CtrlP -> Telescope, NERDTree -> neo-tree, coc.nvim -> native LSP, airline -> lualine, fugitive/gitgutter -> gitsigns + lazygit.
- Commenting (2026-06-30). The old vimrc used NERDCommenter, with `,cc` to comment a highlighted block and `,c<space>` to uncomment. Those keys were never ported, so a visual-mode `,cc` fell through to `c` (the change operator) and deleted the selection. Re-aliased `,cc` and `,c<space>` onto LazyVim's native `gc`/`gcc` toggle in `keymaps.lua` (with `remap = true`, since `gc` is an operator mapping, not a builtin command). Follow-up (2026-07-01): commenting then broke again, but only inside code files. Cause was a keymap collision, not a stale instance. LazyVim maps `<leader>cc` to Run Codelens under `servers['*'].keys` with `has = "codeLens"`, so it registers a BUFFER-LOCAL `,cc` on LspAttach for any server that supports codelens (vtsls does). A buffer-local map always beats a global one, so it silently shadowed our global `,cc` -> `gcc` alias the moment a `.ts`/`.tsx` buffer got an LSP, while plain files kept working. Fixed in `plugins/lsp.lua` by adding `servers['*'].keys = { { "<leader>cc", false } }`, LazyVim's documented way to delete a default keymap. Codelens run is niche; refresh/display stays on `<leader>cC`. Verified with vtsls attached: `,cc` resolves only to `gcc` and toggles a line's comment cleanly on each press.
- TypeScript LSP + format-on-save (2026-06-30). Stock LazyVim ships no language server, so hover (`K`), go-to-def, types, and diagnostics were all dead. Added the `lazyvim.plugins.extras.lang.typescript` extra in `lazy.lua`, which installs the `vtsls` server (it uses its own bundled TypeScript, so it coexists with the harness's TS 7 RC that ships no classic `tsserver.js`). Separately, format-on-save did nothing for TS because no formatter was registered. Added `plugins/conform.lua` pointing conform.nvim at `oxfmt` (the formatter the JS/TS harnesses run as `oxfmt --write .`), resolving the nearest `node_modules/.bin/oxfmt` upward so editor-save and the CLI agree, instead of the prettier the extra would otherwise wire up. Both are read at startup, so a full nvim restart (not `:Lazy reload`) is needed to pick them up.
- Tab-to-complete + inlay hints off (2026-07-01). Two related completion fixes. (1) LazyVim configures blink.cmp with the "enter" keymap preset, so only `<CR>` accepts a completion and `<Tab>` merely jumps snippet placeholders; Tab appeared to do nothing. Added `plugins/blink.lua` overriding the preset to "super-tab" (Tab select-and-accepts, `<CR>` still accepts) for VS Code / Cursor muscle memory. LazyVim's own blink config branches on the super-tab preset to wire the Tab fallback chain, so only the preset needed overriding. (2) The purple `(x : any) : void` annotations are vtsls inlay hints (virtual text, not real code, not completions), which read as confusing suggestions you can't accept. Added `plugins/lsp.lua` setting `inlay_hints = { enabled = false }` to turn them off by default; `<leader>uh` toggles them back per buffer.
- Indent guides off (2026-06-30). LazyVim's snacks.nvim draws dim `─ ─ ─` markers at each nesting level (virtual overlays, never written to the file). Disabled via `plugins/snacks.lua` (`indent` and `scope` both `enabled = false`). Delete that file to get the defaults back.
- Whitespace dashes off + clipboard provider (2026-06-30). Two `options.lua` fixes. (1) LazyVim sets `opt.list = true`, which renders trailing whitespace and tabs as `-` dashes (visible in normal mode, hidden on the cursor line in insert mode); set `opt.list = false` to clear them. This is separate from the snacks vertical indent guides disabled in `plugins/snacks.lua`. (2) With `clipboard = "unnamedplus"` and no provider pinned, inside tmux/Ghostty Neovim auto-selects a write-only OSC52 provider, so yanks reach the system clipboard but `p` can't read them back and in-editor `yy`->`p` breaks. Pinned `vim.g.clipboard` to bidirectional `pbcopy`/`pbpaste` (guarded on `executable()` so SSH falls back to the default). Both load at startup, so a full nvim restart is needed.
- Multiple cursors (2026-06-30). The old setup used `Ctrl-N` to select the word under the cursor and cycle through next matches (Sublime / VS Code Cmd-D). Neovim core and stock LazyVim have no multi-cursor, so added `plugins/visual-multi.lua` (`mg979/vim-visual-multi`); `<C-n>` does Find-Under, then `c`/`i`/`s` edits all stacked cursors at once. `<C-n>` is normal/visual mode only, so it doesn't collide with insert-mode completion or the shell's Ctrl-N history binding.
- Claude Code in the editor (2026-06-30). Added `plugins/claudecode.lua` (`coder/claudecode.nvim`), which speaks the same WebSocket IDE protocol as the official VS Code / JetBrains extensions, so the `claude` CLI attaches to nvim for the Cursor "select lines and ask" workflow (auto-shares the visual selection and LSP diagnostics, renders Claude's edits as native diffs). Keys live under `<leader>i` ("AI"), not the plugin's default `<leader>a`, because `<leader>a` is already the tabular alignment group in `keymaps.lua`; the headline bind is visual-mode `<leader>is` to send a selection. It's a keybind, not an always-on assistant, so AI-free practice (e.g. the no-AI Hadrian round) just means not opening the pane.

### Multiplexer: tmux (kept verbatim)
- `home/tmux.conf` is the old config byte-for-byte. The one external dependency it has, `reattach-to-user-namespace`, is installed via the Brewfile rather than editing the file.
- Truecolor (applied 2026-06-30 at David's request): `default-terminal` switched from `screen-256color` to `tmux-256color`, plus `set -ga terminal-features ",xterm-ghostty:RGB"`. nvim now renders full 24-bit color inside tmux. It depends on the xterm-ghostty terminfo from setup.sh step 3c.
- Clipboard interop (applied 2026-06-30 at David's request): added `set -g set-clipboard on` and appended `:clipboard` to the xterm-ghostty `terminal-features`. This forwards copy-mode and in-tmux app clipboard writes to Ghostty over OSC52, so yanks reach the macOS pasteboard locally (via the copy-mode `y` -> pbcopy bind) and over SSH (via OSC52). Together with truecolor these are two of the deliberate edits to the otherwise-verbatim tmux config (see the mouse-selection and plugin notes below). The `terminal-features:clipboard` change is read at server start, so a full `tmux kill-server` (not just a config source) is needed to pick it up.
- Mouse selection + plugins dropped (2026-06-30 at David's request). The TPM plugins (sensible, copycat, yank) and the `run tpm` line are commented out, so tmux now runs plugin-free. With tmux-yank gone, a mouse drag uses tmux's built-in `copy-selection-and-cancel`, whose cancel cleared the highlight the instant you released the mouse (unlike a native terminal selection, which persists). Added `bind-key -T copy-mode-vi MouseDragEnd1Pane send -X copy-selection-no-clear` so the drag copies to the clipboard (set-clipboard on) but keeps the highlight up; press q or Escape to leave copy-mode. The bind is plugin-independent, so no TPM is needed. Follow-up: `setup.sh` step 5 still clones TPM and installs plugins, now a no-op worth removing in a later pass.
- **Gotcha (2026-06-30): tmux fails to start under Ghostty with "open terminal failed: not a terminal."** Cause is the missing `xterm-ghostty` terminfo. Ghostty sets `TERM=xterm-ghostty` and ships the terminfo inside its app bundle, but does not install it into the user terminfo db, so tmux's client can't initialize the terminal. Fix is to recompile the bundled entry into `~/.terminfo` (`TERMINFO_DIRS=/Applications/Ghostty.app/Contents/Resources/terminfo infocmp -x xterm-ghostty | tic -x -o ~/.terminfo -`). Now done automatically as step 3c of `setup.sh`. Fallback if the app bundle is absent: set `term = xterm-256color` in the Ghostty config.

## Manual steps after setup.sh

1. Set Ghostty as default terminal, quit iTerm2.
2. Launch `nvim` once so LazyVim installs plugins.
3. `nvm alias default 24`.
4. Open a fresh shell (`exec zsh`).
5. Create `~/.zsh_secrets` from the template and fill in real values.
