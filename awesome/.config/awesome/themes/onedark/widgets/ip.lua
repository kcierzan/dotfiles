local gears = require("gears")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")

local ip_widget = wibox.widget {
  font = beautiful.wibar_font,
  widget = wibox.widget.textbox,
}

function get_ip()
   local ip_address = helpers.http.get("https://ifconfig.me", true)["body"][1]
   ip_widget.markup = helpers.colorize_text(ip_address, beautiful.xcolor3)
end

-- get the ip address asynchronously to avoid blocking startup
gears.timer({
      timeout = 1,
      single_shot = true,
      autostart = true,
      callback = get_ip
   })

return ip_widget
