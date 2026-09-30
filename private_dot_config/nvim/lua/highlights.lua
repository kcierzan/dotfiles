-- Highlight overrides for mini.base16
-- This file is symlinked and can be edited without rebuild
--
-- The colors table comes from chezmoi (regenerated on theme change)
-- Edit this file to customize highlight groups, then restart Neovim

local M = {}

function M.create_base16_hl_groups(colors)
	-- create foreground groups (skip non-color metadata keys like "variant")
	for name, value in pairs(colors) do
		if type(value) == "string" and value:match("^#%x%x%x%x%x%x$") then
			vim.api.nvim_set_hl(0, "b16_" .. name, { fg = value })
		end
	end
end

function M.get_overrides(colors)
	-- Highlight group overrides
	-- Value types:
	--   "NONE"           : transparent/no color
	--   colors.baseXX    : reference Base16 color (e.g., colors.base00, colors.base0D)
	--   "#RRGGBB"        : raw hex color
	--   true/false       : for bold, italic, underline, etc.
	--
	-- Add/remove entries here to customize neovim highlights
	return {
		-- Make gutter areas transparent (match main editor background)
		SignColumn = { bg = "NONE" },
		FoldColumn = { bg = "NONE" },
		LineNr = { bg = "NONE", fg = colors.base02 },
		LineNrAbove = { bg = "NONE", fg = colors.base02 },
		LineNrBelow = { bg = "NONE", fg = colors.base02 },
		CursorLineSign = { bg = "NONE" },
		CursorLineFold = { bg = "NONE" },

		-- Git signs
		GitSignsAdd = { bg = "NONE" },
		GitSignsChange = { bg = "NONE" },
		GitSignsUntracked = { bg = "NONE" },
		GitSignsDelete = { bg = "NONE" },

		-- Popup menu
		Pmenu = { bg = colors.base02 },
		PmenuThumb = { bg = colors.base05 },

		-- Flash
		FlashLabel = { bg = colors.base0E, fg = colors.base00 },
		FlashMatch = { bg = colors.base02, fg = colors.base00 },

		-- Windows
		WinSeparator = { bg = "NONE", fg = colors.base02 },
		StatusLine = { bg = colors.base01 },

		-- used for snacks picker paths...
		NonText = { bg = "NONE", fg = colors.base04 },
		LspInlayHint = { fg = colors.base02 },

		-- mini diagnostics
		DiagnosticFloatingOk = { bg = "NONE", fg = colors.base0B },
		DiagnosticFloatingWarn = { bg = "NONE", fg = colors.base0A },
		DiagnosticFloatingHint = { bg = "NONE", fg = colors.base0D },
		DiagnosticFloatingInfo = { bg = "NONE", fg = colors.base0D },
		DiagnosticFloatingError = { bg = "NONE", fg = colors.base08 },

		-- blink.cmp completion
		BlinkCmpMenuSelection = { bg = colors.base03, bold = true },
		BlinkCmpKind = { bg = colors.base04, fg = colors.base00 },
		BlinkCmpKindSnippet = { bg = colors.base0A, fg = colors.base00 },
		BlinkCmpKindFunction = { bg = colors.base0D, fg = colors.base00 },
		BlinkCmpKindField = { bg = colors.base0D, fg = colors.base00 },
		BlinkCmpKindFolder = { bg = colors.base0C, fg = colors.base00 },
		BlinkCmpKindClass = { bg = colors.base09, fg = colors.base00 },
		BlinkCmpKindConstant = { bg = colors.base09, fg = colors.base00 },
		BlinkCmpKindStruct = { bg = colors.base09, fg = colors.base00 },
		BlinkCmpKindKeyword = { bg = colors.base0E, fg = colors.base00 },
		BlinkCmpKindText = { bg = colors.base0B, fg = colors.base00 },
	}
end

return M
