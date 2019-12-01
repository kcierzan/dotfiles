local beautiful = require("beautiful")
local wibox = require("wibox")

local info_font = "mono 8"

local pacman_updates = wibox.widget {
  font = info_font,
  widget = wibox.widget.textbox
}

awesome.connect_signal("signals::number_pacman_updates", function(update_count)
  if tonumber(update_count) == 0 then
    update_count = "no"
  end
  pacman_updates.markup = "There are " .. update_count .. " packages that need updating"
end)

return pacman_updates
