local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")

local ram_bar = helpers.widget.progress()

local ram_percentage = wibox.widget {
  forced_width = dpi(100),
  widget = wibox.widget.textbox
}

local ram = wibox.widget {
  ram_bar,
  ram_percentage,
  layout = wibox.layout.fixed.horizontal
}

awesome.connect_signal(
  "signals::ram",
  function(usage)
    if tonumber(usage) ~= nil then
      ram_bar.bar.value = helpers.round(usage, 2)
      ram_percentage.markup = "RAM: " .. tostring(helpers.round(usage, 2)) .. "%"
      if tonumber(usage) > 80 then
        ram_bar.bar.color = beautiful.xcolor1
      elseif tonumber(usage) > 50 then
        ram_bar.bar.color = beautiful.xcolor3
      else
        ram_bar.bar.color = beautiful.xcolor5
      end
    end
  end
  )

return ram
