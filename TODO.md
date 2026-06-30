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

## Next: actually run it on this machine

1. **`./setup.sh`** to install the toolchain and link everything. It backs up any
   existing `~/.zshrc` etc. to `*.bak`, so it is safe.
2. Create `~/.zsh_secrets` from `secrets/zsh_secrets.example` and fill in real values.
3. Launch `nvim` once so LazyVim syncs plugins; commit the resulting `lazy-lock.json`.
4. `nvm alias default 24`.
5. Set Ghostty as default terminal, quit iTerm2.
6. Verify: fast shell startup, Starship prompt, git aliases work, nvim + tmux pane nav.

## Then: push to GitHub

- Create a remote (suggest repo name `dotfiles` under `dtothefp`) and push.
- Once trusted, retire the old `~/dev/dotfiles` (`dtothefp/dotfiles`).

## Optional later

- tmux truecolor (`tmux-256color` + `Tc` override) for richer nvim colors inside tmux.
- Swap solarized-osaka for classic Solarized if the variant grates.
- fnm instead of nvm if lazy-loaded nvm still feels slow.
