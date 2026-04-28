return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  keys = {
    { "t]", "<cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
    { "t[", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous tab" },
    { "t]", "<cmd>BufferLineCycleNext<CR>", mode = "t", desc = "Next tab" },
    { "t[", "<cmd>BufferLineCyclePrev<CR>", mode = "t", desc = "Previous tab" },
  },
  opts = {
    options = {
      mode = "tabs", -- show "tabs" on tab.
      indicator = {
        style = 'underline'
      }
    },
  },
}
