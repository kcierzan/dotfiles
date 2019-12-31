local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")
local wibox = require("wibox")

local height = dpi(100)
local width = dpi(600)

local popup_lib = require_widget("popup")
local backlight = {}

backlight.popup = popup_lib.create_popup()
awful.placement.center_horizontal(popup)
backlight.bulb = popup_lib.create_bulb(beautiful.xcolor3)

backlight.flash_brightness = function(brightness)
   local meter = popup_lib.create_meter(brightness, brightness .. "%", 100, beautiful.xcolor3)
   backlight.popup:setup {
      {
         backlight.bulb,
         meter,
         spacing = dpi(4),
         layout = wibox.layout.fixed.horizontal
      },
      widget = wibox.container.margin,
      margins = dpi(8)
   }

   awful.placement.center_horizontal(backlight.popup)

   backlight.popup.visible = true
   gears.timer.new({
         timeout = 1,
         autostart = true,
         single_shot = true,
         callback = function() backlight.popup.visible = false end
      })
end

return backlight
