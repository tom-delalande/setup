local wezterm = require("wezterm")

return {
	font = wezterm.font("JetBrains Mono"),
	font_size = 18.0,
	default_cwd = wezterm.home_dir .. "/dev",
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = false,
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
