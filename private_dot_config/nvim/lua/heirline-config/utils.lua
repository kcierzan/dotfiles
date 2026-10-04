local lib = require("lib")

local M = {}

M.separators = {
	none_left = "",
	none_right = "",
	block_left = "█",
	block_right = "█",
	rounded_left = "",
	rounded_right = "",
	arrow_left = "",
	arrow_right = "",
	slant_left = "",
	slant_right = "",
	slant_down_left = "",
	slant_down_right = "",
	gradient_left = "░▒▓",
	gradient_right = "▓▒░",
}

M.Space = { provider = " " }
M.Align = { provider = "%=" }

function M.segment(separator, layout, direction, palette, background, neighbor_background, preserve_foreground, ...)
	local components = { ... }

	local function resolve(value, self)
		return type(value) == "function" and value(self) or value
	end
	local function resolve_background(self)
		return resolve(background, self)
	end
	local function resolve_neighbor_background(self)
		return resolve(neighbor_background, self) or palette.statusline_bg
	end
	local function resolve_separator(side)
		local style = type(separator) == "function" and separator() or separator
		return assert(M.separators[style .. "_" .. side], "unknown heirline separator: " .. style)
	end
	local function resolve_layout()
		return type(layout) == "function" and layout() or layout
	end
	local function block_hl(self)
		local highlight = {
			bg = resolve_background(self),
			force = not preserve_foreground,
		}
		if not preserve_foreground then
			highlight.fg = palette.statusline_bg
		end
		return highlight
	end

	local function override_highlight(component)
		for _, child in ipairs(component) do
			if type(child) == "table" then
				override_highlight(child)
			end
		end

		local hl = component.hl
		local hl_type = type(hl)

		if hl_type == "function" then
			local original_hl = hl
			component.hl = function(self)
				return lib.merge(original_hl(self), block_hl(self))
			end
		else
			component.hl = function(self)
				return lib.merge(hl_type == "table" and hl or {}, block_hl(self))
			end
		end
	end

	for _, component in ipairs(components) do
		override_highlight(component)
	end

	local separator_hl = function(self)
		return {
			fg = resolve_background(self),
			bg = resolve_layout() == "airline" and resolve_neighbor_background(self) or palette.statusline_bg,
		}
	end
	local block_space = { provider = " ", hl = block_hl }
	local gap = {
		provider = function()
			return resolve_layout() == "chips" and " " or ""
		end,
	}

	return {
		gap,
		{
			{
				provider = function()
					if resolve_layout() == "chips" or direction == "right" then
						return resolve_separator("left")
					end
					return ""
				end,
				hl = separator_hl,
			},
			block_space,
			unpack(components),
			block_space,
			{
				provider = function()
					if resolve_layout() == "chips" or direction == "left" then
						return resolve_separator("right")
					end
					return ""
				end,
				hl = separator_hl,
			},
			hl = { underline = false, sp = palette.override_sp, force = true },
		},
	}
end

return M
