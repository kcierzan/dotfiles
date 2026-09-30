return {
	id = "flatwhite-full",
	name = "Flatwhite Full",
	description = "Five soft background families; orange embedded boundaries with inner syntax retained.",
	highlights = function(palette)
		return require("syntax.profiles.flatwhite").highlights(palette, false)
	end,
}
