local wezterm = require 'wezterm';
require('format')
require('status')

return {
	font_size = 15.0,
	font = wezterm.font('HackGen35 Console NF'),
	color_scheme = "Catppuccin Mocha (Gogh)",
	window_background_opacity = 0.93,

	-- Keybindings
	keys = require('keybinds').keys,
	key_tables = require('keybinds').key_tables,
	disable_default_key_bindings = true,

	-- Leader key
	leader = { key = 'w', mods = 'CTRL', timeout_milliseconds = 2000 },
}
