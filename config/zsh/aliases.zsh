# ~/.config/zsh/aliases.zsh
# Personal aliases. (Git aliases come from the oh-my-zsh git plugin via antidote.)

# Editor: Neovim everywhere (replaces the old `mvim -v` alias)
alias vim='nvim'
alias vi='nvim'
alias v='nvim'

# eza (modern ls)
if command -v eza >/dev/null; then
  alias ls='eza --group-directories-first'
  alias ll='eza -lah --group-directories-first --git'
  alias la='eza -a --group-directories-first'
  alias lt='eza --tree --level=2'
fi

# bat (modern cat)
if command -v bat >/dev/null; then
  alias cat='bat --paging=never'
  alias catp='bat'
fi

# zoxide already provides `z`; keep a plain cd around
alias cd..='cd ..'

# tmux quality of life
alias t='tmux'
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tl='tmux list-sessions'

# Reload the shell
alias reload='exec zsh'
