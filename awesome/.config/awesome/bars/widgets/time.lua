local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local time_color = beautiful.xcolor3

local time_icon = wibox.widget {
  font = beautiful.wibar_icomoon_font,
  valign = "center",
  markup = helpers.colorize_text("", time_color),
  widget = wibox.widget.textbox
}

-- TODO: what does this format display?
local clock = wibox.widget.textclock(helpers.colorize_text("%l:%M %P", time_color))
clock.font = beautiful.wibar_font

local time = wibox.widget {
  time_icon,
  clock,
  spacing = dpi(3),
  layout = wibox.layout.fixed.horizontal
}

return time
