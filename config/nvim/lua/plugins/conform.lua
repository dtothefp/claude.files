-- Format on save with oxfmt, the formatter the projects actually use (the JS/TS
-- harnesses run `oxfmt --write .`). The LazyVim typescript extra would otherwise
-- register prettier for these filetypes, which would fight oxfmt's style. This
-- override points conform at oxfmt instead, so editor-save and the CLI agree.
--
-- oxfmt is a project devDependency, not global, so the command resolves the
-- nearest node_modules/.bin/oxfmt upward from the file and falls back to a
-- global `oxfmt` on PATH if there isn't one.
return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      oxfmt = {
        command = function(_, ctx)
          local nm = vim.fs.find({ "node_modules" }, {
            upward = true,
            path = ctx.dirname,
            type = "directory",
          })[1]
          if nm then
            local bin = nm .. "/.bin/oxfmt"
            if vim.fn.executable(bin) == 1 then
              return bin
            end
          end
          return "oxfmt"
        end,
        args = { "--stdin-filepath", "$FILENAME" },
        stdin = true,
      },
    },
    formatters_by_ft = {
      javascript = { "oxfmt" },
      javascriptreact = { "oxfmt" },
      typescript = { "oxfmt" },
      typescriptreact = { "oxfmt" },
      json = { "oxfmt" },
      jsonc = { "oxfmt" },
    },
  },
}
