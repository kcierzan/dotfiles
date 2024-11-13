-- foobar
local wezterm = require("wezterm")
local is_linux <const> = wezterm.target_triple:find("linux")
local config = {}

local theme_name = "kanagawa"
local theme = require("themes/" .. theme_name)

config.colors = theme.wezterm_colors
config.window_background_opacity = 1
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1", "dlig=1" }

config.font = wezterm.font("CaskaydiaCove Nerd Font")
-- config.font = wezterm.font("MonaspiceNe Nerd Font", { weight = "Regular" })
-- config.font_rules = {
--   {
--     italic = false,
--     intensity = "Normal",
--     font = wezterm.font("MonaspiceNe Nerd Font", { weight = "Regular" }),
--   },
--   {
--     intensity = "Bold",
--     font = wezterm.font("MonaspiceNe Nerd Font", { weight = "Bold" }),
--   },
--   {
--     italic = true,
--     font = wezterm.font("MonaspiceRn Nerd Font", { style = "Italic" }),
--   },
--
config.keys = {
  {
    key = "]",
    mods = "CMD|SHIFT",
    action = wezterm.action.ToggleAlwaysOnTop,
  },
}

config.window_padding = {
  bottom = 0,
  left = 0,
  right = 0,
  top = 0,
}

config.front_end = "WebGpu"
config.freetype_load_target = "Light"
config.font_size = 14.0
config.line_height = 1.2
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

config.tab_bar_style = {
  new_tab = wezterm.format({
    { Background = { Color = theme.tab_colors.new.background } },
    { Foreground = { Color = theme.tab_colors.new.foreground } },
    { Text = " " },
  }),
  new_tab_hover = wezterm.format({
    { Background = { Color = theme.tab_colors.new.hover.background } },
    { Foreground = { Color = theme.tab_colors.new.hover.foreground } },
    { Text = " " },
  }),
}

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

local function first_tab(tab)
  return tab.tab_index == 0
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

local function insert_tab_body(sections, tab)
  table.insert(sections, "ResetAttributes")
  if tab.is_active then
    table.insert(sections, { Background = { Color = theme.tab_colors.tab.active.background } })
    table.insert(sections, { Foreground = { Color = theme.tab_colors.tab.active.foreground } })
  else
    table.insert(sections, { Background = { Color = theme.tab_colors.tab.inactive.background } })
    table.insert(sections, { Foreground = { Color = theme.tab_colors.tab.inactive.foreground } })
  end
  table.insert(sections, { Text = " " .. tab.tab_index + 1 .. ": " .. tab_title(tab) .. " " })
end

local function insert_left_separator(sections, tab, tabs)
  table.insert(sections, "ResetAttributes")
  if first_tab(tab) then
    return
  end

  if tab.is_active then
    table.insert(sections, { Background = { Color = theme.tab_colors.left_separator.active.background } })
    table.insert(sections, { Foreground = { Color = theme.tab_colors.left_separator.active.foreground } })
  elseif active_tab_before(tab, tabs) then
    table.insert(sections, { Background = { Color = theme.tab_colors.left_separator.active_tab_before.background } })
    table.insert(sections, { Foreground = { Color = theme.tab_colors.left_separator.active_tab_before.foreground } })
  else
    table.insert(sections, { Background = { Color = theme.tab_colors.left_separator.inactive.background } })
    table.insert(sections, { Foreground = { Color = theme.tab_colors.left_separator.inactive.foreground } })
  end
  table.insert(sections, { Text = SOLID_RIGHT_ARROW })
end

local function insert_right_separator(sections, tab, tabs)
  table.insert(sections, "ResetAttributes")
  if not last_tab(tab, tabs) then
    return
  end
  if tab.is_active then
    table.insert(sections, { Background = { Color = theme.tab_colors.right_separator.active.background } })
    table.insert(sections, { Foreground = { Color = theme.tab_colors.right_separator.active.foreground } })
  else
    table.insert(sections, { Background = { Color = theme.tab_colors.right_separator.inactive.background } })
    table.insert(sections, { Foreground = { Color = theme.tab_colors.right_separator.inactive.foreground } })
  end
  table.insert(sections, { Text = SOLID_RIGHT_ARROW })
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local sections = {}
  insert_left_separator(sections, tab, tabs)
  insert_tab_body(sections, tab)
  insert_right_separator(sections, tab, tabs)
  return sections
end)

if not is_linux then
  config.window_decorations = "RESIZE | MACOS_FORCE_DISABLE_SHADOW"
  config.macos_window_background_blur = 30
end

return config
