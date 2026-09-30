local M = {}

function M.get_colors()
	local utils = require("heirline.utils")
	return {
		segment_bg = utils.get_highlight("b16_base01").fg,
		normal_mode_fg = utils.get_highlight("b16_base0B").fg,
		insert_mode_fg = utils.get_highlight("b16_base0A").fg,
		file_path_fg = utils.get_highlight("b16_base0C").fg,
		file_name_fg = utils.get_highlight("b16_base05").fg,
		modified_light_fg = utils.get_highlight("b16_base0A").fg,
		lsp_fg = utils.get_highlight("b16_base0A").fg,
		cwd_fg = utils.get_highlight("b16_base09").fg,
		branch_fg = utils.get_highlight("b16_base0E").fg,
		jj_rev_fg = utils.get_highlight("b16_base09").fg,
		jj_description_fg = utils.get_highlight("b16_base05").fg,
		jj_bookmark_fg = utils.get_highlight("Bookmark").fg,
		override_sp = utils.get_highlight("LspReferenceText").bg,
		statusline_bg = utils.get_highlight("Statusline").bg,
	}
end

return M
