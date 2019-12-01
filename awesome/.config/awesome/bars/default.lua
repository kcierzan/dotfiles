local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")

-- Add widgets
local weather = require("bars.widgets.weather")
local time = require("bars.widgets.time")
local date = require("bars.widgets.date")
local wifi = require("bars.widgets.wifi")
local system = require("bars.widgets.system")
local cpu = require("bars.widgets.cpu")
local ram = require("bars.widgets.ram")
local hdd = require("bars.widgets.hdd")

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

local create_taglist = function(s)
  local naughty = require("naughty")
  -- naughty.notify({title = s})
  return awful.widget.taglist {
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
end

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
      -- Create taglist
      s.mytaglist = create_taglist(s)

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
            system,
            {
              cpu,
              ram,
              layout = wibox.layout.fixed.vertical
            },
            hdd,
            spacing = beautiful.wibar_widget_spacing,
            layout = wibox.layout.fixed.horizontal,
         },
         s.mytaglist,
         {
            weather,
            time,
            date,
            wifi,
            s.layoutbox,
            spacing = beautiful.wibar_widget_spacing,
            layout = wibox.layout.fixed.horizontal,
            expand = "none"
         },
         expand = "none",
         layout = wibox.layout.align.horizontal,
      }
end)
