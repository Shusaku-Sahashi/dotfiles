-- Send Ctrl instead of Cmd when Cmd is pressed
-- @see https://github.com/Hammerspoon/hammerspoon/discussions/3246#discussioncomment-3079311
local cmd2ctrl = {}

local eventtap = hs.eventtap
local eventTypes = eventtap.event.types
local keycodes = hs.keycodes.map
local windowFilter = hs.window.filter


local function cmd2CtrlEventHandler(event)
  local flags = event:getFlags()
  local keycode = event:getKeyCode()

  if flags.cmd then
    flags.cmd = false
    flags.ctrl = true
  end

  if keycode == keycodes.cmd then
    keycode = keycodes.ctrl
  elseif keycode == keycodes.rightcmd then
    keycode = keycodes.rightctrl
  end

  event:setKeyCode(keycode)
  event:setFlags(flags)

  return false
end

local cmd2CtrlEventTapObj = eventtap.new({
  eventTypes.flagsChanged,
  eventTypes.keyDown,
  eventTypes.keyUp
}, cmd2CtrlEventHandler)

cmd2ctrl.new = function(appNames)
    for _, value in ipairs(appNames) do
        TerminalFocusFilter = windowFilter.new(value):subscribe({
          [windowFilter.windowFocused] = function() cmd2CtrlEventTapObj:start() end,
          [windowFilter.windowVisible] = function() cmd2CtrlEventTapObj:start() end,
          [windowFilter.windowUnhidden] = function() cmd2CtrlEventTapObj:start() end,
          [windowFilter.windowInCurrentSpace] = function() cmd2CtrlEventTapObj:start() end,
          [windowFilter.windowHidden] = function() cmd2CtrlEventTapObj:stop() end,
          [windowFilter.windowUnfocused] = function() cmd2CtrlEventTapObj:stop() end
        })
    end
end

return cmd2ctrl
