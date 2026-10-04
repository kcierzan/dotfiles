local M = {}

function M.get_colors()
	local utils = require("heirline.utils")
	local filename_bg = utils.get_highlight("b16_base04").fg
	local git_bg = utils.get_highlight("b16_base03").fg

	return {
		modified_light_fg = utils.get_highlight("b16_base0A").fg,
		cwd_fg = utils.get_highlight("b16_base09").fg,
		branch_fg = utils.get_highlight("b16_base0E").fg,
		override_sp = utils.get_highlight("LspReferenceText").bg,
		statusline_bg = utils.get_highlight("Statusline").bg,
		filename_bg = filename_bg,
		git_bg = git_bg,
		diagnostic_bg = utils.get_highlight("b16_base02").fg,
		directory_bg = utils.get_highlight("b16_base09").fg,
		red = utils.get_highlight("b16_base08").fg,
		orange = utils.get_highlight("b16_base09").fg,
		yellow = utils.get_highlight("b16_base0A").fg,
		green = utils.get_highlight("b16_base0B").fg,
		cyan = utils.get_highlight("b16_base0C").fg,
		blue = utils.get_highlight("b16_base0D").fg,
		purple = utils.get_highlight("b16_base0E").fg,
	}
end

return M
