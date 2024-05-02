local wezterm = require("wezterm")

return {
  font = wezterm.font_with_fallback({ "FiraCode Nerd Font", "Symbols Nerd Font Mono" }),
  adjust_window_size_when_changing_font_size = false,
  hide_tab_bar_if_only_one_tab = true,
  color_scheme = "tokyonight_storm",
  window_background_opacity = 0.75,
}
