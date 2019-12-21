-- A nice ui to for basic system controls
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local gears = require("gears")

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

local exit_widget = require_widget("exit")
-- Create the buttons
local poweroff = exit_widget.create_button(poweroff_text_icon, beautiful.xcolor1, "Power", poweroff_command)
local reboot = exit_widget.create_button(reboot_text_icon, beautiful.xcolor2, "Reboot", reboot_command)
local suspend = exit_widget.create_button(suspend_text_icon, beautiful.xcolor3, "Suspend", suspend_command)

 -- Create the exit screen wibox
local exit_screen = wibox({visible = false, ontop = true, type = "dock"})
awful.placement.maximize(exit_screen)

exit_screen.bg = beautiful.exit_screen_bg or "#111111"
exit_screen.fg = beautiful.exit_screen_fg or "#FEFEFE"

local exit_screen_grabber
local exit_screen_hide = function()
   awful.keygrabber.stop(exit_screen_grabber)
   exit_screen.visible = false
end

local exit = {}

exit.exit_screen_show = function()
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
         kxit_screen_hide()
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

return exit
