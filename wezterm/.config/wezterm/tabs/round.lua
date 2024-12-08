local RoundTabLine = {}
RoundTabLine.__index = RoundTabLine

local wezterm = require("wezterm")
local LEFT_SEPARATOR <const> = wezterm.nerdfonts.ple_left_half_circle_thick
local RIGHT_SEPARATOR <const> = wezterm.nerdfonts.ple_right_half_circle_thick

function RoundTabLine.new(args)
  local instance = {
    theme = args.theme,
    sections = {},
  }

  local function tab_title(tab)
    local title = tab.tab_title
    if title and #title > 0 then
      return title
    end
    return tab.active_pane.title
  end

  instance.insert_separator = function(tab, direction)
    table.insert(instance.sections, "ResetAttributes")
    if tab.is_active then
      table.insert(instance.sections, {
        Background = { Color = instance.theme.tab_colors.statusline_bg },
      })
      table.insert(instance.sections, {
        Foreground = { Color = instance.theme.tab_colors.active },
      })
    else
      table.insert(instance.sections, {
        Background = { Color = instance.theme.tab_colors.statusline_bg },
      })
      table.insert(instance.sections, {
        Foreground = { Color = instance.theme.tab_colors.segment_bg },
      })
    end
    local separator = direction == "right" and RIGHT_SEPARATOR or LEFT_SEPARATOR
    table.insert(instance.sections, { Text = separator })
  end

  instance.insert_tab_body = function(tab)
    table.insert(instance.sections, "ResetAttributes")
    if tab.is_active then
      table.insert(instance.sections, {
        Background = { Color = instance.theme.tab_colors.active },
      })
      table.insert(instance.sections, {
        Foreground = { Color = instance.theme.tab_colors.statusline_bg },
      })
    else
      table.insert(instance.sections, {
        Background = { Color = instance.theme.tab_colors.segment_bg },
      })
      table.insert(instance.sections, {
        Foreground = { Color = instance.theme.tab_colors.active },
      })
    end
    table.insert(instance.sections, { Attribute = { Intensity = "Bold" } })
    table.insert(instance.sections, { Text = tab.tab_index + 1 .. ": " .. tab_title(tab) })
  end

  instance.clear_sections = function()
    instance.sections = {}
  end

  return setmetatable(instance, RoundTabLine)
end

function RoundTabLine:create_tab_formatter()
  local this = self
  return function(tab, tabs, _panes, _config, _hover, _max_width)
    this.insert_separator(tab, "left")
    this.insert_tab_body(tab)
    this.insert_separator(tab, "right")
    local sections = this.sections
    this.clear_sections()
    return sections
  end
end

return RoundTabLine
