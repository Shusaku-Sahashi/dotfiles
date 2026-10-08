-- https://coralpink.github.io/commentary/wezterm/window-title.html
local wezterm = require 'wezterm'

local function BaseName(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

wezterm.on('format-window-title', function(tab)
  return BaseName(tab.active_pane.foreground_process_name)
end)

-- https://coralpink.github.io/commentary/wezterm/tab.html
local HEADER = '' -- 文字化けしちゃってるかもしれませんが、アイコンフォント入ってます。

local SYMBOL_COLOR = { '#ffb2cc', '#a4a4a4' }
local FONT_COLOR = { '#dddddd', '#888888' }
local BACK_COLOR = '#2d2d2d'
local HOVER_COLOR = '#434343'

local herdr = require('herdr')

local function herdr_session_name(pane_id)
  return herdr.session_name(wezterm.mux.get_pane(pane_id))
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local index = tab.is_active and 1 or 2

  local bg = hover and HOVER_COLOR or BACK_COLOR
  local zoomed = tab.active_pane.is_zoomed and '🔎 ' or ' '
  -- 明示的にリネームされていればそれを優先
  local session = herdr_session_name(tab.active_pane.pane_id)
  local title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title
    or session
    or tab.active_pane.title
  if session then
    title = '🐂 ' .. title
  end

  return {
    { Foreground = { Color = SYMBOL_COLOR[index] } },
    { Background = { Color = bg } },
    { Text = HEADER .. zoomed },

    { Foreground = { Color = FONT_COLOR[index] } },
    { Background = { Color = bg } },
    { Text = title },
  }
end)
