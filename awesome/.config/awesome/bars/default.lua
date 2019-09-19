local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")

-- Add widgets
local weather = require("bars.widgets.weather")
local time = require("bars.widgets.time")
local user = require("bars.widgets.user")
local taglist = require("bars.widgets.taglist-dots")

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
      -- Create taglist
      s.mytaglist = taglist.create_taglist(s)

      -- TODO Make these icons cooler
      s.layoutbox = awful.widget.layoutbox(s)

      -- Create the wibar
      s.mybar = awful.wibar({
            screen = s,
            position = beautiful.wibar_position,
            ontop = beautiful.wibar_ontop,
            opacity = beautiful.wibar_opacity,
            height = beautiful.wibar_height,
            bg = beautiful.bg_normal,
            -- remove the compositor shadow
            type = "desktop",
      })

      s.mybar:setup {
         {
            user,
            layout = wibox.layout.fixed.horizontal,
         },
         s.mytaglist,
         {
            weather,
            time,
            s.layoutbox,
            spacing = dpi(10),
            layout = wibox.layout.fixed.horizontal,
         },
         expand = "none",
         layout = wibox.layout.align.horizontal,
      }
end)
