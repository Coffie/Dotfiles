local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.color_scheme = "Shapeshifter (dark) (terminal.sexy)"
-- config.color_scheme = "deep"
-- config.color_scheme = "Molokai"
-- config.color_scheme = "MaterialDark"
-- config.color_scheme = "3024 (base16)"
-- config.color_scheme = "Gruvbox dark, hard (base16)"
-- config.color_scheme = "3024 (dark) (terminal.sexy)"
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font("RobotoMono Nerd Font Mono", { weight = "Bold" })
config.font_size = 11
config.line_height = 1
config.freetype_load_flags = "NO_HINTING"
config.term = "wezterm"
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.animation_fps = 60
config.max_fps = 60

-- Disable the default binding for Ctrl+_, allowing it to pass through to zsh/vim (e.g. for undo)
config.keys = {
  { key = "_", mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment },
}

return config
