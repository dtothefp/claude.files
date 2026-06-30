#!/usr/bin/env bash
# setup.sh
# One command to stand up the whole terminal/shell stack on a fresh Mac.
# Safe to re-run: every step is guarded.
#
#   FROM: iTerm2 + Oh My Zsh + Vim
#   TO:   Ghostty + antidote + Starship + Neovim (LazyVim)
#   KEEP: tmux (config carried over verbatim)
set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
say() { printf "\n\033[1;36m==> %s\033[0m\n" "$1"; }

# ---------------------------------------------------------------------------
# 1. Homebrew
# ---------------------------------------------------------------------------
say "Checking Homebrew"
if ! command -v brew >/dev/null; then
  echo "Homebrew not found. Install it first:"
  echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  exit 1
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# ---------------------------------------------------------------------------
# 2. Packages
# ---------------------------------------------------------------------------
say "Installing packages (brew bundle)"
brew bundle --file="$DOT/Brewfile"

# ---------------------------------------------------------------------------
# 3. Input font (from the local copy in ~/dev/Input-Font, if present)
# ---------------------------------------------------------------------------
say "Ensuring Input Mono font is installed"
if ls "$HOME/Library/Fonts/InputMono" >/dev/null 2>&1; then
  echo "ok    InputMono already installed"
elif [[ -d "$HOME/dev/Input-Font/Input_Fonts" ]]; then
  cp -R "$HOME/dev/Input-Font/Input_Fonts/"* "$HOME/Library/Fonts/" 2>/dev/null || true
  echo "installed Input fonts from ~/dev/Input-Font"
else
  echo "warn  Input fonts not found locally. Re-download from input.fontbureau.com,"
  echo "      or change font-family in config/ghostty/config."
fi

# ---------------------------------------------------------------------------
# 3b. Powerline fonts for the tmux status bar
# The kept tmux status bar uses the legacy Powerline arrows U+2B80/U+2B81 in
# window-status-current-format. Nothing on a stock Mac (and not Ghostty's
# bundled Nerd Font) covers those two codepoints, so the active-window
# separator falls back to tofu without a patched Powerline font installed.
# These two are vendored in the repo (OFL / free licensed). One is enough.
# ---------------------------------------------------------------------------
say "Ensuring a Powerline font is installed (tmux status bar)"
if fc-list 2>/dev/null | grep -qi "for Powerline"; then
  echo "ok    a Powerline font is already installed"
elif [[ -d "$DOT/fonts/powerline" ]]; then
  cp "$DOT/fonts/powerline/"*.otf "$HOME/Library/Fonts/" 2>/dev/null || true
  echo "installed Powerline fonts from fonts/powerline"
else
  echo "warn  no Powerline font found; tmux active-window separators may show tofu"
fi

# ---------------------------------------------------------------------------
# 4. Symlink dotfiles
# ---------------------------------------------------------------------------
say "Linking dotfiles"
bash "$DOT/install/link.sh"

# ---------------------------------------------------------------------------
# 5. tmux plugin manager (kept config expects ~/.tmux/plugins/tpm)
# ---------------------------------------------------------------------------
say "Bootstrapping tmux plugins (TPM)"
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
"$TPM_DIR/bin/install_plugins" || echo "note: run prefix + I inside tmux if plugins did not install"

# ---------------------------------------------------------------------------
# 6. antidote: prime the static plugin bundle
# ---------------------------------------------------------------------------
say "Priming antidote plugin bundle"
antidote_home="$(brew --prefix antidote)/share/antidote"
if [[ -f "$antidote_home/antidote.zsh" && -f "$HOME/.zsh_plugins.txt" ]]; then
  # shellcheck disable=SC1090
  source "$antidote_home/antidote.zsh"
  antidote bundle <"$HOME/.zsh_plugins.txt" >"$HOME/.zsh_plugins.zsh"
  echo "wrote ~/.zsh_plugins.zsh"
fi

# ---------------------------------------------------------------------------
# 7. Secrets file
# ---------------------------------------------------------------------------
say "Checking secrets file"
if [[ -f "$HOME/.zsh_secrets" ]]; then
  echo "ok    ~/.zsh_secrets exists"
else
  echo "warn  ~/.zsh_secrets missing. Create it from the template:"
  echo "        cp $DOT/secrets/zsh_secrets.example ~/.zsh_secrets && chmod 600 ~/.zsh_secrets"
  echo "      then fill in real values (AWS keys, API tokens, etc.)."
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
say "Done. Remaining manual steps:"
cat <<'EOF'
  1. Open Ghostty and set it as your default terminal. Quit iTerm2.
  2. First Neovim launch: run `nvim`. LazyVim installs plugins on first start.
  3. Node: set a default once with  `nvm alias default 24`  (nvm is lazy-loaded).
  4. Open a fresh shell (or `exec zsh`) to load the new zsh stack.
  5. If you have not already, create ~/.zsh_secrets from the template (step 7 above).
EOF
