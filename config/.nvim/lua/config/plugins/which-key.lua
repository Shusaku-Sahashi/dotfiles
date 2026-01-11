return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  config = function()
    local wk = require('which-key')
    wk.add({
      { "<leader>t", group = "Tab manipulation. Split Window etc..." },
      { "<leader>f", group = "File search" },
      { "<leader>h", group = "Manipulate git (gitsign)" },
      { "<leader>a", group = "Sidekick" }
    })
  end,
}
