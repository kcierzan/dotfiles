local xresources = require("beautiful.xresources")
dpi = xresources.apply_dpi
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = {}

helpers.rrect = function(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

helpers.colorize_text = function(txt, fg)
    return "<span foreground='" .. fg .."'>" .. txt .. "</span>"
end

local whoami = wibox.widget.textbox()

-- whoami.forced_height = dpi(30)
whoami.valign = "center"
whoami.font = "SF Mono 18"

awful.spawn.easy_async_with_shell("whoami", function(stdout)
   whoami.markup = helpers.colorize_text(stdout, "#51afef")
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
   s.layoutbox = awful.widget.layoutbox(s)

   s.mybar = awful.wibar({
         screen = s,
         position = "top",
         opacity = 0.8,
         height = dpi(30),
         bg = "#282C34",
      })

   s.mybar:setup {
      whoami,
      nil,
      s.layoutbox,
      layout = wibox.layout.align.horizontal
   }
end)
