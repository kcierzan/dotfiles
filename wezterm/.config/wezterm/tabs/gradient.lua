local GradientTabLine = {}
GradientTabLine.__index = GradientTabLine

local LEFT_SEPARATOR <const> = "░▒▓"
local RIGHT_SEPARATOR <const> = "▓▒░"

function GradientTabLine.new(args)
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
    local sections = instance.sections
    local theme = instance.theme.tab_colors
    local separator = direction == "right" and RIGHT_SEPARATOR or LEFT_SEPARATOR

    table.insert(sections, "ResetAttributes")
    table.insert(sections, {
      Background = { Color = theme.statusline_bg },
    })
    table.insert(sections, {
      Foreground = { Color = tab.is_active and theme.active or theme.segment_bg },
    })
    table.insert(sections, { Text = separator })
  end

  instance.insert_tab_body = function(tab)
    local sections = instance.sections
    local theme = instance.theme.tab_colors
    local is_active = tab.is_active
    local bg_color = is_active and theme.active or theme.segment_bg
    local fg_color = is_active and theme.statusline_bg or theme.active

    table.insert(sections, "ResetAttributes")
    table.insert(sections, {
      Background = { Color = bg_color },
    })
    table.insert(sections, {
      Foreground = { Color = fg_color },
    })
    table.insert(sections, { Attribute = { Intensity = "Bold" } })
    table.insert(sections, { Text = tab.tab_index + 1 .. ": " .. tab_title(tab) })
  end

  instance.clear_sections = function()
    instance.sections = {}
  end

  return setmetatable(instance, GradientTabLine)
end

function GradientTabLine:create_tab_formatter()
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

return GradientTabLine
