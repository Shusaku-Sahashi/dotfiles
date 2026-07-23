return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  config = function()
    local bufferline = require("bufferline")

    bufferline.setup({
      options = {
        mode = "tabs", -- show "tabs" on tab.
        indicator = {
          style = 'underline'
        }
      },
    })

    -- set keymaps
    local keymap = vim
        .keymap -- for conciseness
    keymap.set("n", "]b", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
    keymap.set("n", "[b", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous Buffer" })
    keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>")
  end
}
