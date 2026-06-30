# Brewfile  ->  install everything with: brew bundle --file=Brewfile
# (setup.sh runs this for you.)

# --- Terminal -----------------------------------------------------------
cask "ghostty"                       # GPU terminal, replaces iTerm2

# --- Shell stack --------------------------------------------------------
brew "antidote"                      # zsh plugin manager, replaces Oh My Zsh
brew "starship"                      # cross-shell prompt, replaces the OMZ theme

# --- Editor -------------------------------------------------------------
brew "neovim"                        # replaces Vim/MacVim
brew "ripgrep"                       # LazyVim: live grep (Telescope)
brew "fd"                            # LazyVim: fast file finder
brew "lazygit"                       # LazyVim: built-in git UI (<leader>gg)

# --- Multiplexer (kept) -------------------------------------------------
brew "tmux"
brew "reattach-to-user-namespace"    # satisfies the kept tmux config verbatim
# tmux plugin manager (TPM) is git-cloned by setup.sh into ~/.tmux/plugins/tpm,
# the path the kept tmux config expects. No brew formula needed.

# --- Modern CLI ---------------------------------------------------------
brew "fzf"                           # fuzzy finder (Ctrl-R / Ctrl-T / Alt-C)
brew "zoxide"                        # smart cd (z)
brew "eza"                           # modern ls
brew "bat"                           # modern cat

# --- Supporting ---------------------------------------------------------
brew "git"
