local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.hide_tab_bar_if_only_one_tab = true

config.window_decorations = "RESIZE" -- Enable for MacOS

config.color_scheme = "tokyonight"
--config.color_scheme = "nord"

return config
