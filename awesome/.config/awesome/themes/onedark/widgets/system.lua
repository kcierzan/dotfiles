local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")
local wibox = require("wibox")

local distro = require(widget_dir .. "distro")
local host = require(widget_dir .. "host")
local last_update = require(widget_dir .. "last_update")
local pacman_updates = require(widget_dir .. "pacman_updates")
local user = require(widget_dir .. "user")
local ip = require(widget_dir .. "ip")

local system_icon = ""
local popup_width = dpi(380)
local popup_height = dpi(200)

local system_button = wibox.widget {
  markup = " " .. helpers.colorize_text(system_icon, beautiful.xcolor4),
  font = "mono 16",
  valign = "center",
  widget = wibox.widget.textbox
}

-- TODO: standardize this popup creation somewhere...
system_menu = wibox {
  visible = false,
  ontop = true,
  opacity = beautiful.wibar_opacity,
  height = dpi(200),
  width = dpi(380),
  x = 15,
  y = beautiful.wibar_popup.y_pos,
  bg = beautiful.bg_normal,
  shape = function(cr, width, height)
    -- width, height, radius, arrow size, arrow position
    gears.shape.infobubble(cr,
      popup_width,
      popup_height,
      beautiful.wibar_popup.radius,
      beautiful.wibar_popup.arrow_size,
      dpi(3))
  end
}

  local naughty = require("naughty")

system_button:connect_signal("mouse::enter", function()
  system_menu.visible = true
end)

system_button:connect_signal("mouse::leave", function()
  system_menu.visible = false
end)

system_menu:setup {
  {
    {
      distro,
      user,
      {
        host,
        ip,
        spacing = dpi(10),
        layout = wibox.layout.fixed.horizontal
      },
      spacing = dpi(2),
      expand = "none",
      layout = wibox.layout.align.vertical
    },
    last_update,
    pacman_updates,
    layout = wibox.layout.fixed.vertical,
    spacing = beautiful.wibar_popup.spacing
  },
  widget = wibox.container.margin,
  margins = beautiful.wibar_popup.margins
}

-- Expose the arch logo button
return system_button
