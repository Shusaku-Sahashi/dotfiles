# Markdown file setting
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    -- Enable line wrapping and set text width for markdown files
    vim.opt_local.wrap = true
    -- Set text width to 100 characters and show a color column at 101 characters
    vim.opt_local.textwidth = 100
    vim.opt_local.colorcolumn = "101"
  end,
})
