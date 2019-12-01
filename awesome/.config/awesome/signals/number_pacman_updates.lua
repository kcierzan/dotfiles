local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")

local update_interval = 60
local number_updates = "checkupdates | wc -l"

local success = true

local get_updates = function()
  awful.spawn.easy_async_with_shell(
    "checkupdates | wc -l",
    function(stdout)
      num_updates = stdout:gsub("%s+", "")
      if not num_updates then
        success = false
        naughty.notify({
            title = "checkupdates failed",
            text = "Stopping pacman package updates"
          })
        return
      end
      awesome.emit_signal("signals::number_pacman_updates", num_updates)
    end
    )
  return success
end

gears.timer.start_new(update_interval, get_updates)
