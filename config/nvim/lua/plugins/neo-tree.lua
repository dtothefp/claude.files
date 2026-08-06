-- File tree = neo-tree (enabled via the editor.neo-tree extra in lazyvim.json).
--
-- Why not the Snacks explorer LazyVim 16 ships by default: the Snacks explorer
-- is a picker, not a real window, and its focus management fights
-- vim-tmux-navigator. <C-h> from the tree never handed off to the tmux pane on
-- the left, it bounced focus back into the editor. neo-tree is a normal split,
-- so <C-h/j/k/l> cross the tree/editor/tmux boundaries the standard way with no
-- extra wiring. It is also the closest thing to the old NERDTree.
--
-- This spec only layers the NERDTree open-keys onto neo-tree's defaults.
-- neo-tree already matches NERDTree for `s` (vsplit) and `t` (new tab); add
-- `o` (open / toggle node) and `i` (horizontal split) to complete the set.
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        -- Dotfiles are half this workspace (.claude, .obsidian, .env). Child
        -- projects under packages/ are cloned separately and gitignored, so
        -- neo-tree's hide_gitignored default collapses all 68 of them.
        hide_dotfiles = false,
        hide_gitignored = false,
        -- never_show, not hide_by_name: hide_by_name entries still render
        -- (dimmed) once anything unhides them.
        never_show = { ".DS_Store", ".git" },
      },
    },
    window = {
      mappings = {
        ["o"] = "open", -- NERDTree o: open file / toggle directory
        ["i"] = "open_split", -- NERDTree i: open in a horizontal split
        -- NERDTree x: collapse the directory under the cursor, or its parent if
        -- the cursor is on a file/closed dir. Replaces neo-tree's default
        -- x=cut_to_clipboard (copy/move/add/delete stay on c/m/a/d).
        ["x"] = "close_node",
      },
    },
  },
}
