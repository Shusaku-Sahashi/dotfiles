-- if you want to confirm that treesitter is working, execute ":InspectTree"
return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  -- this command is executed when treesitter plugin is installed/updated.
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag", -- close html tag automatically
    -- pkl は nvim-treesitter 本体に未収録のため、pkl-neovim が独自の
    -- tree-sitter パーサーを登録する。treesitter.setup() より前に読み込まれる必要がある。
    -- (シンタックスハイライトに加えて、ftplugin/pkl.vim 経由で pkl-lsp の起動も担う)
    {
      "apple/pkl-neovim",
      config = function()
        vim.g.pkl_neovim = {
          -- mason でインストールした pkl-lsp を使う
          start_command = { vim.fn.stdpath("data") .. "/mason/bin/pkl-lsp" },
        }
      end,
    },
  },
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup({ -- enable syntax highlighting
      highlight = {
        enable = true,
        -- KotlinはTreesitterを無効化してVim syntaxを使用
        disable = { "kotlin" },
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
        "pkl",
      },
    })
  end,
}
