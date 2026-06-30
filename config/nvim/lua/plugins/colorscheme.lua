-- Colorscheme: Solarized (the old Vim config ran solarized dark).
-- solarized-osaka is a well-maintained, LazyVim-native Solarized variant.
-- To go back to classic Solarized exactly, swap to "maxmcd/solarized.nvim" or
-- "ishan9299/nvim-solarized-lua" and set colorscheme accordingly.
return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "solarized-osaka",
    },
  },
}
