local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("helpers")

local light = {}

-- TODO: "text" property is going away as of awesome 4.4
local popup = {
   timeout = 1.5,
   font = "sans 14",
   margin = dpi(12),
   bg = beautiful.bg_lighter,
   fg = beautiful.fg_normal,
   position = "top_right",
   shape = helpers.rrect(dpi(8))
}
-- operation should be one of "+" or "-"
light.change_brightness = function(operation)
   awful.spawn.easy_async_with_shell("light.py " .. operation .. " brightness", function(stdout)
                                        local percentage = math.floor(tonumber(stdout) * 100)
                                        local notification = popup
                                        -- local percentage = stdout
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
