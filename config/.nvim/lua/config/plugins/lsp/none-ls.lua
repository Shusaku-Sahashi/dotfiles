return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      -- setup formatters and linters
      sources = {
        -- textlint for markdown files
        null_ls.builtins.diagnostics.textlint.with({
          filetypes = { "markdown" },
          -- need JSON format and stdin support
          args = { "--format", "json", "--stdin-filename", "$FILENAME", "--stdin" },
        }),
      }
    })
  end,
}
