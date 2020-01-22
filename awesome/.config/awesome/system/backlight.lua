local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

local light = {}

-- styling of the popup is theme based...
-- every theme must define a light widget
local backlight = require_widget("backlight")
local redshift = require_widget("redshift")

-- operation should be one of "+" or "-"
light.change_brightness = function(operation)
   awful.spawn.easy_async_with_shell(
      "light.py " .. operation .. " brightness",
      function(stdout)
         local percentage = math.floor(tonumber(stdout) * 100)
         backlight.flash_brightness(percentage)
      end)
end

-- operation should be one of "+" or "-"
light.change_temperature = function(operation)
   awful.spawn.easy_async_with_shell(
      "light.py " .. operation .. " temperature",
      function(stdout)
         redshift.flash_temperature(stdout:gsub("%s+", ""))
      end)
end

light.toggle_redshift = function()
   awful.spawn.with_shell("rshift 2>&1 /dev/null")
   awful.spawn.easy_async_with_shell(
      "ps aux | grep redshift | grep -v grep",
      function(stdout)
         local notification = popup
         if stdout:gsub("%s+", "") ~= "" then
            redshift.flash_status("off")
         else
            redshift.flash_status("on")
         end
      end)
end

return light
