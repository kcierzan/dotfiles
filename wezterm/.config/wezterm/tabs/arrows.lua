local ArrowTabLine = {}
ArrowTabLine.__index = ArrowTabLine

local wezterm = require("wezterm")
local SOLID_RIGHT_ARROW <const> = wezterm.nerdfonts.pl_left_hard_divider

function ArrowTabLine.new(args)
  local instance = {
    theme = args.theme,
    sections = {},
  }

  local function first_tab(tab)
    return tab.tab_index == 0
  end

  local function tab_title(tab)
    local title = tab.tab_title
    if title and #title > 0 then
      return title
    end
    return tab.active_pane.title
  end

  local function last_tab(tab, tabs)
    return tab.tab_index + 1 == #tabs
  end

  local function active_tab_index(tabs)
    for _, tab in ipairs(tabs) do
      if tab.is_active then
        return tab.tab_index
      end
    end
  end

  local function active_tab_before(tab, tabs)
    if active_tab_index(tabs) + 1 == tab.tab_index then
      return true
    end
    return false
  end

  instance.insert_tab_body = function(tab)
    table.insert(instance.sections, "ResetAttributes")
    if tab.is_active then
      table.insert(instance.sections, { Background = { Color = instance.theme.tab_colors.active } })
      table.insert(instance.sections, { Foreground = { Color = instance.theme.tab_colors.statusline_bg } })
    else
      table.insert(instance.sections, { Background = { Color = instance.theme.tab_colors.segment_bg } })
      table.insert(instance.sections, { Foreground = { Color = instance.theme.tab_colors.active } })
    end
    table.insert(instance.sections, { Text = " " .. tab.tab_index + 1 .. ": " .. tab_title(tab) .. " " })
  end

  instance.insert_right_separator = function(tab, tabs)
    table.insert(instance.sections, "ResetAttributes")
    if not last_tab(tab, tabs) then
      return
    end
    if tab.is_active then
      table.insert(instance.sections, { Background = { Color = instance.theme.tab_colors.statusline_bg } })
      table.insert(instance.sections, { Foreground = { Color = instance.theme.tab_colors.active } })
    else
      table.insert(instance.sections, { Background = { Color = instance.theme.tab_colors.statusline_bg } })
      table.insert(instance.sections, { Foreground = { Color = instance.theme.tab_colors.segment_bg } })
    end
    table.insert(instance.sections, { Text = SOLID_RIGHT_ARROW })
  end

  instance.insert_left_separator = function(tab, tabs)
    table.insert(instance.sections, "ResetAttributes")
    if first_tab(tab) then
      return
    end

    if tab.is_active then
      table.insert(instance.sections, { Background = { Color = instance.theme.tab_colors.active } })
      table.insert(instance.sections, { Foreground = { Color = instance.theme.tab_colors.segment_bg } })
    elseif active_tab_before(tab, tabs) then
      table.insert(instance.sections, { Background = { Color = instance.theme.tab_colors.segment_bg } })
      table.insert(instance.sections, { Foreground = { Color = instance.theme.tab_colors.active } })
    else
      table.insert(instance.sections, { Background = { Color = instance.theme.tab_colors.segment_bg } })
      table.insert(instance.sections, { Foreground = { Color = instance.theme.tab_colors.segment_bg } })
    end
    table.insert(instance.sections, { Text = SOLID_RIGHT_ARROW })
  end

  instance.clearsections = function()
    instance.sections = {}
  end

  return setmetatable(instance, ArrowTabLine)
end

function ArrowTabLine:create_tab_formatter()
  local this = self
  return function(tab, tabs, _panes, _config, _hover, max_width)
    this.insert_left_separator(tab, tabs)
    this.insert_tab_body(tab)
    this.insert_right_separator(tab, tabs)
    local sections = this.sections
    this.clearsections()
    return sections
  end
end

return ArrowTabLine
