return {
	id = "flatwhite-simple",
	name = "Flatwhite Simple",
	description = "Neutral text with five soft background families; orange embedded expressions.",
	highlights = function(palette)
		return require("syntax.profiles.flatwhite").highlights(palette, true)
	end,
}
