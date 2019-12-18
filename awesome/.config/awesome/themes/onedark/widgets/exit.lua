local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")
local wibox = require("wibox")

local icon_font = "icomoon 45"
local button_size = dpi(120)
local button_bg = beautiful.bg_lighter

local exit_button = {}

exit_button.create_button = function(symbol, hover_color, text, command)
   local icon = wibox.widget {
      forced_height = button_size,
      forced_width = button_size,
      align = "center",
      valign = "center",
      font = icon_font,
      text = symbol,
      widget = wibox.widget.textbox()
   }

   local button_text = wibox.widget {
      font = "sans bold 18",
      text = text,
      visible = false,
      forced_height = dpi(80),
      align = "center",
      widget = wibox.widget.textbox()
   }

   local button = wibox.widget {
      {
         nil,
         icon,
         expand = "none",
         layout = wibox.layout.align.horizontal
      },
      forced_height = button_size,
      forced_width = button_size,
      border_width = dpi(8),
      border_color = button,
      border_color = button_bg,
      shape = helpers.rrect(dpi(20)),
      bg = button_bg,
      widget = wibox.container.background
   }

   local wrapper = wibox.widget {
      {
         nil,
         button,
         button_text,
         expand = "none",
         layout = wibox.layout.align.vertical
      },
      widget = wibox.container.background
   }

   -- left click executes the command
   wrapper:buttons(gears.table.join(
         awful.button({  }, 1, function()
            command()
         end)
      ))

   wrapper:connect_signal("mouse::enter", function()
                            icon.markup = helpers.colorize_text(icon.text, hover_color)
                            button_text.markup = helpers.colorize_text(button_text.text, hover_color)
                            button_text.visible = true
                            button.border_color = hover_color
   end)
   wrapper:connect_signal("mouse::leave", function()
                            icon.markup = helpers.colorize_text(icon.text, beautiful.xforeground)
                            button_text.visible = false
                            button.border_color = button_bg
   end)

   -- Change the cursor on hover
   helpers.add_hover_cursor(button, "hand1")

   return wrapper
end

return exit_button
