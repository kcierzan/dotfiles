-- foobar
local wezterm = require("wezterm")
local is_linux <const> = wezterm.target_triple:find("linux")
local config = {}

local carbon = {
  gray10 = "#f4f4f4",
  gray100 = "#161616",
  gray20 = "#e0e0e0",
  gray30 = "#c6c6c6",
  gray40 = "#a8a8a8",
  gray50 = "#8d8d8d",
  gray60 = "#6f6f6f",
  gray70 = "#525252",
  gray80 = "#393939",
  gray90 = "#262626",
  purple50 = "#a56eff",
  black = "#000000",
  red = "#fa4d56",
  green = "#6fdc8c",
  yellow = "#fddc69",
  blue = "#a6c8ff",
  magenta = "#ff7eb6",
  cyan = "#82cfff",
  white = "#ffffff",
  black_bright = "#393939",
  red_bright = "#fa4d56",
  green_bright = "#24a148",
  yellow_bright = "#d2a106",
  blue_bright = "#4589ff",
  magenta_bright = "#d02679",
  cyan_bright = "#1192e8",
  white_bright = "#c6c6c6",
}

config.colors = {
  background = carbon.gray100,
  foreground = carbon.gray10,
  cursor_bg = carbon.gray30,
  cursor_fg = carbon.gray100,
  cursor_border = carbon.blue_bright,
  ansi = {
    carbon.black,
    carbon.red,
    carbon.green,
    carbon.yellow,
    carbon.blue,
    carbon.magenta,
    carbon.cyan,
    carbon.white,
  },
  brights = {
    carbon.black_bright,
    carbon.red_bright,
    carbon.green_bright,
    carbon.yellow_bright,
    carbon.blue_bright,
    carbon.magenta_bright,
    carbon.cyan_bright,
    carbon.white_bright,
  },
  tab_bar = {
    background = carbon.gray100,
    active_tab = {
      bg_color = carbon.gray80,
      fg_color = carbon.purple50,
    },
    inactive_tab = {
      bg_color = carbon.gray90,
      fg_color = carbon.gray60,
    },
    new_tab = {
      bg_color = carbon.gray80,
      fg_color = carbon.gray10,
    },
  },
}

config.font = wezterm.font("BerkeleyMono Nerd Font")
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
-- }

config.window_padding = {
  bottom = 0,
  left = 0,
  right = 0,
  top = 0,
}

config.front_end = "WebGpu"
config.freetype_load_target = "Light"
config.font_size = 16.0
config.line_height = 1.2
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

config.tab_bar_style = {
  new_tab = wezterm.format({
    { Background = { Color = carbon.gray100 } },
    { Foreground = { Color = carbon.blue_bright } },
    { Text = " " },
  }),
  new_tab_hover = wezterm.format({
    { Background = { Color = carbon.gray100 } },
    { Foreground = { Color = carbon.yellow } },
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
    table.insert(sections, { Background = { Color = carbon.blue_bright } })
    table.insert(sections, { Foreground = { Color = carbon.gray100 } })
  else
    table.insert(sections, { Background = { Color = carbon.gray80 } })
    table.insert(sections, { Foreground = { Color = carbon.gray40 } })
  end
  table.insert(sections, { Text = " " .. tab.tab_index + 1 .. ": " .. tab_title(tab) .. " " })
end

local function insert_left_separator(sections, tab, tabs)
  table.insert(sections, "ResetAttributes")
  if not first_tab(tab) then
    if tab.is_active then
      table.insert(sections, { Background = { Color = carbon.blue_bright } })
      table.insert(sections, { Foreground = { Color = carbon.gray80 } })
    elseif active_tab_before(tab, tabs) then
      table.insert(sections, { Background = { Color = carbon.gray80 } })
      table.insert(sections, { Foreground = { Color = carbon.blue_bright } })
    else
      table.insert(sections, { Background = { Color = carbon.gray80 } })
      table.insert(sections, { Foreground = { Color = carbon.gray80 } })
    end
    table.insert(sections, { Text = SOLID_RIGHT_ARROW })
  end
end

local function insert_right_separator(sections, tab, tabs)
  table.insert(sections, "ResetAttributes")
  if last_tab(tab, tabs) then
    if tab.is_active then
      table.insert(sections, { Background = { Color = carbon.gray100 } })
      table.insert(sections, { Foreground = { Color = carbon.blue_bright } })
    else
      table.insert(sections, { Background = { Color = carbon.gray100 } })
      table.insert(sections, { Foreground = { Color = carbon.gray80 } })
    end
    table.insert(sections, { Text = SOLID_RIGHT_ARROW })
  end
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
end

return config
