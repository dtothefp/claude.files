-- LazyVim 16 dropped neo-tree for the Snacks explorer. Two fixes here:
--
-- 1. NERDTree muscle memory. Snacks binds `o` to "open in system app" (that is
--    why pressing o over a directory popped a Finder window). Remap the
--    explorer list keys to the old NERDTree habits.
--
-- 2. Seamless tmux/vim navigation out of the tree. By default the Snacks
--    explorer binds <c-j>/<c-k> to scroll its own list and leaves the left-edge
--    <c-h> handoff to vim-tmux-navigator unreliable, so <C-h> got "stuck" in the
--    tree instead of crossing into the tmux pane on the left. Bind all four
--    <C-h/j/k/l> in the explorer to the TmuxNavigate commands so the tree
--    behaves like every other split (j/k still move the tree selection).
--
-- LazyVim deep-merges these into the snacks defaults; unlisted keys keep their
-- stock behavior.
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      -- custom actions, referenced by name from the explorer key table below
      actions = {
        tmux_nav_left = function()
          vim.cmd("TmuxNavigateLeft")
        end,
        tmux_nav_down = function()
          vim.cmd("TmuxNavigateDown")
        end,
        tmux_nav_up = function()
          vim.cmd("TmuxNavigateUp")
        end,
        tmux_nav_right = function()
          vim.cmd("TmuxNavigateRight")
        end,
      },
      sources = {
        explorer = {
          win = {
            list = {
              keys = {
                -- NERDTree habits
                ["o"] = "confirm", -- open file / toggle directory
                ["s"] = "edit_vsplit", -- open in a vertical split
                ["i"] = "edit_split", -- open in a horizontal split
                ["t"] = "tab", -- open in a new tab
                ["R"] = "explorer_update", -- refresh the tree
                ["O"] = "explorer_open", -- system-open on capital O
                -- seamless pane/split navigation out of the tree
                ["<c-h>"] = "tmux_nav_left",
                ["<c-j>"] = "tmux_nav_down",
                ["<c-k>"] = "tmux_nav_up",
                ["<c-l>"] = "tmux_nav_right",
              },
            },
          },
        },
      },
    },
  },
}
