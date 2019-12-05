local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

local light = {}

-- styling of the popup is theme based...
-- every theme must define a light widget
local popup = require("themes." .. theme_name .. ".widgets.backlight")

local pop_bar = function(bar_value)
   meter.value = bar_value
   local percent = tostring(bar_value)
   percentage.markup = helpers.colorize_text(percent .. "%", beautiful.bg_lighter)
   popup.visible = true
   gears.timer.new({
         timeout = 1,
         autostart = true,
         single_shot = true,
         callback = function() popup.visible = false end
      })
end

-- operation should be one of "+" or "-"
light.change_brightness = function(operation)
   awful.spawn.easy_async_with_shell(
      "light.py " .. operation .. " brightness",
      function(stdout)
         local percentage = math.floor(tonumber(stdout) * 100)
         pop_bar(percentage)
      end)
end

-- operation should be one of "+" or "-"
light.change_temperature = function(operation)
   awful.spawn.easy_async_with_shell(
      "light.py " .. operation .. " temperature",
      function(stdout)
         local notification = popup
         notification.title = "Screen temperature changed to " .. stdout:gsub("%s+", "") .. "K"
         naughty.notify(notification)
      end)
end

light.toggle_redshift = function()
   awful.spawn.with_shell("rshift 2>&1 /dev/null")
   awful.spawn.easy_async_with_shell(
      "ps aux | grep redshift | grep -v grep",
      function(stdout)
         local notification = popup
         if stdout:gsub("%s+", "") ~= "" then
            notification.title = "Redshift stopped"
            naughty.notify(notification)
         else
            notification.title = "Redshift started"
            naughty.notify(notification)
         end
      end)
end

return light
