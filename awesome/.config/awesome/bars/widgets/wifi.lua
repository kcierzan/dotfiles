local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")

local icon = wibox.widget {
  valign = "center",
  font = beautiful.wibar_icomoon_font,
  markup = helpers.colorize_text("", beautiful.xcolor2),
  widget = wibox.widget.textbox
}

local network_name = wibox.widget {
  valign = "center",
  font = beautiful.wibar_italic_font,
  widget = wibox.widget.textbox
}

local strength_bar = wibox.widget{
    max_value     = 100,
    value         = 50,
    forced_height = dpi(10),
    margins       = {
        top = dpi(8),
        bottom = dpi(8),
    },
    forced_width  = dpi(80),
    shape         = gears.shape.rounded_bar,
    bar_shape     = gears.shape.rounded_bar,
    color         = beautiful.xcolor2,
    background_color = beautiful.bg_lighter,
    border_width  = 0,
    border_color  = beautiful.xcolor3,
    widget        = wibox.widget.progressbar,
}

local wifi = wibox.widget {
  icon,
  network_name,
  strength_bar,
  spacing = dpi(8),
  layout = wibox.layout.fixed.horizontal
}

awesome.connect_signal("signals::wifi", function(name, strength)
                         if tonumber(strength) ~= nil then
                            strength_bar.value = tonumber(strength)
                         else
                           strength_bar.value = 0
                         end

                         network_name.text = name
end)

return wifi
