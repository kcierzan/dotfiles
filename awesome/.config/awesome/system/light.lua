local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("helpers")

local light = {}

local popup = {
   timeout = 1.5,
   font = beautiful.notification_font,
   margin = beautiful.notification_margin,
   bg = beautiful.notification_bg,
   fg = beautiful.notification_fg,
   position = beautiful.notification_position,
   shape = beautiful.notification_shape
}
-- operation should be one of "+" or "-"
light.change_brightness = function(operation)
   awful.spawn.easy_async_with_shell("light.py " .. operation .. " brightness", function(stdout)
                                        local percentage = math.floor(tonumber(stdout) * 100)
                                        local notification = popup
                                        notification.title = "Screen brightness changed to " .. percentage .. "%"
                                        naughty.notify(notification)
   end)
end

-- operation should be one of "+" or "-"
light.change_temperature = function(operation)
   awful.spawn.easy_async_with_shell("light.py " .. operation .. " temperature", function(stdout)
                                        local notification = popup
                                        notification.title = "Screen temperature changed to " .. stdout:gsub("%s+", "") .. "K"
                                        naughty.notify(notification)
   end)
end

light.toggle_redshift = function()
   awful.spawn.with_shell("rshift 2>&1 /dev/null")
   awful.spawn.easy_async_with_shell("ps aux | grep redshift | grep -v grep", function(stdout)
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
