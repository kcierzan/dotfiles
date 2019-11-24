local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")

local down = wibox.widget {
  widget = wibox.widget.textbox
}

local up = wibox.widget {
  widget = wibox.widget.textbox
}

awesome.connect_signal("signals::traffic", function(download, upload)
  down.text = "Down: " .. download
  up.text = "Up: " .. upload
end)

local icon = wibox.widget {
  valign = "center",
  font = beautiful.wibar_icomoon_font,
  markup = helpers.colorize_text("", beautiful.xcolor2),
  widget = wibox.widget.textbox
}

local network_name = wibox.widget {
  font = beautiful.wibar_font,
  widget = wibox.widget.textbox
}

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

local wifi_button = wibox.widget {
  {
    icon,
    layout = wibox.layout.align.horizontal
  },
  widget = wibox.container.background
}

wifi_button:buttons(gears.table.join(
    awful.button({}, 1, function()
      wifi_menu.visible = not wifi_menu.visible
    end)
  ))

-- TODO: extract this to a generic popup wibox
local wifi_menu = wibox {
  visible = false,
  ontop = true,
  opacity = beautiful.wibar_opacity,
  height = dpi(75),
  width = dpi(175),
  x = 18,
  y = 45,
  bg = beautiful.bg_normal,
  shape = function(cr, width, height)
    gears.shape.infobubble(cr, dpi(175), dpi(75))
  end
}

-- Build the popup wibox
wifi_menu:setup {
  {
    {
      network_name,
      strength_bar,
      {
        up,
        down,
        spacing = dpi(10),
        layout = wibox.layout.fixed.horizontal
      },
      spacing = dpi(10),
      layout = wibox.layout.align.vertical,
      expand = "none"
    },
    widget = wibox.container.margin,
    margins = 20
  },
  layout = wibox.layout.fixed.horizontal
}


awesome.connect_signal(
  "signals::wifi",
  function(name, strength)
    if tonumber(strength) ~= nil then
      strength_bar.value = tonumber(strength)
    else
      strength_bar.value = 0
    end

    network_name.text = name
  end)

-- Expose the icon for the wibar
return wifi_button
