-- A nice ui to for basic system controls
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local gears = require("gears")

local icon_font = "icomoon 45"
local poweroff_text_icon = ""
local reboot_text_icon = ""
local suspend_text_icon = ""

local poweroff_command = function()
   awful.spawn.with_shell("sudo systemctl poweroff")
end

local reboot_command = function()
   awful.spawn.with_shell("sudo systemctl reboot")
end

local suspend_command = function()
   awful.spawn.with_shell("sudo systemctl suspend")
end

local button_size = dpi(120)
local button_bg = beautiful.bg_lighter

local create_button = function(symbol, hover_color, text, command)
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
      font = "sans 18",
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


   -- Bind left click to run the command
   button:buttons(gears.table.join(
                     awful.button({ }, 1, function()
                           command()
                     end)
   ))

   -- Change color on hover
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

-- Create the buttons
local poweroff = create_button(poweroff_text_icon, beautiful.xcolor1, "Power", poweroff_command)
local reboot = create_button(reboot_text_icon, beautiful.xcolor2, "Reboot", reboot_command)
local suspend = create_button(suspend_text_icon, beautiful.xcolor3, "Suspend", suspend_command)

 -- Create the exit screen wibox
exit_screen = wibox({visible = false, ontop = true, type = "dock"})
awful.placement.maximize(exit_screen)

exit_screen.bg = beautiful.exit_screen_bg or "#111111"
exit_screen.fg = beautiful.exit_screen_fg or "#FEFEFE"

local exit_screen_grabber
function exit_screen_hide()
   awful.keygrabber.stop(exit_screen_grabber)
   exit_screen.visible = false
end

function exit_screen_show()
   exit_screen_grabber = awful.keygrabber.run(function(_, key, event)
         -- Ignore case
         key = key:lower()

         if event == "release" then return end

         if key == "s" then
            suspend_command()
            exit_screen_hide()
         elseif key == "r" then
            reboot_command()
         elseif key == "p" then
            poweroff_command()
         elseif key == "escape" or key == "q" or key == "x" then
            exit_screen_hide()
         end
   end)
   exit_screen.visible = true
end

exit_screen:buttons(gears.table.join(
                       -- left click hides screen
                       awful.button({ }, 1, function()
                             exit_screen_hide()
                       end),
                       -- middle click hides screen
                       awful.button({ }, 2, function()
                             exit_screen_hide()
                       end),
                       -- right click hides screen
                       awful.button({ }, 3, function()
                             exit_screen_hide()
                       end)
))

-- Item placement
exit_screen:setup {
   nil,
   {
      nil,
      {
         poweroff,
         reboot,
         suspend,
         spacing = dpi(50),
         layout = wibox.layout.fixed.horizontal
      },
      expand = "none",
      layout = wibox.layout.align.horizontal
   },
   expand = "none",
   layout = wibox.layout.align.vertical
}
