local wezterm = require("wezterm")

return {
	font = wezterm.font("JetBrains Mono"),
	font_size = 18.0,
	enable_tab_bar = false,
	window_decorations = "RESIZE",
	color_scheme = "Catppuccin Mocha",
	window_close_confirmation = "NeverPrompt",
	keys = {
		{
			key = "w",
			mods = "CMD",
			action = wezterm.action.CloseCurrentTab({ confirm = false }),
		},
	},
}
