-- To install lsp, execute :Mason command
return {
  -- package manager for Language Server, debugger, formatter, linter etc...
  "williamboman/mason.nvim",
  version = "^1.0.0",
  dependencies = {
    { "williamboman/mason-lspconfig.nvim", version = "^1.0.0" },
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "ts_ls",  -- typescript
        "html",   -- html
        "cssls",  -- css
        "lua_ls", -- lua
        "hls",    -- haskell
        "gopls",  -- golang
        "pylsp",  -- python
        "yamlls", -- yaml
        "clangd", -- clang
        "bashls", -- bash lsp
        "jsonls"  -- json lsp
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier",   -- prettier formatter
        "stylua",     -- lua formatter
        "eslint_d",
        "shellcheck", -- bash lint
        "shfmt",      -- bash fmt
      },
    })
  end,
}
