-- Seamless navigation between Neovim splits and tmux panes with <C-h/j/k/l>.
-- The matching half lives in the tmux config (the is_vim check + the C-h/j/k/l
-- bindings), which was carried over unchanged from the old setup.
return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate left (tmux/vim)" },
    { "<c-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate down (tmux/vim)" },
    { "<c-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate up (tmux/vim)" },
    { "<c-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right (tmux/vim)" },
  },
}
