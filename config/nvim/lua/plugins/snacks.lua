-- Turn off the snacks.nvim indent guides and scope highlight. These are the dim
-- markers LazyVim draws at each nesting level (the `─ ─ ─` on blank lines). They
-- are virtual overlays (extmarks), never written to the file, but they read as
-- clutter. Disabling `indent` removes the per-level guides; disabling `scope`
-- removes the current-scope underline/animation. Delete this file to get the
-- LazyVim defaults back.
return {
  "folke/snacks.nvim",
  opts = {
    indent = { enabled = false },
    scope = { enabled = false },
  },
}
