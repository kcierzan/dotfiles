local awful = require("awful")
local helpers = require("helpers")
local inspect = require("inspect")
local naughty = require("naughty")

local update_interval = 30

awful.widget.watch("lastupdate", update_interval, function(widget, stdout)
  awesome.emit_signal("signals::last_pacman_update", stdout:gsub("%s+", ""))
end)

