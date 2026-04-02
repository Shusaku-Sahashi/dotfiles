-- Send Ctrl instead of Cmd when Cmd is pressed
-- @see https://github.com/Hammerspoon/hammerspoon/discussions/3246#discussioncomment-3079311
local cmd2ctrl = {}

local logger = hs.logger.new("cmd2ctrl", "info")
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
  -- アプリ確認様に hummer spoon のログでアプリ名を表示する
  windowFilter.default:subscribe(windowFilter.windowFocused, function(window)
    local appName = window:application():name()
    local isTarget = false
    for _, name in ipairs(appNames) do
      if name == appName then
        isTarget = true
        break
      end
    end
    if isTarget then
      logger.i("cmd2ctrl enabled: " .. appName)
    else
      logger.i("focused: " .. appName)
    end
  end)

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
