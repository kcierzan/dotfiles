local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")

local cpu_bar = helpers.widget.progress()

local cpu_percentage = wibox.widget {
  forced_width = dpi(100),
  widget = wibox.widget.textbox
}

local cpu = wibox.widget {
  cpu_bar,
  cpu_percentage,
  layout = wibox.layout.fixed.horizontal
}

awesome.connect_signal(
  "signals::cpu",
  function(usage)
    if tonumber(usage) ~= nil then
      cpu_bar.bar.value = helpers.round(usage, 2)
      cpu_percentage.markup = "CPU: " .. tostring(helpers.round(usage, 2)) .. "%"
      if tonumber(usage) > 80 then
        cpu_bar.bar.color = beautiful.xcolor1
      elseif tonumber(usage) > 50 then
        cpu_bar.bar.color = beautiful.xcolor3
      else
        cpu_bar.bar.color = beautiful.xcolor2
      end
    end
  end
  )

return cpu
