-- Claude Code inside Neovim. coder/claudecode.nvim speaks the SAME WebSocket IDE
-- protocol the official VS Code / JetBrains extensions use, so the `claude` CLI
-- attaches to this editor: visual-select lines and send them as @-context, share
-- LSP diagnostics automatically, and review Claude's edits as native nvim diffs.
-- This is the Cursor "point at these lines and ask" workflow, in the terminal.
--
-- Keys live under <leader>i ("AI"), NOT the plugin's default <leader>a prefix,
-- because <leader>a is already the tabular alignment group in keymaps.lua. The
-- headline bind is visual-mode <leader>is (select -> send to Claude).
--
-- Note for cold interview drills: the Hadrian round bans AI tools. This is a
-- keybind, not an always-on assistant, so practicing AI-free just means not
-- opening the pane. Nothing here completes code for you until you ask it to.
return {
  "coder/claudecode.nvim",
  -- snacks provides the terminal split the Claude pane lives in (already a
  -- LazyVim dependency, so this adds nothing new to install).
  dependencies = { "folke/snacks.nvim" },
  opts = {
    terminal = {
      split_side = "right",
      split_width_percentage = 0.30,
      provider = "snacks",
    },
  },
  -- Lazy-load on first use of any of these keys / commands.
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSend",
    "ClaudeCodeAdd",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
  },
  keys = {
    { "<leader>i", nil, desc = "AI / Claude Code" },
    { "<leader>ic", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>if", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ir", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>iC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>ib", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    -- The headline workflow: visual-select code, send it as context.
    { "<leader>is", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
    -- In the file tree, <leader>is adds the file under the cursor instead.
    {
      "<leader>is",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file to Claude",
      ft = { "neo-tree", "oil", "minifiles" },
    },
    -- Accept / reject the diff Claude proposes, shown as a native nvim diff.
    { "<leader>ia", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
    { "<leader>id", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny Claude diff" },
  },
}
