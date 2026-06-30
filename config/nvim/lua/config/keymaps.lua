-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- Ported from the old ~/dev/dotfiles vim/vimrc.symlink. Leader is comma.
-- Bindings LazyVim already provides natively (gd/gr/gy/K, ]d/[d, <C-h/j/k/l>
-- via vim-tmux-navigator, Telescope for CtrlP, mini.ai for if/af/ic/ac,
-- completion <cr>) are intentionally NOT re-declared here.

local map = vim.keymap.set

-- ---------------------------------------------------------------------------
-- Editing habits
-- ---------------------------------------------------------------------------

-- jk to leave insert mode (old: `imap jk <Esc>`)
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Wrapped lines move by display line, but keep counts working (old: j gj / k gk)
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Y yanks to end of line, consistent with C and D (old: nnoremap Y y$)
map("n", "Y", "y$", { desc = "Yank to end of line" })

-- Keep search matches centered (old: n nzzzv / N Nzzzv)
map("n", "n", "nzzzv", { desc = "Next match (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev match (centered)" })

-- Don't jump to next match on * (old: nnoremap * *<c-o>)
map("n", "*", "*<c-o>", { desc = "Search word under cursor, stay put" })

-- Visual shifting keeps the selection (old: vnoremap < <gv)
map("v", "<", "<gv", { desc = "Shift left, keep selection" })
map("v", ">", ">gv", { desc = "Shift right, keep selection" })

-- Paste from the system clipboard register (old: nnoremap <leader>P "+P)
map("n", "<leader>P", '"+P', { desc = "Paste from system clipboard" })

-- Easier horizontal scrolling (old: zl->zL, zh->zH)
map("n", "zl", "zL", { desc = "Scroll right (half screen)" })
map("n", "zh", "zH", { desc = "Scroll left (half screen)" })

-- Refresh buffers from disk (old: nnoremap <leader>r :checktime<cr>)
map("n", "<leader>r", "<cmd>checktime<cr>", { desc = "Reload changed buffers" })

-- ---------------------------------------------------------------------------
-- File tree (LazyVim ships neo-tree; old vimrc used NERDTreeTabsToggle on
-- <leader>d). Keep <leader>d, add <leader>v alias. <leader>e is LazyVim default.
-- ---------------------------------------------------------------------------
map("n", "<leader>v", "<cmd>Neotree toggle<cr>", { desc = "Toggle file tree" })
map("n", "<leader>d", "<cmd>Neotree toggle<cr>", { desc = "Toggle file tree" })

-- ---------------------------------------------------------------------------
-- Tabs (old config was tab-centric: taboo + tabline + S-H/S-L). This OVERRIDES
-- LazyVim's default S-h/S-l buffer cycling. If you'd rather cycle buffers,
-- delete these two lines.
-- ---------------------------------------------------------------------------
map("n", "<S-h>", "gT", { desc = "Previous tab" })
map("n", "<S-l>", "gt", { desc = "Next tab" })

-- Jump to the last-used tab with <C-w>; (old: g:lasttab + autocmd)
vim.g.lasttab = 1
map("n", "<c-w>;", function()
  vim.cmd("tabn " .. vim.g.lasttab)
end, { desc = "Last used tab" })
vim.api.nvim_create_autocmd("TabLeave", {
  callback = function()
    vim.g.lasttab = vim.fn.tabpagenr()
  end,
})

-- ---------------------------------------------------------------------------
-- Split resizing (old: <leader>+/-, <leader>L/H). LazyVim also has <C-arrows>.
-- ---------------------------------------------------------------------------
map("n", "<leader>+", function()
  vim.cmd("resize " .. math.floor(vim.fn.winheight(0) * 3 / 2))
end, { desc = "Grow window height" })
map("n", "<leader>-", function()
  vim.cmd("resize " .. math.floor(vim.fn.winheight(0) * 2 / 3))
end, { desc = "Shrink window height" })
map("n", "<leader>L", "<cmd>vertical resize +20<cr>", { desc = "Grow window width" })
map("n", "<leader>H", "<cmd>vertical resize -20<cr>", { desc = "Shrink window width" })

-- ---------------------------------------------------------------------------
-- Edit a file in the same directory as the current file (old: %% + <leader>e*)
-- ---------------------------------------------------------------------------
-- %% in command mode expands to the current file's directory
vim.cmd([[cnoremap %% <C-R>=expand('%:h').'/'<cr>]])
map("n", "<leader>ew", ":e %%", { desc = "Edit (here)" })
map("n", "<leader>es", ":sp %%", { desc = "Split edit (here)" })
map("n", "<leader>ev", ":vsp %%", { desc = "Vsplit edit (here)" })
map("n", "<leader>et", ":tabe %%", { desc = "Tab edit (here)" })

-- Edit the Neovim config (old: <leader>ve :vsplit $MYVIMRC)
map("n", "<leader>ve", "<cmd>vsplit $MYVIMRC<cr>", { desc = "Edit init.lua" })

-- ---------------------------------------------------------------------------
-- Command-line conveniences (old cmaps)
-- ---------------------------------------------------------------------------
-- cd to the current file's directory (old: cmap cwd / cd. lcd %:p:h)
vim.cmd([[cnoreabbrev cwd lcd %:p:h]])
vim.cmd([[cnoreabbrev cd. lcd %:p:h]])
-- Write a root-owned file you forgot to sudo (old: cmap w!! ...)
vim.cmd([[cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!]])

-- Stupid-shift-key command fixes (old: command! E/W/Wq/WQ/Wa/WA/Q/QA/Qa)
for _, c in ipairs({ "W", "Wq", "WQ", "Wa", "WA", "Q", "QA", "Qa", "E" }) do
  -- map each shouty variant to its lowercase ex-command
  vim.api.nvim_create_user_command(c, function(o)
    vim.cmd((c:lower()) .. (o.bang and "!" or "") .. " " .. o.args)
  end, { bang = true, nargs = "*", complete = "file" })
end

-- ---------------------------------------------------------------------------
-- LSP aliases to match the old coc.nvim muscle memory. Set on attach so they
-- only bind where a language server is present. LazyVim already provides
-- gd / gr / gy / K and ]d / [d; these add the variants the old config used.
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local o = function(desc)
      return { buffer = ev.buf, desc = desc, silent = true }
    end
    map("n", "gi", vim.lsp.buf.implementation, o("Go to implementation"))
    map("n", "<leader>rn", vim.lsp.buf.rename, o("Rename symbol"))
    map({ "n", "x" }, "<leader>qf", vim.lsp.buf.code_action, o("Quick fix (code action)"))
    if vim.lsp.codelens then
      map("n", "<leader>cl", vim.lsp.codelens.run, o("Run code lens"))
    end
  end,
})

-- Diagnostics navigation with [g / ]g (old coc: [g / ]g). Works without LSP too.
local function diag_jump(dir)
  if vim.diagnostic.jump then
    vim.diagnostic.jump({ count = dir, float = true })
  elseif dir > 0 then
    vim.diagnostic.goto_next()
  else
    vim.diagnostic.goto_prev()
  end
end
map("n", "]g", function()
  diag_jump(1)
end, { desc = "Next diagnostic" })
map("n", "[g", function()
  diag_jump(-1)
end, { desc = "Prev diagnostic" })

-- ---------------------------------------------------------------------------
-- Git via vim-fugitive (old: <leader>g{s,d,c,b,l,p}). The plugin is installed
-- in lua/plugins/fugitive.lua and lazy-loads on the :Git command. These
-- override LazyVim's gitsigns defaults on the same keys (e.g. <leader>gb).
-- lazygit is still on <leader>gg.
-- ---------------------------------------------------------------------------
map("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Git status (fugitive)" })
map("n", "<leader>gd", "<cmd>Gdiffsplit<cr>", { desc = "Git diff (split)" })
map("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Git commit" })
map("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Git blame" })
map("n", "<leader>gl", "<cmd>Git log<cr>", { desc = "Git log" })
map("n", "<leader>gp", "<cmd>Git push<cr>", { desc = "Git push" })

-- ---------------------------------------------------------------------------
-- Alignment via tabular (old: <leader>a{&,=,:,::,comma,bar,-}). Plugin in
-- lua/plugins/tabular.lua, lazy-loads on :Tabularize.
-- ---------------------------------------------------------------------------
local function align(lhs, pattern, desc)
  map({ "n", "v" }, lhs, "<cmd>Tabularize /" .. pattern .. "<cr>", { desc = desc })
end
align("<leader>a&", "&", "Align on &")
align("<leader>a=", "=", "Align on =")
align("<leader>a:", ":", "Align on :")
align("<leader>a::", ":\\zs", "Align after :")
align("<leader>a,", ",", "Align on ,")
align("<leader>a<bar>", "<bar>", "Align on |")
align("<leader>a-", "=>", "Align on =>")
