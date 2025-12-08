return {
  "coder/claudecode.nvim",
  dependencies = {
    "folke/snacks.nvim"
  },
  config = function()
    require("claudecode").setup()
    local keymap = vim.keymap

    -- currenty this function is not used, but ...
    local function is_claude_running()
      local ok, terminal = pcall(require, "claudecode.terminal")
      if not ok then
        return false
      end

      local bufnr = terminal.get_active_terminal_bufnr()
      return bufnr ~= nil and vim.api.nvim_buf_is_valid(bufnr)
    end

    local function send_and_focus()
      vim.cmd("ClaudeCodeSend")
      vim.cmd("ClaudeCode")
    end

    --keymap.set("t", "<ESC>", '<c-\\><c-n><Plug>(esc)')
    --keymap.set("n", "<Plug>(esc)<ESC>", "i<ESC>")

    keymap.set("t", "<C-,>", "<c-\\><c-n><Cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code" })
    keymap.set("n", "<C-,>", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code" })
    keymap.set("v", "<C-,>", send_and_focus, { desc = "Send Current Lint to Claude Code" })
    keymap.set("n", "<leader>cc", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude Code" })
  end,
}
