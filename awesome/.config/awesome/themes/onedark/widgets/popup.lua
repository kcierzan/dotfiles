local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")

local height = dpi(100)
local width = dpi(500)

local popup = {}

popup.create_popup = function()
   return wibox {
      visible = false,
      ontop = true,
      width = width,
      height = height,
      y = dpi(1100),
      shape = helpers.rrect(dpi(8))
   }
end

popup.create_bulb = function(color)
   return wibox.widget {
      valign = "centered",
      font = "icomoon 36",
      markup = helpers.colorize_text("", color),
      widget = wibox.widget.textbox
   }
end

popup.create_message = function()
   return wibox.widget {
      valign = "centered",
      font = "mono bold 32",
      widget = wibox.widget.textbox
   }
end

popup.create_meter = function(value, overlay, max, color)
   local meter = wibox.widget {
      max_value = max,
      border_width = 0,
      shape = helpers.rrect(dpi(8)),
      background_color = beautiful.bg_lighter,
      color = color,
      value = value,
      widget = wibox.widget.progressbar
   }

   local meter_text = wibox.widget {
      widget = wibox.widget.textbox,
      markup = helpers.colorize_text(overlay, beautiful.bg_lighter),
      font = "mono bold 32",
      valign = "center"
   }

   return wibox.widget {
      {
         meter,
         meter_text,
         layout = wibox.layout.stack,
         horizontal_offset = dpi(10)
      },
      widget = wibox.container.margin,
      margins = dpi(10)
   }
end

return popup
