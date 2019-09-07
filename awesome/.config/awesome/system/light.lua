local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("helpers")

local display_name_cmd = "$(xrandr | grep -w connected | cut -f1 -d ' ')"

local light = {}

light.show_brightness_percentage = function ()
   -- sleep is required to allow brightness values to settle...
   awful.spawn.easy_async_with_shell("sleep 0.2; light | grep 'displays:' -A2 | sed -n 2p | awk '{print $3}'",
                                     function(stdout)
                                        local percentage = math.floor(tonumber(stdout) * 100)
                                        naughty.notify({
                                              title = "Light",
                                              text = "Screen brightness changed to " .. percentage .. "%",
                                              timeout = 1,
                                              -- TODO: move this to the theme
                                              font = "sans 14",
                                              bg = beautiful.bg_lighter,
                                              fg = beautiful.fg_normal,
                                              position = "top_middle",
                                              shape = helpers.rrect(dpi(10))
                                        })
   end)
end
-- operation should be one of "+" or "-"
light.change_brightness = function(operation)
   awful.spawn.with_shell("light " .. operation .. " " .. display_name_cmd)
   light.show_brightness_percentage()
end

return light
