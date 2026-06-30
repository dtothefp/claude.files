# TODO, terminal-migration

Local-only project (no git remote yet). Cowork tier works on `main` directly.

## Next step

Capture the source environment, then research each target tool. Suggested order:

1. **Capture current dotfiles** from David's machine into `assets/` (or `context/` for working copies).
   - `.zshrc`, Oh My Zsh config, any custom aliases/functions.
   - The tmux config (this carries over unchanged, capture it verbatim).
   - Any existing Ghostty / Starship / Neovim config if partial work survived.
2. **Research + decide per tool** (one dated note each under `research/`, linked from `research/index.md`, logged in `research/log.md`):
   - Ghostty config (font, theme, keybindings, shell integration).
   - antidote plugin manager: which plugins replace the Oh My Zsh set, `.zsh_plugins.txt`.
   - Starship prompt: `starship.toml`.
   - Neovim + LazyVim: distro install, overrides, plugin choices.
3. **Write `setup.sh`** at the project root. Idempotent. Homebrew installs (Ghostty, starship, neovim, antidote, tmux), then drop dotfiles into place with guards so re-runs are safe.
4. **Dry-run `setup.sh`** mentally or in a VM/throwaway user before trusting it on a real fresh Mac.

## Later

- Decide whether to push this to a git remote (currently local-only by request).
