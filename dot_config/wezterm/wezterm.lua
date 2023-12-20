local wezterm = require 'wezterm'

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.default_prog = { "/usr/bin/tmux" }

-- This is where you actually apply your config choices
config.font = wezterm.font 'FiraCode Nerd Font Mono'
config.font_size = 13.0

config.enable_scroll_bar = true

config.color_scheme = 'DoomOne'

return config
