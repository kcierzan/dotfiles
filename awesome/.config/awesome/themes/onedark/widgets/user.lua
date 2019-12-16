local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local user_icon = ""
local user_color = beautiful.xcolor2

local icon = wibox.widget {
  valign = "center",
  font = "icomoon 22",
  markup = helpers.colorize_text(user_icon, user_color),
  widget = wibox.widget.textbox
}

local whoami = wibox.widget {
  valign = "center",
  font = beautiful.wibar_font,
  widget = wibox.widget.textbox
}

local user = wibox.widget {
  icon,
  whoami,
  spacing = dpi(10),
  layout = wibox.layout.fixed.horizontal
}

awful.spawn.easy_async_with_shell(
   "whoami",
   function(stdout)
      output = stdout:gsub("%s+", "")
      whoami.markup = output
end)

return user
