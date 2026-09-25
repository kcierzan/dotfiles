-- Highlight overrides for mini.base16
-- This file is symlinked and can be edited without rebuild
--
-- The colors table comes from chezmoi (regenerated on theme change)
-- Edit this file to customize highlight groups, then restart Neovim

local M = {}

-- Load the chezmoi-generated Base16 palette
local function load_colors()
	local colors_path = vim.fn.stdpath("data") .. "/base16-colors.lua"
	local ok, palette = pcall(dofile, colors_path)
	if ok and palette and next(palette) ~= nil then
		return palette
	end
	return nil
end

function M.create_base16_hl_groups()
	local colors = load_colors()
	if not colors then
		return nil
	end

	-- create foreground groups (skip non-color metadata keys like "variant")
	for name, value in pairs(colors) do
		if type(value) == "string" and value:match("^#%x%x%x%x%x%x$") then
			vim.api.nvim_set_hl(0, "b16_" .. name, { fg = value })
		end
	end
end

function M.get_overrides()
	local colors = load_colors()
	if not colors then
		return {}
	end

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

		-- Syntax
		SpecialChar = { fg = colors.base04 }, -- ruby symbols link to this
		Delimiter = { fg = colors.base04 },
		Variable = { fg = colors.base05 },
		["@module"] = { fg = colors.base0C },

		-- ruby
		["@string.special.symbol.ruby"] = { fg = colors.base0C },
		["@function.call.ruby"] = { fg = colors.base0D },
		["@variable.ruby"] = { link = "Variable" },
		["@function.ruby"] = { fg = colors.base0D },
		["@keyword.type.ruby"] = { fg = colors.base0E, bold = true },
		["@variable.parameter.ruby"] = { link = "Variable" },
		["@keyword.ruby"] = { fg = colors.base0E, bold = true },
		["@function.builtin.ruby"] = { link = "@function.ruby" },
		["@keyword.function.ruby"] = { fg = colors.base0E, bold = true },
		["@type.ruby"] = { fg = colors.base0A, bold = true },
		["@constant.ruby"] = { fg = colors.base09 },
		["@constant.builtin.ruby"] = { link = "@constant.ruby" },
		["@keyword.exception.ruby"] = { fg = colors.base08, bold = true },
		["@comment.documentation.ruby"] = { link = "@comment.ruby" },
		["@comment.ruby"] = { fg = colors.base03, italic = true },
		["@keyword.conditional.ruby"] = { fg = colors.base0F, bold = true },
		["@operator.ruby"] = { link = "Operator" },

		-- lua
		["@keyword.lua"] = { fg = colors.base0E, bold = true },

		-- zig
		["@punctuation.delimiter.zig"] = { fg = colors.base05 },
		["@punctuation.bracket.zig"] = { fg = colors.base04 },
		["@comment.zig"] = { fg = colors.base03 },

		-- Types: yellow; constants: orange; functions: blue; variables: neutral;
		-- modules and special symbols: cyan. Match the Tree-sitter palette.
		["@lsp.type.class"] = { link = "@type" },
		["@lsp.type.decorator"] = { fg = colors.base0C },
		["@lsp.type.enum"] = { link = "@type" },
		["@lsp.type.enumMember"] = { link = "@constant" },
		["@lsp.type.event"] = { fg = colors.base0C },
		["@lsp.type.function"] = { link = "@function" },
		["@lsp.type.interface"] = { link = "@type" },
		["@lsp.type.macro"] = { fg = colors.base0C },
		["@lsp.type.method"] = { link = "@function.method" },
		["@lsp.type.namespace"] = { link = "@module" },
		["@lsp.type.parameter"] = { link = "@variable.parameter" },
		["@lsp.type.property"] = { link = "@variable.member" },
		["@lsp.type.struct"] = { link = "@type" },
		["@lsp.type.type"] = { link = "@type" },
		["@lsp.type.typeParameter"] = { link = "@type" },
		["@lsp.type.variable"] = { link = "@variable" },

		-- Preserve Ruby's language-specific Tree-sitter colors.
		["@lsp.type.class.ruby"] = { link = "@type.ruby" },
		["@lsp.type.type.ruby"] = { link = "@type.ruby" },

		-- Tree-sitter already handles syntax categories; LSP adds symbol meaning.
		["@lsp.type.comment"] = {},
		["@lsp.type.keyword"] = {},
		["@lsp.type.modifier"] = {},
		["@lsp.type.number"] = {},
		["@lsp.type.operator"] = {},
		["@lsp.type.regexp"] = {},
		["@lsp.type.string"] = {},

		["@lsp.mod.deprecated"] = { fg = colors.base08, strikethrough = true },
		["@lsp.mod.readonly"] = { italic = true },

		-- nix
		["@string.special.path.nix"] = { fg = colors.base0D },

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
