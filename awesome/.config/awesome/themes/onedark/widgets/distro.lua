local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local system_icon = ""

local distro_name = wibox.widget {
  font = beautiful.wibar_font,
  widget = wibox.widget.textbox,
  valign = "center"
}

awful.spawn.easy_async_with_shell(
  "distroname",
  function(stdout)
    output = stdout:gsub("\n$", "")
    distro_name.markup = output
  end)

local distro_icon = wibox.widget {
    markup = helpers.colorize_text(system_icon, beautiful.xcolor4),
    font = "mono 30",
    widget = wibox.widget.textbox,
    valign = "center"
}

local distro = wibox.widget {
  distro_icon,
  distro_name,
  spacing = dpi(10),
  layout = wibox.layout.fixed.horizontal
}

return distro
