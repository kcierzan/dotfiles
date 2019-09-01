local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")

local wibar_text_font = "sans bold 12"
-- user icon
local user = wibox.widget.textbox()
user.valign = "center"
user.forced_width = dpi(15)
user.font = "icomoon 14"
user.markup = helpers.colorize_text("", beautiful.xcolor4)

-- username
local whoami = wibox.widget.textbox()

awful.spawn.easy_async_with_shell(
   "whoami",
   function(stdout)
      output = stdout:gsub("%s+", "")
      padded = helpers.pad_text_end(output, 1)
      whoami.markup = helpers.colorize_text(padded, beautiful.xcolor4)
end)
whoami.font = wibar_text_font


-- Create clocks
local clock = wibox.widget.textclock(helpers.colorize_text("%H:%M %P", beautiful.xcolor3))
local calendar = wibox.widget.textclock(helpers.colorize_text("%A, %B %e %Y", beautiful.xcolor5))
clock.font = wibar_text_font
calendar.font = wibar_text_font

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
      s.layoutbox = awful.widget.layoutbox(s)

      -- Create the wibar
      -- TODO: Move the display values to the theme
      s.mybar = awful.wibar({
            screen = s,
            position = "top",
            opacity = 0.8,
            height = dpi(25),
            bg = beautiful.bg_normal,
            -- remove the compositor shadow
            type = "desktop",
      })

      s.mybar:setup {
         {
            user,
            whoami,
            layout = wibox.layout.fixed.horizontal,
         },
         nil,
         {
            calendar,
            helpers.pad(1),
            clock,
            helpers.pad(1),
            s.layoutbox,
            layout = wibox.layout.fixed.horizontal,
         },
         expand = "none",
         layout = wibox.layout.align.horizontal,
      }
end)
