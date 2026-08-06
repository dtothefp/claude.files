-- Make <Tab> accept the completion (VS Code / Cursor muscle memory). LazyVim
-- defaults blink.cmp to the "enter" preset, where only <CR> accepts and <Tab>
-- just jumps snippet placeholders, so Tab appears to do nothing on a normal
-- completion. The "super-tab" preset makes <Tab> select-and-accept the current
-- item while keeping <CR> as accept as well. LazyVim's own blink config detects
-- the super-tab preset and wires the Tab fallback chain (snippet jump, then a
-- literal Tab) correctly, so only the preset needs overriding here.
return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "super-tab",
    },
  },
}
