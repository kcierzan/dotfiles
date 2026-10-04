-- Highlight overrides for mini.base16
-- This file is symlinked and can be edited without rebuild
--
-- The colors table comes from chezmoi (regenerated on theme change)
-- Edit this file to customize highlight groups, then restart Neovim

local M = {}

local function contrasting_text(background)
	local function channel(offset)
		local value = tonumber(background:sub(offset, offset + 1), 16) / 255
		return value <= 0.04045 and value / 12.92 or ((value + 0.055) / 1.055) ^ 2.4
	end

	local luminance = 0.2126 * channel(2) + 0.7152 * channel(4) + 0.0722 * channel(6)
	return luminance > 0.179 and "#000000" or "#ffffff"
end

local function completion_kind(background)
	return { bg = background, fg = contrasting_text(background) }
end

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
		BlinkCmpLabelMatch = { link = "BlinkCmpLabel" },
		BlinkCmpMenuSelection = { bg = colors.base03, bold = true },
		BlinkCmpKind = completion_kind(colors.base04),
		BlinkCmpKindText = completion_kind(colors.base0B),
		BlinkCmpKindMethod = completion_kind(colors.base0D),
		BlinkCmpKindFunction = completion_kind(colors.base0D),
		BlinkCmpKindConstructor = completion_kind(colors.base0A),
		BlinkCmpKindField = completion_kind(colors.base0C),
		BlinkCmpKindVariable = completion_kind(colors.base08),
		BlinkCmpKindClass = completion_kind(colors.base09),
		BlinkCmpKindInterface = completion_kind(colors.base0A),
		BlinkCmpKindModule = completion_kind(colors.base0C),
		BlinkCmpKindProperty = completion_kind(colors.base0C),
		BlinkCmpKindUnit = completion_kind(colors.base0E),
		BlinkCmpKindValue = completion_kind(colors.base09),
		BlinkCmpKindEnum = completion_kind(colors.base09),
		BlinkCmpKindKeyword = completion_kind(colors.base0E),
		BlinkCmpKindSnippet = completion_kind(colors.base0A),
		BlinkCmpKindColor = completion_kind(colors.base08),
		BlinkCmpKindFile = completion_kind(colors.base0B),
		BlinkCmpKindReference = completion_kind(colors.base0C),
		BlinkCmpKindFolder = completion_kind(colors.base0C),
		BlinkCmpKindEnumMember = completion_kind(colors.base09),
		BlinkCmpKindConstant = completion_kind(colors.base09),
		BlinkCmpKindStruct = completion_kind(colors.base09),
		BlinkCmpKindEvent = completion_kind(colors.base08),
		BlinkCmpKindOperator = completion_kind(colors.base0E),
		BlinkCmpKindTypeParameter = completion_kind(colors.base0A),
	}
end

return M
