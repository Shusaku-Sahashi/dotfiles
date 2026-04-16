local wezterm = require('wezterm')

local config = {}
config.default_prog = { 'wsl.exe', '-d', 'main', '--cd', '~' }

return config
