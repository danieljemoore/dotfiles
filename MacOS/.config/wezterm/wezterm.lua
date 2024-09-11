-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
-- For example, changing the color scheme:
config.color_scheme = "nord"

-- and finally, return the configuration to wezterm
return config
