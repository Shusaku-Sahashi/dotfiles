return {
  'linrongbin16/gitlinker.nvim',
  cmd = 'GitLink',
  keys = {
    { '<leader>gy', '<cmd>GitLink<cr>',  mode = { 'n', 'v' }, desc = '[gitlinker] copy GitHub link' },
    { '<leader>go', '<cmd>GitLink!<cr>', mode = { 'n', 'v' }, desc = '[gitlinker] open in GitHub' },
  },
  opts = {},
}
