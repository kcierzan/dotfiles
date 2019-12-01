local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local host_icon = ""
local host_color = beautiful.xcolor5

local icon = wibox.widget{
  valign = "center",
  font = "icomoon 22",
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
  hostname,
  spacing = dpi(10),
  layout = wibox.layout.fixed.horizontal
}

awful.spawn.easy_async_with_shell(
  "hostname",
  function(stdout)
    output = stdout:gsub("%s+", "")
    hostname.markup = output
  end)

return host
