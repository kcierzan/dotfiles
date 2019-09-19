local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local taglist = {}

taglist.update_taglist = function (item, tag, _)
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

taglist.tag_buttons = gears.table.join(
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

  -- A function that returns a taglist given a screen
taglist.create_taglist = function(s)
  local list = awful.widget.taglist {
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
        taglist.update_taglist(self, tag)
      end,
      update_callback = function(self, tag, __, _)
        taglist.update_taglist(self, tag)
      end,
    },
    buttons = taglist.tag_buttons
  }
  return list
end

return taglist
