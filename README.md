# dotfiles

David's terminal and shell environment, reproducible on a fresh Mac with one command.

**Stack:** [Ghostty](https://ghostty.org) terminal, a fast zsh setup with
[antidote](https://antidote.sh) + [Starship](https://starship.rs),
[Neovim](https://neovim.io) via [LazyVim](https://lazyvim.org), and tmux carried
over unchanged.

This replaces an older setup of iTerm2 + Oh My Zsh + Vim. The rationale for each
choice is written up under `research/` and `decisions/`.

## Install

```sh
git clone <this-repo> ~/.dotfiles
cd ~/.dotfiles
./setup.sh
```

`setup.sh` is idempotent (safe to re-run). It installs the toolchain via
Homebrew (`Brewfile`), installs the Input Mono font, symlinks the configs, and
bootstraps the tmux and Neovim plugin managers.

After it runs: set Ghostty as your default terminal, launch `nvim` once to let
LazyVim sync plugins, run `nvm alias default 24`, and open a fresh shell.

## Layout

| Path | Symlinks to | What |
|------|-------------|------|
| `home/zshrc` | `~/.zshrc` | Shell entry point (antidote + Starship + tool init) |
| `home/zsh_plugins.txt` | `~/.zsh_plugins.txt` | antidote plugin list |
| `home/tmux.conf` | `~/.tmux.conf` | tmux config, carried over verbatim |
| `config/zsh/` | `~/.config/zsh/` | `aliases.zsh`, `exports.zsh`, `functions.zsh` |
| `config/ghostty/config` | `~/.config/ghostty/config` | Ghostty terminal config |
| `config/starship.toml` | `~/.config/starship.toml` | Prompt |
| `config/nvim/` | `~/.config/nvim/` | LazyVim (vendored) + custom overrides |
| `install/link.sh` | | XDG-aware symlink engine |
| `Brewfile` | | Declarative package list |

## Secrets

Machine-local secrets (API tokens, AWS keys) live in `~/.zsh_secrets`, which is
**never committed**. Create it from the template:

```sh
cp secrets/zsh_secrets.example ~/.zsh_secrets && chmod 600 ~/.zsh_secrets
# then fill in real values
```

`~/.zshrc` sources it automatically if present.
