return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- plugin for showing lsp suggest in nvim-cmp
    "hrsh7th/cmp-nvim-lsp",
    -- plugin for fileoperation
    { "antosha417/nvim-lsp-file-operations", config = true },
    -- improve lua nvim config writing experience.
    { "folke/lazydev.nvim", ft = 'lua', opts = {} },
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import mason_lspconfig plugin
    local mason_lspconfig = require("mason-lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gj<S-k>", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

        opts.desc = "Show Dianostic"
        keymap.set("n", "<leader>i", ":lua vim.diagnostic.open_float(nil, {focus=true, scope=cursor})<CR>")
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    vim.diagnostic.config({ virtual_text = false })

--    mason_lspconfig.setup_handlers({
--      -- default handler for installed servers
--      function(server_name)
--        lspconfig[server_name].setup({
--          capabilities = capabilities,
--        })
--      end,
--      ["lua_ls"] = function()
--        -- configure lua server (with special settings)
--        lspconfig["lua_ls"].setup({
--          capabilities = capabilities,
--          settings = {
--            Lua = {
--              -- make the language server recognize "vim" global
--              diagnostics = {
--                globals = { "vim" },
--              },
--              completion = {
--                callSnippet = "Replace",
--              },
--            },
--          },
--        })
--      end,
--      ["yamlls"] = function()
--        lspconfig["yamlls"].setup({
--          capabilities = capabilities,
--          settings = {
--            yaml = {
--              schemaStore = {
--                enable = true,
--                url = "https://www.schemastore.org/api/json/catalog.json",
--              },
--              validate = true,
--              format = {
--                enable = true
--              },
--              completion = true,
--              hover = true,
--            },
--          },
--        })
--      end,
--      ["pylsp"] = function()
--        lspconfig["pylsp"].setup({
--          capabilities = capabilities,
--          settings = {
--            pylsp = {
--              plugin = {
--                -- For module completion
--                -- https://github.com/python-lsp/python-lsp-server/blob/develop/docs/autoimport.md
--                rope_autoimport = { enabled = true },
--                -- For format
--                ruff = {
--                     enabled = true,
--                     formatEnabled = true,
--                     select = {
--                         -- See ruff linter
--                         "E", "F", "PL"
--                     }
--                },
--              }
--            }
--          }
--        })
--      end
--    })
  end,
}
