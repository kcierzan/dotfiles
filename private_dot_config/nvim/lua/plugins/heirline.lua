return {
	"rebelot/heirline.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-mini/mini.base16",
		"echanovski/mini.icons",
		"lewis6991/gitsigns.nvim",
	},
	config = function()
		local heirline_utils = require("heirline-config.utils")
		local colors = require("heirline-config.colors")
		local conditions = require("heirline.conditions")
		local separators = require("heirline-config.separators")
		local palette = colors.get_colors()

		local function segment(direction, background, neighbor_background, ...)
			return heirline_utils.segment(
				separators.get,
				separators.get_layout,
				direction,
				palette,
				background,
				neighbor_background,
				false,
				...
			)
		end

		local function segment_with_foreground(direction, background, neighbor_background, ...)
			return heirline_utils.segment(
				separators.get,
				separators.get_layout,
				direction,
				palette,
				background,
				neighbor_background,
				true,
				...
			)
		end

		local mode_backgrounds = {
			n = palette.blue,
			i = palette.green,
			v = palette.purple,
			V = palette.purple,
			["\22"] = palette.purple,
			c = palette.yellow,
			s = palette.cyan,
			S = palette.cyan,
			["\19"] = palette.cyan,
			R = palette.red,
			r = palette.orange,
			["!"] = palette.red,
			t = palette.cyan,
		}

		local function mode_background()
			return mode_backgrounds[vim.fn.mode(1):sub(1, 1)] or palette.blue
		end

		local function different_from(preferred, previous, ...)
			if preferred ~= previous then
				return preferred
			end
			for index = 1, select("#", ...) do
				local candidate = select(index, ...)
				if candidate ~= previous then
					return candidate
				end
			end
			return preferred
		end

		local function has_git_changes()
			local status = vim.b.gitsigns_status_dict
			return status and ((status.added or 0) > 0 or (status.changed or 0) > 0 or (status.removed or 0) > 0)
		end

		local function has_lsp_clients()
			return #vim.lsp.get_clients({ bufnr = 0 }) > 0
		end

		local function has_diagnostics()
			return has_lsp_clients() and #vim.diagnostic.get(0) > 0
		end

		local function visual_active()
			local mode = vim.fn.mode()
			return mode == "v" or mode == "V"
		end

		local function macro_active()
			return vim.fn.reg_recording() ~= ""
		end

		local function is_regular_buffer()
			return not conditions.buffer_matches({ buftype = { "terminal", "TelescopePrompt", "quickfix", "help" } })
		end

		local function file_background()
			return palette.filename_bg
		end

		local function git_background()
			return palette.git_bg
		end

		local function visual_background()
			local previous = has_git_changes() and git_background() or file_background()
			return different_from(palette.purple, previous, palette.cyan, palette.blue)
		end

		local function macro_background()
			local previous = visual_active() and visual_background()
				or (has_git_changes() and git_background())
				or file_background()
			return different_from(palette.red, previous, palette.orange, palette.purple)
		end

		local function file_icon_background()
			local category = vim.bo.filetype ~= "" and "filetype" or "file"
			local name = vim.bo.filetype ~= "" and vim.bo.filetype or vim.api.nvim_buf_get_name(0)
			local _, icon_highlight = require("mini.icons").get(category, name)
			return require("heirline.utils").get_highlight(icon_highlight).fg or palette.filename_bg
		end

		local function diagnostic_background()
			return palette.diagnostic_bg
		end

		local function lsp_background()
			local previous = has_diagnostics() and diagnostic_background() or file_icon_background()
			return different_from(palette.yellow, previous, palette.green, palette.purple)
		end

		local function work_dir_background()
			local previous = has_lsp_clients() and lsp_background()
				or (has_diagnostics() and diagnostic_background())
				or file_icon_background()
			return different_from(palette.directory_bg, previous, palette.blue, palette.green)
		end

		local function branch_background()
			local previous = is_regular_buffer() and work_dir_background() or palette.statusline_bg
			return different_from(palette.purple, previous, palette.green, palette.blue)
		end

		local function after_file_background()
			if has_git_changes() then
				return git_background()
			elseif visual_active() then
				return visual_background()
			elseif macro_active() then
				return macro_background()
			end
			return palette.statusline_bg
		end

		local function after_git_background()
			if visual_active() then
				return visual_background()
			elseif macro_active() then
				return macro_background()
			end
			return palette.statusline_bg
		end

		local function after_visual_background()
			return macro_active() and macro_background() or palette.statusline_bg
		end

		-- Create all components using the component factory functions
		local MacroRec = require("heirline-config.components.macro").new()
		local LSPActive = require("heirline-config.components.lsp").new(palette)
		local VisualWords = require("heirline-config.components.visual_words").new()
		local DiagnosticCount = require("heirline-config.components.diagnostics").new()
		local GitBranch = require("heirline-config.components.git_branch").new(palette)
		local GitAdded = require("heirline-config.components.git_added").new()
		local GitModified = require("heirline-config.components.git_modified").new()
		local GitRemoved = require("heirline-config.components.git_removed").new()
		local FileIcon = require("heirline-config.components.file_icon").new()

		-- Wrapped components in segments
		local Mode = segment("left", mode_background, function()
			return is_regular_buffer() and file_background() or palette.statusline_bg
		end, require("heirline-config.components.mode").new())
		local File = segment_with_foreground(
			"left",
			file_background,
			after_file_background,
			require("heirline-config.components.file").new(palette)
		)
		local InactiveFile = segment_with_foreground(
			"left",
			file_background,
			palette.statusline_bg,
			require("heirline-config.components.file").new(palette)
		)
		local WorkDir = segment("right", work_dir_background, function()
			if has_lsp_clients() then
				return lsp_background()
			elseif has_diagnostics() then
				return diagnostic_background()
			end
			return file_icon_background()
		end, require("heirline-config.components.work_dir").new(palette))

		-- Visual words with condition
		VisualWords = {
			segment("left", visual_background, after_visual_background, VisualWords),
			condition = visual_active,
		}

		-- LSP Active with condition
		LSPActive = {
			segment("right", lsp_background, function()
				return has_diagnostics() and diagnostic_background() or file_icon_background()
			end, LSPActive),
			condition = has_lsp_clients,
		}

		-- Diagnostic Count with condition
		DiagnosticCount = {
			segment_with_foreground("right", diagnostic_background, file_icon_background, DiagnosticCount),
			condition = has_diagnostics,
		}

		GitBranch = {
			segment("right", branch_background, function()
				return is_regular_buffer() and work_dir_background() or palette.statusline_bg
			end, GitBranch),
			condition = function()
				return conditions.is_git_repo()
			end,
		}

		local GitChanges = {
			segment_with_foreground("left", git_background, after_git_background, {
				GitAdded,
				{ provider = " " },
				GitModified,
				{ provider = " " },
				GitRemoved,
			}),
			condition = has_git_changes,
		}

		MacroRec = {
			segment("left", macro_background, palette.statusline_bg, MacroRec),
			condition = macro_active,
		}

		FileIcon = segment("right", file_icon_background, palette.statusline_bg, FileIcon)

		-- Define statuslines
		local ActiveStatusLine = {
			Mode,
			{
				File,
				GitChanges,
				VisualWords,
				MacroRec,
				condition = is_regular_buffer,
			},
			heirline_utils.Align,
			{
				FileIcon,
				DiagnosticCount,
				LSPActive,
				WorkDir,
				condition = is_regular_buffer,
			},
			GitBranch,
			heirline_utils.Space,
			condition = conditions.is_active,
		}

		-- not relevant with global statusline (eg. it is not per-buffer)
		local InactiveStatusLine = {
			InactiveFile,
		}

		require("heirline").setup({
			statusline = {
				ActiveStatusLine,
				InactiveStatusLine,
				fallthrough = false,
			},
		})
	end,
}
