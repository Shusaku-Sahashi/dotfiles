return {
  "coder/claudecode.nvim",
  dependencies = {
    "folke/snacks.nvim"
  },
  config = function()
    require("claudecode").setup()
    local keymap = vim.keymap

    keymap.set("t", "<C-,>", "<c-\\><c-n><Cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code" })
    keymap.set("n", "<C-,>", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code" })
    keymap.set("v", "<leader>cs", "<cmd>ClaudeCodeSend<cr>", { desc = "Send Current Line to Claude Code" })
    keymap.set("n", "<leader>cc", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude Code" })
  end,
}
