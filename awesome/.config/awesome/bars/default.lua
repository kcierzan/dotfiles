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


helpers.pad_text_end = function(txt, padding)
   spaces = ""
   for i = 1, padding do
      spaces = spaces .. " "
   end
   return txt:gsub("%s+", "") .. spaces
end

-- user icon
local user = wibox.widget.textbox()
user.valign = "center"
user.font = "icomoon 14"
user.markup = helpers.colorize_text("", "#51afef")
user.forced_height = 50
user.forced_width = dpi(15)

-- username
local whoami = wibox.widget.textbox()
whoami.valign = "center"
whoami.font = "SF Mono 10"
whoami.forced_height = 50
whoami.forced_width = 100

awful.spawn.easy_async_with_shell(
   "whoami",
   function(stdout)
      local padded = helpers.pad_text_end(stdout, 1)
      local colored = helpers.colorize_text(padded, "#51afef")
      whoami.markup = colored
   end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
      s.layoutbox = awful.widget.layoutbox(s)

      s.mybar = awful.wibar({
            screen = s,
            position = "top",
            opacity = 0.8,
            height = dpi(25),
            bg = "#282C34",
      })

      s.mybar:setup {
         {
            user,
            nil,
            whoami,
            layout = wibox.layout.align.horizontal,
         },
         nil,
         {
            s.layoutbox,
            layout = wibox.layout.align.horizontal,
            expand = "none"
         },
         layout = wibox.layout.align.horizontal
      }
end)
