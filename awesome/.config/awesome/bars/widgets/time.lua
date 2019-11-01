local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local calendar_color = beautiful.xcolor5
local time_color = beautiful.xcolor3
local font = beautiful.wibar_font

local time_icon = wibox.widget {
  font = beautiful.wibar_icomoon_font,
  valign = "center",
  markup = helpers.colorize_text("", beautiful.xcolor3),
  widget = wibox.widget.textbox
}

local date_icon = wibox.widget {
  font = beautiful.wibar_icomoon_font,
  valign = "center",
  markup = helpers.colorize_text("", beautiful.xcolor5),
  widget = wibox.widget.textbox
}

-- TODO: what does this format display?
local time = wibox.widget.textclock(helpers.colorize_text("%l:%M %P", time_color))

-- TODO: what does this format display?
local calendar = wibox.widget.textclock(helpers.colorize_text("%m/%d/%y", calendar_color))

time.font = font
calendar.font = font

local wrapper = wibox.widget {
  date_icon,
  helpers.pad(1),
  calendar,
  helpers.pad(2),
  time_icon,
  -- helpers.pad(1),
  time,
  layout = wibox.layout.fixed.horizontal
}

return wrapper
