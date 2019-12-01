local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local calendar_color = beautiful.xcolor5

local date_icon = wibox.widget {
  font = beautiful.wibar_icomoon_font,
  valign = "center",
  markup = helpers.colorize_text("", calendar_color),
  widget = wibox.widget.textbox
}

local calendar = wibox.widget.textclock(helpers.colorize_text("%m/%d/%y", calendar_color))
calendar.font = beautiful.wibar_font

local date = wibox.widget {
  date_icon,
  calendar,
  spacing = dpi(3),
  layout = wibox.layout.fixed.horizontal
}

return date
