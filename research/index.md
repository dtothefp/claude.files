# Research Index, terminal-migration

Curated entry point for this project's research. New artifacts get a one-line entry here when they change conclusions.

## Topics

### Full migration playbook (start here)
- [migration-playbook-2026-06-30](terminal-stack/migration-playbook-2026-06-30.md) The end-to-end reconstruction: starting point captured from this machine, the seven `setup.sh` steps, and per-tool detail for Ghostty, the zsh stack, Neovim, and tmux.

### Terminal emulator
- Ghostty replaces iTerm2. Config at `config/ghostty/config`, font `Input Mono`, Nerd Font symbols via Ghostty's built-in fallback. See the playbook.

### Shell stack
- antidote (plugin manager) + Starship (prompt) replace Oh My Zsh. nvm lazy-loaded for fast startup. See the playbook and [decisions/0001](../decisions/0001-fast-zsh-antidote-starship.md).

### Editor
- Neovim + vendored LazyVim, leader kept as comma. See the playbook and [decisions/0002](../decisions/0002-neovim-lazyvim-comma-leader.md).

### Multiplexer (carried over)
- tmux config captured verbatim in `home/tmux.conf`; `reattach-to-user-namespace` satisfied via Brewfile. See the playbook.
- [powerline-fonts-2026-06-30](terminal-stack/powerline-fonts-2026-06-30.md) Whether the skwp Powerline fonts are still needed (yes, only for the tmux active-window separator `⮀`/`⮁` at U+2B80/2B81; editor and prompt no longer need them), why one OFL font is vendored in `fonts/powerline/`, and the Nerd-Font path to dropping the dependency. Also covers whether Powerline is the right status-bar choice in 2026.

### Reproducibility
- `setup.sh` + `Brewfile` + `install/link.sh`. Idempotent, non-destructive symlinking. See the playbook.

## See also

- [log.md](log.md) is the append-only changelog of all research artifacts.
- `../GOVERNANCE.md` for the wiki rules.
