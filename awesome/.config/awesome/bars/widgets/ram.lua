local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")

local bar = wibox.widget {
  max_value = 100,
  forced_height = 0.5,
  forced_width = dpi(100),
  border_width = 0,
  shape = helpers.rrect(4),
  bar_shape = helpers.rrect(4),
  background_color = beautiful.bg_lighter,
  widget = wibox.widget.progressbar
}

local ram_percentage = wibox.widget {
  font = "mono 8",
  forced_width = dpi(100),
  widget = wibox.widget.textbox
}

local ram_bar = wibox.widget {
  bar,
  widget = wibox.container.margin,
  margins = dpi(2)
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
      bar.value = helpers.round(usage, 2)
      ram_percentage.markup = "RAM: " .. tostring(helpers.round(usage, 2)) .. "%"
      if tonumber(usage) > 80 then
        bar.color = beautiful.xcolor1
      elseif tonumber(usage) > 50 then
        bar.color = beautiful.xcolor3
      else
        bar.color = beautiful.xcolor5
      end
    end
  end
  )

return ram
