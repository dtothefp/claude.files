-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- jk to leave insert mode (old Vim habit: `imap jk <Esc>`)
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Keep the cursor centered when jumping through search matches
map("n", "n", "nzzzv", { desc = "Next match (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev match (centered)" })

-- Y yanks to end of line (consistent with C and D)
map("n", "Y", "y$", { desc = "Yank to end of line" })

-- Visual shifting keeps the selection (old vimrc: vnoremap < <gv)
map("v", "<", "<gv", { desc = "Shift left, keep selection" })
map("v", ">", ">gv", { desc = "Shift right, keep selection" })
