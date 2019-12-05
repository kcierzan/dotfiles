local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")

-- Network traffic widget
local down = wibox.widget.textbox()
local up = wibox.widget.textbox()

awesome.connect_signal("signals::traffic", function(download, upload)
  down.text = "Down: " .. download
  up.text = "Up: " .. upload
end)

-- Wibar wifi icon
local icon = wibox.widget {
  valign = "center",
  font = beautiful.wibar_icomoon_font,
  markup = helpers.colorize_text("", beautiful.xcolor2),
  widget = wibox.widget.textbox
}

-- Current wifi network name
local network_name = wibox.widget {
  font = beautiful.wibar_font,
  widget = wibox.widget.textbox
}

-- Current wifi signal strength
local strength_bar = wibox.widget {
  max_value     = 100,
  value         = 50,
  forced_height = 5,
  shape         = helpers.rrect(4),
  bar_shape     = helpers.rrect(4),
  color         = beautiful.xcolor2,
  background_color = beautiful.bg_lighter,
  border_width  = 0,
  border_color  = beautiful.xcolor3,
  widget        = wibox.widget.progressbar,
}

awesome.connect_signal(
  "signals::wifi",
  function(name, strength)
    if tonumber(strength) ~= nil then
      strength_bar.value = tonumber(strength)
    else
      strength_bar.value = 0
    end

    network_name.markup = helpers.colorize_text(name, beautiful.xcolor2)
  end)

-- Click the wifi icon in the wibar to toggle extended wifi info
icon:connect_signal("mouse::enter", function()
  wifi_menu.visible = true
end)

icon:connect_signal("mouse::leave", function()
  wifi_menu.visible = false
end)

local popup_width = dpi(180)
local popup_height = dpi(115)
-- Create the wrapper infobubble widget
wifi_menu = wibox {
  visible = false,
  ontop = true,
  opacity = beautiful.wibar_opacity,
  width = popup_width,
  height = popup_height,
  x = dpi(2110),
  y = beautiful.wibar_popup.y_pos,
  bg = beautiful.bg_normal,
  shape = function(cr, width, height)
    -- width, height, radius, arrow size, arrow position
    gears.shape.infobubble(
      cr,
      popup_width,
      popup_height,
      beautiful.wibar_popup.radius,
      beautiful.wibar_popup.arrow_size,
      dpi(130))
  end
}

-- Build the infobubble wibox
wifi_menu:setup {
  {
    network_name,
    strength_bar,
    {
      up,
      down,
      layout = wibox.layout.align.vertical,
    },
    spacing = beautiful.wibar_popup.spacing,
    layout = wibox.layout.fixed.vertical,
    expand = "none"
  },
  widget = wibox.container.margin,
  margins = beautiful.wibar_popup.margins
}

-- Expose the icon for the wibar
return icon
