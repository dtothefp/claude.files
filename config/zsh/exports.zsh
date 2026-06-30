# ~/.config/zsh/exports.zsh
# Environment + PATH. Non-secret only. Secrets live in ~/.zsh_secrets.

# Default editor (was mvim, now Neovim)
export EDITOR='nvim'
export VISUAL='nvim'

export GITHUB_USERNAME='dfox-powell'

# ~/.local/bin on PATH
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# nvm dir (nvm itself is lazy-loaded in functions.zsh for fast startup)
export NVM_DIR="$HOME/.nvm"

# Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# Claude Code
export CLAUDE_CODE_AUTO_COMPACT_WINDOW=400000

# Quiet down tool auto-update prompts
export DISABLE_UPDATES=1

# terraform CLI completion
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform 2>/dev/null
