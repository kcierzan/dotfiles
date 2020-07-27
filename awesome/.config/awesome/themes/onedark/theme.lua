---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local xrdb = xresources.get_current_theme()
local dpi = xresources.apply_dpi
local helpers = require("helpers")

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

-- start with the default theme and override
-- local theme = dofile(themes_path.."default/theme.lua")
local theme = {}

theme.font          = "monospace 8"

-- Colors
theme.xbackground = xrdb.background or "#282C34"
theme.xforeground = xrdb.foreground or "#ABB2BF"
theme.xcolor0     = xrdb.color0     or "#282C34"
theme.xcolor1     = xrdb.color1     or "#E06C75"
theme.xcolor2     = xrdb.color2     or "#98C379"
theme.xcolor3     = xrdb.color3     or "#D19A66"
theme.xcolor4     = xrdb.color4     or "#61afef"
theme.xcolor5     = xrdb.color5     or "#c678dd"
theme.xcolor6     = xrdb.color6     or "#56b6c2"
theme.xcolor7     = xrdb.color7     or "#abb2bf"
theme.xcolor8     = xrdb.color8     or "#5c6370"
theme.xcolor9     = xrdb.color9     or "#be5046"
theme.xcolor10    = xrdb.color10    or "#98c379"
theme.xcolor11    = xrdb.color11    or "#D19A66"
theme.xcolor12    = xrdb.color12    or "#61afef"
theme.xcolor13    = xrdb.color13    or "#c678dd"
theme.xcolor14    = xrdb.color14    or "#56b6c2"
theme.xcolor15    = xrdb.color15    or "#ffffff"

theme.bg_normal     = theme.xcolor0
theme.bg_lighter    = "#393f4a"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = theme.xcolor9
theme.bg_minimize   = "#444444"

theme.fg_normal     = theme.xforeground
theme.fg_focus      = theme.xcolor15
theme.fg_urgent     = theme.xcolor15
theme.fg_minimize   = theme.xcolor15

-- Borders
theme.border_width  = dpi(2)
theme.border_normal = "#000000"
theme.border_focus  = theme.xcolor3
theme.border_marked = theme.xcolor5

-- Gaps
theme.useless_gap = dpi(15)
-- This is used to determine how far from the edge bars should be
theme.screen_margin = dpi(3)

-- Exit screen
theme.exit_screen_bg = theme.xcolor0 .. "DA" -- add transparency
theme.exit_screen_fg = theme.xcolor7
theme.exit_screen_icon_size = dpi(180)

-- Wibar
theme.wibar_position       = "top"
theme.wibar_ontop          = false
theme.wibar_height         = dpi(25)
theme.wibar_opacity        = 0.9
theme.wibar_fg             = theme.xcolor7
theme.wibar_bg             = theme.xcolor0
theme.wibar_border_width   = dpi(0)
theme.wibar_border_radius  = dpi(0)
theme.bg_systray           = theme.bg_normal
theme.wibar_font           = "mono bold 10"
theme.wibar_italic_font    = "mono bold italic 10"
theme.wibar_icomoon_font   = "icomoon 14"
theme.wibar_widget_spacing = dpi(20)

theme.wibar_popup = {}
-- Wibar popup menus
theme.wibar_popup.radius   = dpi(4)
theme.wibar_popup.margins  = dpi(20)
theme.wibar_popup.y_pos    = dpi(28)
theme.wibar_popup.arrow_size = dpi(10)
theme.wibar_popup.spacing = dpi(10)

-- Taglist
theme.taglist_text_font = "Typicons bold 16"
theme.taglist_text_empty = " "
theme.taglist_text_occupied = " "
theme.taglist_text_focused = " "
theme.taglist_text_urgent = "󠅷 "

theme.taglist_text_color_empty    = theme.bg_lighter
theme.taglist_text_color_occupied  = theme.bg_lighter
theme.taglist_text_color_focused  = theme.xcolor2
theme.taglist_text_color_urgent   = theme.xcolor3

-- Notifications
theme.notification_font = "sans 14"
theme.notification_margin = dpi(14)
theme.notification_bg = theme.bg_lighter
theme.notification_fg = theme.fg_normal
theme.notification_shape = helpers.rrect(dpi(8))
theme.notification_position = "top_right"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

theme.wallpaper = themes_path.."default/background.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
-- theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
