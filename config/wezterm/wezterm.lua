local wezterm = require 'wezterm';
require('format')
require('status')

return {
  font_size = 15.5,
  font = wezterm.font_with_fallback {
    'UDEV Gothic 35NFLG',
    'JetBrains Mono Thin',
  },
  color_scheme = "kanagawa (Gogh)",

  window_background_opacity = 100,
  macos_window_background_blur = 0,

  use_ime = true,
  automatically_reload_config = true,
  ----------------------------------------
  ---Tab Settings
  ----------------------------------------
  -- hide title bar
  window_decorations = "RESIZE",

  -- Show tab
  show_tabs_in_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,

  -- -- Tab transparancy
  -- window_frame = {
  --   inactive_titlebar_bg = "none",
  --   active_titlebar_bg = "none",
  -- },

  -- Delete tab border line
  colors = {
    tab_bar = {
      inactive_tab_edge = "none",
    },
  },


  -- Keybindings
  keys = require('keybinds').keys,
  key_tables = require('keybinds').key_tables,
  disable_default_key_bindings = true,

  -- Leader key
  leader = { key = 'w', mods = 'CTRL', timeout_milliseconds = 2000 },
}
