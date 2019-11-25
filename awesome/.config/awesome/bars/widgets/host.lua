local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local host_icon = ""
local host_color = beautiful.xcolor6

local icon = wibox.widget{
  valign = "center",
  font = beautiful.wibar_icomoon_font,
  markup = helpers.colorize_text(host_icon, host_color),
  widget = wibox.widget.textbox
}

local hostname = wibox.widget {
  valign = "center",
  font = beautiful.wibar_font,
  widget = wibox.widget.textbox,
}

local host = wibox.widget {
  icon,
  helpers.pad(1),
  hostname,
  layout = wibox.layout.fixed.horizontal
}

awful.spawn.easy_async_with_shell(
  "hostname",
  function(stdout)
    output = stdout:gsub("%s+", "")
    hostname.markup = helpers.colorize_text(output, host_color)
  end)

return host
