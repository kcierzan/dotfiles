local awful = require("awful")
local naughty = require("naughty")

local display_name_cmd = "$(xrandr | grep -w connected | cut -f1 -d ' ')"

local light = {}
light.show_brightness_percentage = function ()
   -- sleep a little before we run this...
   awful.spawn.easy_async_with_shell("sleep 0.2; light | grep 'displays:' -A2 | sed -n 2p | awk '{print $3}'",
                                     function(stdout)
                                        local percentage = math.floor(tonumber(stdout) * 100)
                                        naughty.notify({
                                              title = "awesome",
                                              text = "screen brightness changed to " ..percentage .. "%",
                                              timeout = 1
                                        })
   end)
end
-- operation should be one of "+" or "-"
light.change_brightness = function(operation)
   awful.spawn.with_shell("light " .. operation .. " " .. display_name_cmd)
   light.show_brightness_percentage()
end

return light
