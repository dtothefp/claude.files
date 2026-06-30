-- tpope/vim-fugitive, carried over from the old vimrc. The <leader>g* mappings
-- live in lua/config/keymaps.lua; fugitive lazy-loads on its commands.
return {
  "tpope/vim-fugitive",
  cmd = { "Git", "Gdiffsplit", "Gblame", "Gread", "Gwrite", "Gedit", "Glog" },
}
