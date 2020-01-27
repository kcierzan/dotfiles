local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")
local naughty = require("naughty")
local ins = require("inspect")

local popup_lib = require_widget("popup")
local redshift = {}

redshift.status_popup = popup_lib.create_popup()
awful.placement.center_horizontal(redshift.status_popup)
redshift.status_bulb = popup_lib.create_bulb(beautiful.xcolor1)
redshift.status_message = popup_lib.create_message()

redshift.temp_popup = popup_lib.create_popup()
awful.placement.center_horizontal(redshift.temp_popup)
redshift.temp_message = popup_lib.create_message()

redshift.status_popup:setup {
   {
      redshift.status_bulb,
      redshift.status_message,
      spacing = dpi(4),
      layout = wibox.layout.fixed.horizontal
   },
   widget = wibox.container.margin,
   margins = dpi(8)
}

redshift.flash_status = function(status)
   if status == "on" then
      redshift.status_popup.visible = true
      redshift.status_bulb.markup = helpers.colorize_text("", beautiful.xcolor1)
      redshift.status_message.markup = helpers.colorize_text("Redshift started", beautiful.xcolor1)
      gears.timer.new({
            timeout = 1,
            autostart = true,
            single_shot = true,
            callback = function() redshift.status_popup.visible = false end
         })
   elseif status == "off" then
      redshift.status_popup.visible = true
      redshift.status_bulb.markup = helpers.colorize_text("", beautiful.xcolor4)
      redshift.status_message.markup = helpers.colorize_text("Redshift stopped", beautiful.xcolor4)
      gears.timer.new({
            timeout = 1,
            autostart = true,
            single_shot = true,
            callback = function() redshift.status_popup.visible = false end
         })
   end
end

redshift.flash_temperature = function(temp)
   local color
   local value
   local temps = {1500, 2000, 2500, 3500, 4000, 5000, 6000, 6500}

   for i, temperature in ipairs(temps) do
      if temp == temperature then
         value = { temp .. "K", i }
      end
   end

   if value[2] > 6 then
      color = beautiful.xcolor4
   elseif value[2] > 3 then
      color = beautiful.xcolor3
   else
      color = beautiful.xcolor1
   end

   local bulb = popup_lib.create_bulb(color)
   local meter = popup_lib.create_meter(value[2], value[1], 8, color)

   redshift.temp_popup:setup {
      {
         bulb,
         meter,
         spacing = dpi(4),
         layout = wibox.layout.fixed.horizontal
      },
      widget = wibox.container.margin,
      margins = dpi(8)
   }

   redshift.temp_popup.visible = true
   gears.timer.new({
         timeout = 1,
         autostart = true,
         single_shot = true,
         callback = function() redshift.temp_popup.visible = false end
      })
end

return redshift
