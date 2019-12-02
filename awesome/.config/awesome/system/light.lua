local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

local light = {}

local height = dpi(100)
local width = dpi(600)

local popup = wibox {
   visible = false,
   ontop = true,
   width = width,
   height = height,
   y = dpi(1100),
   shape = helpers.rrect(dpi(8)),
   opacity = beautiful.wibar_opacity
}

local bulb = wibox.widget {
   valign = "centered",
   font = "icomoon 48",
   markup = helpers.colorize_text("", beautiful.xcolor3),
   widget = wibox.widget.textbox
}

local meter = wibox.widget {
   max_value = 100,
   border_width = 0,
   shape = helpers.rrect(dpi(8)),
   background_color = beautiful.bg_lighter,
   color = beautiful.xcolor3,
   widget = wibox.widget.progressbar
}

local percentage = wibox.widget {
   widget = wibox.widget.textbox,
   font = "mono bold 32",
   valign = "center"
}

local bar = wibox.widget {
   {
      meter,
      percentage,
      layout = wibox.layout.stack,
      horizontal_offset = dpi(10)
   },
   widget = wibox.container.margin,
   margins = dpi(10)

}

popup:setup {
   {
      bulb,
      bar,
      spacing = dpi(4),
      layout = wibox.layout.fixed.horizontal
   },
   widget = wibox.container.margin,
   margins = dpi(8)
}

awful.placement.center_horizontal(popup)

function pop_bar(bar_value)
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
