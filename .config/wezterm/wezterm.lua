local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("FiraCode Nerd Font")
config.front_end = "WebGpu"
config.adjust_window_size_when_changing_font_size = false
config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = "tokyonight_storm"
config.window_background_opacity = 0.75

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.win32_system_backdrop = "Acrylic"

  local wsl_domain = wezterm.default_wsl_domains()[1]
  if wsl_domain ~= nil then
    config.default_domain = wsl_domain.name
  end
end

return config
