local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")

local pacman_updates = wibox.widget {
  widget = wibox.widget.textbox
}

awesome.connect_signal("signals::number_pacman_updates", function(update_count)
  if tonumber(update_count) == 0 then
    update_count = "no"
  end
  pacman_updates.markup = "There are " .. helpers.colorize_text(update_count, beautiful.xcolor3) .. " packages that need updating"
end)

return pacman_updates
