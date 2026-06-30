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

### Editor: Vim -> Neovim (LazyVim)
- LazyVim starter is **vendored** into `config/nvim` (git history stripped) so plugins are version-pinned via `lazy-lock.json`, not refetched at install.
- Overrides preserve muscle memory: leader = comma (`options.lua`), `jk` -> Esc, centered search jumps, `Y` to end of line (`keymaps.lua`), 2-space indent + system clipboard.
- `vim-tmux-navigator` plugin added so `C-h/j/k/l` moves across nvim splits and tmux panes, matching the kept tmux side.
- Solarized colorscheme via `solarized-osaka.nvim`.
- Old plugins map to LazyVim built-ins: CtrlP -> Telescope, NERDTree -> neo-tree, coc.nvim -> native LSP, airline -> lualine, fugitive/gitgutter -> gitsigns + lazygit.

### Multiplexer: tmux (kept verbatim)
- `home/tmux.conf` is the old config byte-for-byte. The one external dependency it has, `reattach-to-user-namespace`, is installed via the Brewfile rather than editing the file.
- Optional later tweak (not applied, to honor "keep it untouched"): switch `default-terminal` to `tmux-256color` and add a truecolor override for richer nvim colors inside tmux.

## Manual steps after setup.sh

1. Set Ghostty as default terminal, quit iTerm2.
2. Launch `nvim` once so LazyVim installs plugins.
3. `nvm alias default 24`.
4. Open a fresh shell (`exec zsh`).
5. Create `~/.zsh_secrets` from the template and fill in real values.
