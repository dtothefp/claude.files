-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Leader = comma (carried over from the old Vim config; LazyVim defaults to space).
-- Set here so it is in effect before any plugin maps a <leader> key.
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- Indentation: 2-space, expandtab (matches old vimrc)
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.expandtab = true

-- Old vimrc had nowrap + no spell by default
opt.wrap = false
opt.spell = false

-- Line numbers (relative + absolute, LazyVim default, kept explicit)
opt.number = true
opt.relativenumber = true

-- LazyVim turns on `list` (shows tabs/trailing whitespace as dashes). Turn it
-- back off so blank lines and line-ends are clean. The vertical indent guides
-- are disabled separately in plugins/snacks.lua.
opt.list = false

-- Use the system clipboard for yanks (old vimrc: set clipboard=unnamed)
opt.clipboard = "unnamedplus"

-- Pin the macOS pbcopy/pbpaste clipboard provider when it's available. Without
-- this, inside tmux/Ghostty Neovim auto-selects a write-only OSC52 provider:
-- yanks reach the system clipboard, but `p` cannot read it back, so in-editor
-- yank -> paste silently breaks. pbcopy/pbpaste is bidirectional and local, so
-- `yy`/`dd` round-trip correctly and yanks still reach the macOS pasteboard.
-- Guarded on executable() so a remote/SSH session (no pbcopy) falls back to
-- Neovim's default provider instead.
if vim.fn.executable("pbcopy") == 1 and vim.fn.executable("pbpaste") == 1 then
  vim.g.clipboard = {
    name = "pbcopy",
    copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
    paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
    cache_enabled = 0,
  }
end
