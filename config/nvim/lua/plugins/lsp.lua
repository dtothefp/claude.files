-- Turn LSP inlay hints OFF by default. These are the virtual (purple) type
-- annotations vtsls paints inline, e.g. `(x : any) : void` in a function
-- signature. They are NOT real code and NOT completions (you can't Tab to
-- accept them), so they read as confusing next to the actual completion menu.
-- LazyVim defaults them to enabled = true; this flips the default to off.
-- Toggle them back on any time (per buffer) with <leader>uh, which LazyVim maps
-- to Snacks.toggle.inlay_hints -- handy when reading code to see inferred types.
return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      -- ["*"] applies to every LSP server. LazyVim maps <leader>cc -> Run Codelens
      -- here with has = "codeLens", so it attaches BUFFER-LOCAL on LspAttach for any
      -- server that supports codelens (vtsls / TypeScript does). A buffer-local map
      -- always beats a global one, so it silently shadowed our global <leader>cc ->
      -- gcc comment alias -- commenting kept working in plain files but "stopped
      -- working" the moment a .ts/.tsx buffer got an LSP. Setting rhs to false is
      -- LazyVim's documented way to delete a default keymap. Codelens run is niche;
      -- refresh/display is still on <leader>cC if it's ever wanted.
      ["*"] = {
        keys = {
          { "<leader>cc", false },
        },
      },
    },
  },
}
