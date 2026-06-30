-- LazyVim 16 dropped neo-tree for the Snacks explorer. Its default keys differ
-- from NERDTree, most notably `o` is bound to "open in system app" (that is why
-- pressing o over a directory popped a Finder window). Remap the explorer's
-- list-window keys onto the old NERDTree muscle memory. LazyVim deep-merges
-- these into the snacks defaults, so unlisted keys keep their stock behavior.
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          win = {
            list = {
              keys = {
                ["o"] = "confirm", -- NERDTree o: open file / toggle directory
                ["s"] = "edit_vsplit", -- NERDTree s: open in a vertical split
                ["i"] = "edit_split", -- NERDTree i: open in a horizontal split
                ["t"] = "tab", -- NERDTree t: open in a new tab
                ["R"] = "explorer_update", -- NERDTree R: refresh the tree
                ["O"] = "explorer_open", -- keep system-open available on capital O
              },
            },
          },
        },
      },
    },
  },
}
