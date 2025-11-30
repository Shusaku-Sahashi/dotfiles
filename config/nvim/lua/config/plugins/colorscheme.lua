local TRANSPARENT = true

return {
  "rebelot/kanagawa.nvim",
  init = function()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function(args)
        if not vim.startswith(args.match, "kanagawa") then
          return
        end
        vim.g.colors_name = args.match
      end,
    })
  end,
  opts = function()
    return {
      overrides = function(colors)
        local theme = colors.theme
        return {
          -- Telescope {{
          TelescopeTitle = { fg = theme.ui.special, bold = true },
          TelescopePromptNormal = { bg = theme.ui.bg_p1 },
          TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          TelescopePreviewNormal = { bg = theme.ui.bg_dim },
          TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
          -- }}
          -- Copilot {{
          CopilotAnnotation = { bg = theme.ui.bg_p1, italic = true },
          CopilotSuggestion = { bg = theme.ui.bg_p2, italic = true },
          -- }}
        }
      end,
      globalStatus = true,
      transparent = TRANSPARENT,
      compile = true,
    }
  end,
  config = function(_, opts)
    require("kanagawa").setup(opts)
    vim.cmd("colorscheme kanagawa-dragon")
  end,
}
