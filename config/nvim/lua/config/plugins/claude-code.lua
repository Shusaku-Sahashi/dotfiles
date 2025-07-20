return {
  "coder/claudecode.nvim",
  dependencies = {
    "folke/snacks.nvim"
  },
  config = function ()
    require("claudecode").setup()
    local keymap = vim.keymap

    -- Claude CodeのWindowから移動するには、 <C-\><C-n><C-h> を押す。
    keymap.set("n", "<C-,>", "<cmd>ClaudeCode<cr>", {desc = "Open Claude Code"})
  end,
}

