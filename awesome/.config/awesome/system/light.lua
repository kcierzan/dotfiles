local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("helpers")

local display_name_cmd = "$(xrandr | grep -w connected | cut -f1 -d ' ')"

local light = {
   report_cmd = "sleep 0.2; light | grep 'displays:' -A2 | sed -n 2p | awk '{print "
}


light.get_light_state = function (command, feature)
   -- sleep is required to allow brightness values to settle...
   awful.spawn.easy_async_with_shell(command,
                                     function(stdout, stderr, exitreason, exitcode)
                                        local percentage = math.floor(tonumber(stdout) * 100)
                                        text = "Screen " .. feature .. " changed to " .. percentage .. "%"
                                        -- 70 is the default temperature
                                        if feature == "temperature" and percentage == 70 then
                                          text = "Screen " .. feature .. " reset to default"
                                        end
                                        naughty.notify({
                                              title = "Light",
                                              text = text,
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
   local command = light.report_cmd .. "$3" .. "}'"
   awful.spawn.with_shell("light " .. operation .. " " .. display_name_cmd)
   light.get_light_state(command, "brightness")
end

-- operation should be one of "+" or "-"
light.change_temperature = function(operation)
   local command = light.report_cmd .. "$7" .. "}'"
   awful.spawn.with_shell("light " .. operation .. " " .. display_name_cmd .. " --temp")
   light.get_light_state(command, "temperature")
end

return light
