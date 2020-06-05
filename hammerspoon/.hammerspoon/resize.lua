local resize = {}
resize.__index = resize
resize.name = "Resize"

function resize.get_state()
  local current_window = hs.window.focusedWindow()
  local current_frame = current_window:frame()
  return current_window,
         current_frame,
         current_window:screen():frame()
end

function resize.center()
  local window, _, screen = resize.get_state()
  window:centerOnScreen(screen)
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
  local window = resize.get_state()
  window:moveToUnit('[0,0,50,100]')
end

function resize.right_half()
  local window = resize.get_state()
  window:moveToUnit('[50,0,100,100]')
end

function resize.top_half()
  local window = resize.get_state()
  window:moveToUnit('[0,0,100,50]')
end

function resize.bottom_half()
  local window = resize.get_state()
  window:moveToUnit('[0,50,100,100]')
end

function resize.resize_to_preset(window, screen)
  local window, frame, screen = resize.get_state()
  if frame.w <= screen.w * 2/5 or frame.w > screen.w * 4/5 then
    frame.w = screen.w * 4/5
    frame.h = screen.h * 4/5
  elseif frame.w > screen.w * 3/5 then
    frame.w = screen.w * 3/5
    frame.h = screen.h * 3/5
  elseif frame.w > screen.w * 2/5 then
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

function resize.send_to_next_screen()
  local window, frame = resize.get_state()
  local screen = window:screen()
  window:move(frame:toUnitRect(screen:frame()), screen:next(), true, 0)
end

return resize
