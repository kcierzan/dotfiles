local wibox = require("wibox")
local beautiful = require("beautiful")

local calendar_color = beautiful.xcolor5
local time_color = beautiful.xcolor3
local font = beautiful.wibar_font

-- TODO: what does this format display?
local time = wibox.widget.textclock(helpers.colorize_text("%l:%M %P", time_color))

-- TODO: what does this format display?
local calendar = wibox.widget.textclock(helpers.colorize_text("%A, %B %d %Y", calendar_color))

time.font = font
calendar.font = font

local wrapper = wibox.widget {
  calendar,
  time,
  layout = wibox.layout.fixed.horizontal
}

return wrapper
