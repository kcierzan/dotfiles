local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")
local wibox = require("wibox")

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

return popup
