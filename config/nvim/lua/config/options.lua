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

-- Use the system clipboard for yanks (old vimrc: set clipboard=unnamed)
opt.clipboard = "unnamedplus"
