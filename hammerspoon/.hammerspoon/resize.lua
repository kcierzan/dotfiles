local resize = {}
resize.__index = resize
resize.name = "Resize"

function resize.get_state()
  local current_window = hs.window.focusedWindow()
  local current_frame = current_window:frame()
  local current_screen = current_window:screen()
  local screen_frame = current_screen:frame()
  return current_window, current_frame, screen_frame
end

function resize.center()
  local window, frame, screen = resize.get_state()
  frame.x = ((screen.w - frame.w) // 2) + screen.x
  frame.y = ((screen.h - frame.h) // 2) + screen.y
  window:setFrame(frame)
end

function resize.fullscreen()
  local window, frame, screen = resize.get_state()
  frame.x = screen.x
  frame.y = screen.y
  frame.w = screen.w
  frame.h = screen.h
  window:setFrame(frame)
end

function resize.left_half()
  local window, frame, screen = resize.get_state()
  frame.x = screen.x
  frame.y = screen.y
  frame.w = screen.w // 2
  frame.h = screen.h
  window:setFrame(frame)
end

function resize.right_half()
  local window, frame, screen = resize.get_state()
  frame.x = (screen.w // 2) + screen.x
  frame.y = screen.y
  frame.w = screen.w // 2
  frame.h = screen.h
  window:setFrame(frame)
end

function resize.round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function resize.resize_to_preset(window, screen)
  local window, frame, screen = resize.get_state()
  if frame.w <= screen.w * 2/5 or frame.w >= screen.w * 4/5 then
    frame.w = screen.w * 4/5
    frame.h = screen.h * 4/5
  elseif frame.w >= screen.w * 3/5 then
    frame.w = screen.w * 3/5
    frame.h = screen.h * 3/5
  elseif frame.w >= screen.w * 2/5 then
    frame.w = screen.w * 2/5
    frame.h = screen.h * 2/5
  end
  window:setFrame(frame)
end

function resize.nudge_left()
  local window, frame, screen = resize.get_state()
  frame.x = frame.x - screen.w // 32
  window:setFrame(frame)
end

function resize.nudge_right()
  local window, frame, screen = resize.get_state()
  frame.x = frame.x + screen.w // 32
  window:setFrame(frame)
end

function resize.nudge_up()
  local window, frame, screen = resize.get_state()
  frame.y = frame.y - screen.h // 32
  window:setFrame(frame)
end

function resize.nudge_down()
  local window, frame, screen = resize.get_state()
  frame.y = frame.y + screen.h // 32
  window:setFrame(frame)
end

return resize
