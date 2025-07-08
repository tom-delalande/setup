local wezterm = require("wezterm")

return {
	font = wezterm.font("JetBrains Mono"),
	font_size = 18.0,
	-- font_size = 24.0,
	enable_tab_bar = false,
	window_decorations = "RESIZE",
	color_scheme = "Catppuccin Mocha",
	window_close_confirmation = "NeverPrompt",
	-- window_background_opacity = 0.3,
	-- macos_window_background_blur = 20
	keys = {
		{
			key = "w",
			mods = "CMD",
			action = wezterm.action.CloseCurrentTab({ confirm = false }),
		},
	},
}
