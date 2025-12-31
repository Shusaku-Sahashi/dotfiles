-- https://github.com/folke/lazy.nvim/discussions/1031
return {
	'mbbill/undotree',
  lazy = false,
  keys = {
    {
      "<leader>u",
      vim.cmd.UndotreeToggle,
      desc = "Toggle undotree",
    },
  },
}
