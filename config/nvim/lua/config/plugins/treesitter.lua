-- if you want to confirm that treesitter is working, execute ":InspectTree"
return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile"},
  -- this command is executed when treesitter plugin is installed/updated.
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag", -- close html tag automatically
  },
  config = function()
  -- import nvim-treesitter plugin
  local treesitter = require("nvim-treesitter.configs")

  -- configure treesitter
  treesitter.setup({ -- enable syntax highlighting
    highlight = {
      enable = true,
    },
    -- enable indentation
    indent = { enable = true },
    -- enable autotagging (w/ nvim-ts-autotag plugin)
    autotag = {
      enable = true,
    },
    -- ensure these language parsers are installed
    ensure_installed = {
      "json",
      "javascript",
      "typescript",
      "tsx",
      "yaml",
      "html",
      "css",
      "prisma",
      "markdown",
      "markdown_inline",
      "bash",
      "lua",
      "vim",
      "dockerfile",
      "gitignore",
      "query",
      "vimdoc",
      "c",
      "go",
      "kotlin",
      "sql",
      "haskell",
    },

    -- not using this now.
    -- incremental_selection = {
    --   enable = true,
    --   keymaps = {
    --     init_selection = "<C-space>",
    --     node_incremental = "<C-space>",
    --     scope_incremental = false,
    --     node_decremental = "<bs>",
    --   },
    -- },
  })
  end,
}
