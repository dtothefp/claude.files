-- Multiple cursors, the Sublime / VS Code "Cmd-D" workflow. vim-visual-multi maps
-- <C-n> to "Find Under": press it on a word to select that occurrence, press
-- again to add the next match, keep going to stack cursors, then `c`/`i`/`s` to
-- edit them all at once. This restores the old setup's Ctrl-N cycle.
--
-- Quick reference once cursors are placed:
--   <C-n>   select word under cursor / add next match
--   n / N   go to next / previous match (without adding a cursor)
--   q       skip the current match and jump to the next
--   [ / ]   move between existing cursors
--   c i s a then type, <Esc>   change / insert / substitute / append on all
--   <Esc>   collapse back to a single cursor
--
-- <C-n> here is normal/visual mode only, so it does not touch insert-mode
-- completion (which also uses <C-n>) or the shell's Ctrl-N history binding.
return {
  "mg979/vim-visual-multi",
  branch = "master",
  -- Lazy-load on the keys that start a multi-cursor session.
  keys = {
    { "<C-n>", mode = { "n", "x" }, desc = "Multi-cursor: select / add next match" },
    { "<C-Up>", mode = { "n" }, desc = "Multi-cursor: add cursor up" },
    { "<C-Down>", mode = { "n" }, desc = "Multi-cursor: add cursor down" },
  },
  init = function()
    -- Defaults already bind <C-n> to these; set them explicitly so the binding
    -- is documented in one place and survives any upstream default change.
    vim.g.VM_maps = {
      ["Find Under"] = "<C-n>",
      ["Find Subword Under"] = "<C-n>",
    }
  end,
}
