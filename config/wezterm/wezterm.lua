local wezterm = require 'wezterm';

return {
	font_size = 15.0,
	font = wezterm.font('HackGen Console'),
	color_scheme = "Catppuccin Mocha (Gogh)",
	window_background_opacity = 0.93,

	-- Keybindings
	keys = require('keybinds').keys,
	key_tales = require('keybinds').key_tables,
	disable_default_key_bindings = true,

	-- Leader key
	leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2000 },
}
