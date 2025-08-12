local lib = require("lib")

local M = {}

M.separators = {
  none_left = "█",
  none_right = "█",
  pixels_left = " ",
  pixels_right = "",
  slant_up_left = "",
  slant_up_right = "",
  slant_down_left = "",
  slant_down_right = "",
  round_left = "",
  round_right = "",
  trapezoid_left = "",
  trapezoid_right = "",
  gradient_left = "░▒▓",
  gradient_right = "▓▒░",
}

M.Space = { provider = " " }
M.Align = { provider = "%=" }

function M.segment(separator, palette, scheme_colors, ...)
  local components = { ... }
  local left_sep = M.separators[separator .. "_left"]
  local right_sep = M.separators[separator .. "_right"]

  local padding = {
    M.Space,
    hl = { bg = palette.segment_bg, force = true },
    condition = function()
      return separator == "slant_up" or separator == "slant_down"
    end,
  }

  local function override_bg_highlight(component)
    local hl = component.hl
    local hl_type = type(hl)

    if hl_type == "function" then
      local original_hl = hl
      component.hl = function(self)
        return lib.merge(original_hl(self), { bg = palette.segment_bg, force = true })
      end
    else
      component.hl = lib.merge(hl_type == "table" and hl or {}, { bg = palette.segment_bg, force = true })
    end
  end

  for _, component in ipairs(components) do
    override_bg_highlight(component)
  end

  return {
    M.Space,
    {
      {
        provider = left_sep,
        hl = { fg = palette.segment_bg, bg = palette.statusline_bg },
      },
      padding,
      unpack(components),
      padding,
      {
        provider = right_sep,
        hl = { fg = palette.segment_bg, bg = palette.statusline_bg },
      },
      hl = { underline = false, sp = scheme_colors.override_sp, force = true },
    },
  }
end

return M
