# ~/.config/zsh/functions.zsh
# Shell functions and lazy loaders.

# ---------------------------------------------------------------------------
# Lazy-load nvm. Sourcing nvm eagerly adds ~0.5s+ to every shell start, which
# is most of what made the old Oh My Zsh setup feel slow. Instead, define
# stubs that load nvm on first use, then hand off to the real command.
# ---------------------------------------------------------------------------
_load_nvm() {
  unset -f nvm node npm npx pnpm 2>/dev/null
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
}
nvm()  { _load_nvm; nvm "$@"; }
node() { _load_nvm; node "$@"; }
npm()  { _load_nvm; npm "$@"; }
npx()  { _load_nvm; npx "$@"; }
# (Set a default once with: nvm alias default 24)

# ---------------------------------------------------------------------------
# Second Cursor instance with a separate user-data dir (separate account)
# ---------------------------------------------------------------------------
cursor2() {
  local target="${1:-.}"
  if [[ -d "$target" ]]; then
    target="$(cd "$target" && pwd)"
  elif [[ -f "$target" ]]; then
    target="$(cd "$(dirname "$target")" && pwd)/$(basename "$target")"
  fi
  open -na /Applications/Cursor.app --args \
    --user-data-dir="$HOME/.cursor-profile-2" \
    --extensions-dir="$HOME/.cursor-profile-2/extensions" \
    "$target"
}

# mkdir + cd
mkcd() { mkdir -p "$1" && cd "$1"; }
