# TODO, terminal-migration (dotfiles)

This package IS David's new dotfiles repo. Local-only for now (no remote yet).
Cowork tier works on `main` directly.

## Done

- [x] Captured current environment (old `~/dev/dotfiles`, OMZ config, tmux, vimrc, fonts).
- [x] Built the clonable dotfiles tree (`home/`, `config/`, `install/`, `secrets/`).
- [x] zsh stack: `home/zshrc`, `home/zsh_plugins.txt`, `config/zsh/{aliases,exports,functions}.zsh`.
- [x] Ghostty config (`config/ghostty/config`, font Input Mono).
- [x] Starship prompt (`config/starship.toml`).
- [x] Neovim: vendored LazyVim + overrides (comma leader, jk->Esc, tmux-navigator, solarized).
- [x] tmux captured verbatim (`home/tmux.conf`); reattach dep moved to Brewfile.
- [x] `Brewfile` + idempotent `setup.sh` + `install/link.sh`.
- [x] Migration playbook + decision records under `research/` and `decisions/`.

## Ran on this machine (2026-06-30)

- [x] **`./setup.sh`** ran clean. Toolchain installed via Brewfile, dotfiles
      symlinked (old `~/.zshrc`/`~/.tmux.conf` backed up to `*.bak`), TPM +
      antidote primed, Powerline font installed. Verified: 0.13s cold zsh
      startup, no errors, nvm lazy-stubbed, git aliases work, glyph U+2B80
      now covered.

Manual steps still on David:

1. Create `~/.zsh_secrets` from `secrets/zsh_secrets.example` and fill in real values.
2. Launch `nvim` once so LazyVim syncs plugins; commit the resulting `lazy-lock.json`.
3. `nvm alias default 24`.
4. Set Ghostty as default terminal, quit iTerm2.

## Then: push to GitHub

- Create a remote (suggest repo name `dotfiles` under `dtothefp`) and push.
- Once trusted, retire the old `~/dev/dotfiles` (`dtothefp/dotfiles`).

## Optional later

- tmux truecolor (`tmux-256color` + `Tc` override) for richer nvim colors inside tmux.
- Swap solarized-osaka for classic Solarized if the variant grates.
- fnm instead of nvm if lazy-loaded nvm still feels slow.
