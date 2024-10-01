local wezterm = require 'wezterm';


local DEFAULT_FG = { Color = '#9a9eab' }
local DEFAULT_BG = { Color = '#333333' }

local SPACE_1 = ' '
local SPACE_3 = '   '
local HEADER_HOST = { Foreground = { Color = '#75b1a9' }, Text = '' }
local HEADER_CWD = { Foreground = { Color = '#92aac7' }, Text = '' }
local HEADER_DATE = { Foreground = { Color = '#ffccac' }, Text = '󱪺' }
local HEADER_TIME = { Foreground = { Color = '#bcbabe' }, Text = '' }

local function AddElement(elems, header, str)
  table.insert(elems, { Foreground = header.Foreground })
  table.insert(elems, { Background = DEFAULT_BG })
  table.insert(elems, { Text = header.Text .. SPACE_1 })

  table.insert(elems, { Foreground = DEFAULT_FG })
  table.insert(elems, { Background = DEFAULT_BG })
  table.insert(elems, { Text = str .. SPACE_3 })
end

local function GetDate(elems)
  AddElement(elems, HEADER_DATE, wezterm.strftime '%a %b %-d')
end

local function GetTime(elems)
  AddElement(elems, HEADER_TIME, wezterm.strftime '%H:%M')
end

local function RightUpdate(window, pane)
  local elems = {}

  GetDate(elems)
  GetTime(elems)

  window:set_right_status(wezterm.format(elems))
end

wezterm.on('update-status', function(window, pane)
  RightUpdate(window, pane)
end)
