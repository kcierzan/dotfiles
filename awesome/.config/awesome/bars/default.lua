local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")
local weather = require("system.weather")

local wibar_text_font = beautiful.wibar_font

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

-- clocks
local clock = wibox.widget.textclock(helpers.colorize_text("%l:%M %P", beautiful.xcolor3))
local calendar = wibox.widget.textclock(helpers.colorize_text("%A, %B %d %Y", beautiful.xcolor5))
clock.font = wibar_text_font
calendar.font = wibar_text_font

-- weather

-- Helper function that updates a taglist item
local update_taglist = function (item, tag, _)
    if tag.selected then
       item.markup = helpers.colorize_text(
          beautiful.taglist_text_focused,
          beautiful.taglist_text_color_focused)
    elseif tag.urgent then
       item.markup = helpers.colorize_text(
          beautiful.taglist_text_urgent,
          beautiful.taglist_text_color_urgent)
    elseif #tag:clients() > 0 then
       item.markup = helpers.colorize_text(
          beautiful.taglist_text_occupied,
          beautiful.taglist_text_color_occupied)
    else
       item.markup = helpers.colorize_text(
          beautiful.taglist_text_empty,
          beautiful.taglist_text_color_empty)
    end
end

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
      -- Create taglist buttons
      local tag_buttons = gears.table.join(
         awful.button({ }, 1, function(t)
               t:view_only()
         end),
         awful.button({ modkey }, 1, function(t)
               if client.focus then
                  client.focus:move_to_tag(t)
               end
         end),
         awful.button({ }, 3, function(t)
               if client.focus then
                  client.focus:move_to_tag(t)
               end
         end),
         awful.button({ modkey }, 3, function(t)
               if client.focus then
                  client.focus:toggle_tag(t)
               end
         end),
         awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
         awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
      )
      -- Create taglist
      s.mytaglist = awful.widget.taglist {
         screen = s,
         filter = awful.widget.taglist.filter.all,
         layout = wibox.layout.fixed.horizontal,
         widget_template = {
            widget = wibox.widget.textbox,
            create_callback = function(self, tag, __, _)
               self.align = "center"
               self.valign = "center"
               self.forced_width = dpi(25)
               self.font = beautiful.taglist_text_font
               update_taglist(self, tag)
            end,
            update_callback = function(self, tag, __, _)
               update_taglist(self, tag)
            end,
         },
         buttons = tag_buttons
      }

      s.layoutbox = awful.widget.layoutbox(s)

      -- Create the wibar
      -- TODO: Move the display values to the theme
      s.mybar = awful.wibar({
            screen = s,
            position = "top",
            ontop = false,
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
         s.mytaglist,
         {
            weather,
            calendar,
            clock,
            s.layoutbox,
            spacing = dpi(10),
            layout = wibox.layout.fixed.horizontal,
         },
         expand = "none",
         layout = wibox.layout.align.horizontal,
      }

end)
