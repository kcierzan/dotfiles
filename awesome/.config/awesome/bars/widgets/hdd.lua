local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")

local root_bar = helpers.widget.progress()
local media_bar = helpers.widget.progress()

local root_percentage = wibox.widget {
  forced_width = dpi(100),
  widget = wibox.widget.textbox

}

local media_percentage = wibox.widget {
  forced_width = dpi(100),
  widget = wibox.widget.textbox
}

local hdd = wibox.widget {
  {
    root_bar,
    root_percentage,
    layout = wibox.layout.fixed.horizontal
  },
  {
    media_bar,
    media_percentage,
    layout = wibox.layout.fixed.horizontal
  },
  layout = wibox.layout.fixed.vertical
}

awesome.connect_signal(
  "signals::hdd",
  function(root, media)
    local r = root:gsub("%%", "")
    local m = media:gsub("%%", "")
    local root_number = tonumber(r)
    local media_number = tonumber(m)
    root_bar.bar.value = root_number
    media_bar.bar.value = media_number
    root_percentage.markup = "/: " .. root
    media_percentage.markup = "/mnt/media: " .. media

    if root_number > 80 then
      root_bar.color = beautiful.xcolor1
    else
      root_bar.bar.color = beautiful.xcolor3
    end

    if media_number > 80 then
      media_bar.bar.color = beautiful.xcolor1
    else
      media_bar.bar.color = beautiful.xcolor3
    end
  end)
return hdd
