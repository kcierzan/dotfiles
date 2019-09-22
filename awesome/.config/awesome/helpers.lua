local gears = require("gears")
local wibox = require("wibox")

local helpers = {}

-- Create rounded rectangle shape (in one line)
helpers.rrect = function(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

helpers.colorize_text = function(txt, fg)
   return "<span foreground='" .. fg .."'>" .. txt .. "</span>"
end


helpers.pad_text_end = function(txt, padding)
   spaces = ""
   for i = 1, padding do
      spaces = spaces .. " "
   end
   return txt .. spaces
end

helpers.pad = function(padding)
   spaces = ""
   for i = 1, padding do
      spaces = spaces .. " "
   end
   local pad = wibox.widget.textbox(spaces)
   return pad
end

-- how does a language get by without this?
helpers.round = function(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

  -- split a string by colons
helpers.split = function(input, delimiter)
  local lines = {}
  for line in input:gmatch("[^" .. delimiter .. "]+") do
    table.insert(lines, line)
  end
  return lines
end

-- Add a hover cursor to a widget by changing the cursor on
-- mouse::enter and mouse::leave
-- You can find the names of the available cursors by opening any
-- cursor theme and looking in the "cursors folder"
-- For example: "hand1" is the cursor that appears when hovering over
-- links
function helpers.add_hover_cursor(w, hover_cursor)
    local original_cursor = "left_ptr"

    w:connect_signal("mouse::enter", function ()
        local w = _G.mouse.current_wibox
        if w then
            w.cursor = hover_cursor
        end
    end)

    w:connect_signal("mouse::leave", function ()
        local w = _G.mouse.current_wibox
        if w then
            w.cursor = original_cursor
        end
    end)
end

return helpers
