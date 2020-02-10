local awful = require("awful")
local naughty = require("naughty")
local helpers = require("helpers")
local tablex = require("pl.tablex")
local ins = require("inspect")

local light = {}

-- styling of the popup is theme based
-- every theme MUST define a backlight and redshift widget
local backlight = require_widget("backlight")
local redshift = require_widget("redshift")

light.presets = {
   {
      temp = 1500,
      gamma = {1.0, 0.5, 0.0}
   },
   {
      temp = 2000,
      gamma = {1.0, 0.5, 0.2}
   },
   {
      temp = 2500,
      gamma = {1.0, 0.6, 0.4}
   },
   {
     temp= 3500,
     gamma = {1.0, 0.7, 0.5}
   },
   {
     temp = 4000,
     gamma = {1.0, 0.8, 0.6}
   },
   {
     temp = 5000,
     gamma = {1.0, 0.8, 0.8}
   },
   {
     temp = 6000,
     gamma = {1.0, 1.0, 0.9}
   },
   {
     temp = 6500,
     gamma = {1.0, 1.0, 1.0}
   },
}

light.max_temp = light.presets[#light.presets]["temp"]
light.min_temp = light.presets[1]["temp"]

-- assume initial values are full brightness, gamma, etc
light.display = "HDMI-0"
light.gamma = {1.0, 1.0, 1.0}
light.brightness = 1.0
light.temperature = 6500
light.redshift_on = false

light.is_redshift_on = function()
  awful.spawn.easy_async_with_shell(
     "ps aux | grep redshift | grep -v grep",
      function(stdout)
         if stdout:gsub("%s+", "") ~= "" then
            light.redshift_on = true
          else
            light.redshift_on = false
          end
     end
  )
end

local function parse_xrandr_gamma(gammas)
  local inverted_gammas = {}
  for _, gamma in ipairs(gammas) do
    if tonumber(gamma) == 0 then
      table.insert(inverted_gammas, 0.0)
    else
      table.insert(inverted_gammas, helpers.round( 1 / tonumber(gamma), 1))
    end
  end
  return inverted_gammas
end

light.get_current_gamma = function()
   awful.spawn.easy_async_with_shell(
      "xrandr --verbose | " ..
      "grep -w " .. light.display .. " -A8 | " ..
      "grep Gamma | cut -f2- -d: | tr -d ' '",
      function(stdout)
         local gamma = stdout:gsub("%s+", "")
         if gamma ~= "" then
            local xrandr_gammas = helpers.split(gamma, ":")
            light.gamma = parse_xrandr_gamma(xrandr_gammas)
         else
            naughty.notify({title = "Error", text = "Gamma not found"})
         end
      end
   )
end


light.get_initial_display_state = function()
   awful.spawn.easy_async_with_shell(
      "xrandr | grep -w connected | cut -f1 -d ' '",
      function(stdout)
         light.display = stdout:gsub("%s+", "")
          light.get_current_gamma()
          light.get_current_brightness()
      end
   )
end

light.get_current_brightness = function()
   awful.spawn.easy_async_with_shell(
      "xrandr --verbose | " ..
      "grep -w " .. light.display .. " -A8 | " ..
      "grep Brightness | " ..
      "cut -f2 -d ' '",
      function(stdout)
         light.brightness = tonumber(stdout)
      end
   )
end

light.get_current_temp = function()
   for i, preset in ipairs(light.presets) do
      if tablex.compare(preset["gamma"], light.gamma, function(a, b) return a == b end) then
        return preset["temp"]
      end
   end
end

-- operation should be one of "+" or "-"
light.change_brightness = function(operation)
   -- we have to disable redshift to make manual temperature changes
   if light.redshift_on then
      awful.spawn.with_shell("rshift")
      light.redshift_on = false
   end

   local new = 1.0
   if operation == "+" then
      if light.brightness + 0.1 > 1.0 then
         new = 1.0
      else
         new = helpers.round(light.brightness + 0.1, 1)
      end
   elseif operation == "-" then
      if light.brightness - 0.1 < 0.0 then
         new = 0.0
      else
         new = helpers.round(light.brightness - 0.1, 1)
      end
   end
   local cmd = "redshift -P -O " .. light.get_current_temp() .. " -b " .. new .. ":" .. new .. " 2> /dev/null"
   awful.spawn.with_shell(cmd)
   light.brightness = new
   backlight.flash_brightness(math.floor(new * 100))
end

-- operation should be one of "+" or "-"
light.change_temperature = function(operation)
   if light.redshift_on then
      awful.spawn.with_shell("rshift")
      light.redshift_on = false
   end

   local new_temp = 6500
   for i, preset in ipairs(light.presets) do
      if tablex.compare(preset["gamma"], light.gamma, function(a, b) return a == b end) then

            -- We are already at the max or min temperature, don't call xrandr
         if operation == "+" and i + 1 >= #light.presets then
            redshift.flash_temperature(light.max_temp)
            return
         elseif operation == "-" and i - 1 <= 1 then
            redshift.flash_temperature(light.min_temp)
            return
         end

         if operation == "+" then
            new_temp = light.presets[i + 1]["temp"]
         elseif operation == "-" then
            new_temp = light.presets[i - 1]["temp"]
         else
            naughty.notify({title = "Error", text = "Current gamma did not match any presets..."})
            return
         end

      end
   end
   local cmd = "redshift -P -O " .. new_temp .. " -b " .. light.brightness .. ":" .. light.brightness
   awful.spawn.with_shell(cmd)
   light.get_current_gamma()
   redshift.flash_temperature(new_temp)
end

light.toggle_redshift = function()
   awful.spawn.easy_async_with_shell("rshift",
       function(stdout)
         if stdout:gsub("%s+", "") == "off" then
           light.redshift_on = false
           redshift.flash_status("off")
          else
           light.redshift_on = true
           redshift.flash_status("on")
          end
        end)
end

light.get_initial_display_state()

return light
