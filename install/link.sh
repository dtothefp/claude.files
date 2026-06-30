#!/usr/bin/env bash
# install/link.sh
# Symlink the dotfiles into place. Idempotent and non-destructive: anything that
# already exists and is not our symlink gets moved aside to <path>.bak first.
#
#   home/<name>     ->  ~/.<name>            (e.g. home/zshrc     -> ~/.zshrc)
#   config/<name>   ->  ~/.config/<name>     (e.g. config/nvim    -> ~/.config/nvim)
set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
XDG="${XDG_CONFIG_HOME:-$HOME/.config}"

link() {
  local src="$1" dest="$2"
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    echo "ok    $dest"
    return
  fi
  if [[ -e "$dest" || -L "$dest" ]]; then
    mv "$dest" "$dest.bak"
    echo "backup $dest -> $dest.bak"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "link  $dest -> $src"
}

# home/* -> ~/.*
if [[ -d "$DOT/home" ]]; then
  for src in "$DOT"/home/*; do
    [[ -e "$src" ]] || continue
    link "$src" "$HOME/.$(basename "$src")"
  done
fi

# config/* -> ~/.config/*
if [[ -d "$DOT/config" ]]; then
  mkdir -p "$XDG"
  for src in "$DOT"/config/*; do
    [[ -e "$src" ]] || continue
    link "$src" "$XDG/$(basename "$src")"
  done
fi

echo "Symlinks in place."
