-- set up 3 finger window focus
local current_id
local threshold = 0.1
Swipe = hs.loadSpoon("Swipe")
Swipe:start(3, function(direction, distance, id)
  if id == current_id then
    if distance > threshold then
      threshold = 0.2 -- need to swipe more to keep swiping after the first focus change

      -- use "natural" scrolling
      if direction == "left" then
        hs.window.focusedWindow():focusWindowEast()
      elseif direction == "right" then
        hs.window.focusedWindow():focusWindowWest()
      elseif direction == "up" then
        hs.window.focusedWindow():focusWindowSouth()
      elseif direction == "down" then
        hs.window.focusedWindow():focusWindowNorth()
      end
    end
  else
    current_id = id
    threshold = 0.1 -- swipe distance 20% of trackpad
  end
end)
