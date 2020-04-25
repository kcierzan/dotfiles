local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")

local devices = wibox.widget.textbox()
local popup_width = dpi(180)
local popup_height = dpi(115)

awesome.connect("signals::bluetooth_devices", function(devices)
   devices.text = devices
end)

local icon = wibox.widget {
   valign = "center",
   font = beautiful.wibar_icomoon_font,
   markup = helpers.colorize_text("", beautiful.xcolor4),
   widget = wibox.widget.textbox
}

icon:connect_signal("mouse::enter", function()
   bluetooth_menu.visible = true
end)


local bluetooth_menu = wibox {
   visible = false,
   ontop = true,
   opacity = beautiful.wibar_opacity,
   width = popup_width,
   height = popup_height,
   x = dpi(2110),
   y = beautiful.wibar_popup.y_pos,
   bg = beautiful.bg_normal,
   shape = function(cr, width, height)
      gears.shape.infobubble(
         cr,
         popup_width,
         popup_height,
         beautiful.wibar_popup.radius,
         beautiful.wibar_popup.arrow_size,
         dpi(130))
   end
}

bluetooth_menu:setup {
   {
      devices,
      layout = wibox.layout.fixed.vertical,
   expand = "none"
   },
   widget = wibox.container.margin,
   margins = beautiful.wibar_popup.margins
}

return icon
