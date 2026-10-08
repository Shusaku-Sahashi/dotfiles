local wezterm = require('wezterm')
local nvsplit = require('nvim-split')
local herdr = require('herdr')
local act = wezterm.action

-- 全workspaceのherdrタブを集める
-- 表示名はタブバーと同じ優先順位: タブ名 > herdr の session 名 > ペインタイトル
local function collect_herdr_tabs()
  local result = {}
  for _, mux_win in ipairs(wezterm.mux.all_windows()) do
    local ws = mux_win:get_workspace()
    for _, info in ipairs(mux_win:tabs_with_info()) do
      for _, p in ipairs(info.tab:panes()) do
        local session = herdr.session_name(p)
        if session then
          local title = info.tab:get_title()
          if title == '' then
            title = session
          end
          table.insert(result, {
            tab = info.tab,
            workspace = ws,
            index = info.index,
            title = title,
            session = session,
          })
          break
        end
      end
    end
  end
  return result
end

return {
  keys = {
    -- split screen
    { key = '-',  mods = 'LEADER',     action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = '\\', mods = 'LEADER',     action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },

    -- zoom in/out and reset
    { key = '|',  mods = 'SHIFT|CTRL', action = act.ResetFontSize },
    { key = '+',  mods = 'SHIFT|CTRL', action = act.IncreaseFontSize },
    { key = '-',  mods = 'SHIFT|CTRL', action = act.DecreaseFontSize },

    -- tab
    { key = 'T',  mods = 'SHIFT|CTRL', action = act.SpawnTab 'CurrentPaneDomain' },

    -- tab move
    { key = '}',  mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(1) },
    { key = '{',  mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(-1) },
    { key = '!',  mods = 'CTRL',       action = act.ActivateTab(0) },
    { key = '@',  mods = 'CTRL',       action = act.ActivateTab(1) },
    { key = '#',  mods = 'CTRL',       action = act.ActivateTab(2) },
    { key = '$',  mods = 'CTRL',       action = act.ActivateTab(3) },
    { key = '%',  mods = 'CTRL',       action = act.ActivateTab(4) },
    { key = '^',  mods = 'CTRL',       action = act.ActivateTab(5) },
    { key = '&',  mods = 'CTRL',       action = act.ActivateTab(6) },
    { key = '*',  mods = 'CTRL',       action = act.ActivateTab(7) },
    { key = '(',  mods = 'CTRL',       action = act.ActivateTab(-1) },

    -- workspace
    -- see: https://zenn.dev/sankantsu/articles/e713d52825dbbb
    {
      mods = 'LEADER',
      key = 's',
      action = wezterm.action_callback(function(win, pane)
        -- workspace のリストを作成
        local workspaces = {}
        for i, name in ipairs(wezterm.mux.get_workspace_names()) do
          table.insert(workspaces, {
            id = name,
            label = string.format("%d. %s", i, name),
          })
        end
        local current = wezterm.mux.get_active_workspace()
        -- 選択メニューを起動
        win:perform_action(act.InputSelector {
          action = wezterm.action_callback(function(_, _, id, label)
            if not id and not label then
              wezterm.log_info "Workspace selection canceled"               -- 入力が空ならキャンセル
            else
              win:perform_action(act.SwitchToWorkspace { name = id }, pane) -- workspace を移動
            end
          end),
          title = "Select workspace",
          choices = workspaces,
          fuzzy = true,
          -- fuzzy_description = string.format("Select workspace: %s -> ", current), -- requires nightly build
        }, pane)
      end),
    },
    {
      -- Create new workspace
      mods = 'LEADER',
      key = 'c',
      action = act.PromptInputLine {
        description = "(wezterm) Create new workspace:",
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:perform_action(
              act.SwitchToWorkspace {
                name = line,
              },
              pane
            )
          end
        end),
      },
    },
    {
      -- Rename current tab
      mods = 'LEADER',
      key = ',',
      action = act.PromptInputLine {
        description = "(wezterm) Rename tab:",
        action = wezterm.action_callback(function(window, pane, line)
          -- Esc の場合は nil、空文字の場合はタイトルをリセット
          if line then
            window:active_tab():set_title(line)
          end
        end),
      },
    },
    {
      -- herdr を起動しているタブの一覧(workspace 横断)
      mods = 'LEADER',
      key = 'h',
      action = wezterm.action_callback(function(win, pane)
        local choices = {}
        for _, item in ipairs(collect_herdr_tabs()) do
          -- タブ名が session 名と異なる場合は session 名も併記する
          local label = string.format('[%s] %d: %s', item.workspace, item.index + 1, item.title)
          if item.title ~= item.session then
            label = label .. string.format(' (session: %s)', item.session)
          end
          table.insert(choices, {
            id = tostring(item.tab:tab_id()),
            label = label,
          })
        end

        if #choices == 0 then
          win:toast_notification('WezTerm', 'herdr を起動しているタブはありません', nil, 3000)
          return
        end

        win:perform_action(act.InputSelector {
          title = 'Select herdr tab',
          choices = choices,
          fuzzy = true,
          action = wezterm.action_callback(function(_, _, id, label)
            if not id and not label then
              wezterm.log_info 'herdr selection canceled'
              return
            end
            local tab = wezterm.mux.get_tab(tonumber(id))
            if not tab then return end

            local ws = tab:window():get_workspace()
            tab:activate()                                                -- 先にタブを選択
            win:perform_action(act.SwitchToWorkspace { name = ws }, pane) -- workspace を移動
          end),
        }, pane)
      end),
    },

    -- { key = 'L',          mods = 'CTRL',       action = act.ShowDebugOverlay }, -> CTRL + P >> ShowDebugOverlay

    -- copy and past
    { key = 'C',          mods = 'CTRL',       action = act.CopyTo 'Clipboard' },
    { key = 'V',          mods = 'CTRL',       action = act.PasteFrom 'Clipboard' },
    { key = 'F',          mods = 'CTRL',       action = act.Search 'CurrentSelectionOrEmptyString' },

    -- operate application
    { key = 'H',          mods = 'CTRL',       action = act.HideApplication },
    { key = 'M',          mods = 'CTRL',       action = act.Hide },
    { key = 'Q',          mods = 'CTRL',       action = act.QuitApplication },

    { key = 'K',          mods = 'CTRL',       action = act.ClearScrollback 'ScrollbackOnly' },
    { key = 'N',          mods = 'CTRL',       action = act.SpawnWindow },
    { key = 'P',          mods = 'CTRL',       action = act.ActivateCommandPalette },

    { key = 'U',          mods = 'CTRL',       action = act.CharSelect { copy_on_select = true, copy_to = 'ClipboardAndPrimarySelection' } },
    { key = 'r',          mods = 'LEADER',     action = act.ReloadConfiguration },
    { key = 'w',          mods = 'LEADER',     action = act.CloseCurrentTab { confirm = true } },
    { key = '[',          mods = 'LEADER',     action = act.ActivateCopyMode },
    { key = 'z',          mods = 'LEADER',     action = act.TogglePaneZoomState },

    { key = 'phys:Space', mods = 'SHIFT|CTRL', action = act.QuickSelect },
    { key = 'PageUp',     mods = 'SHIFT',      action = act.ScrollByPage(-1) },
    { key = 'PageUp',     mods = 'CTRL',       action = act.ActivateTabRelative(-1) },
    { key = 'PageUp',     mods = 'SHIFT|CTRL', action = act.MoveTabRelative(-1) },
    { key = 'PageDown',   mods = 'SHIFT',      action = act.ScrollByPage(1) },
    { key = 'PageDown',   mods = 'CTRL',       action = act.ActivateTabRelative(1) },
    { key = 'PageDown',   mods = 'SHIFT|CTRL', action = act.MoveTabRelative(1) },
    { key = 'Copy',       mods = 'NONE',       action = act.CopyTo 'Clipboard' },
    { key = 'Paste',      mods = 'NONE',       action = act.PasteFrom 'Clipboard' },

    -- Claude Code Sending Key
    { key = "Enter",      mods = "SHIFT",      action = wezterm.action { SendString = "\x1b\r" } },

    -- refresh the viewpoint (https://github.com/wezterm/wezterm/discussions/4446)
    {
      key = "l",
      mods = "CTRL",
      action = wezterm.action_callback(function(window, pane)
        -- avoid running in tui programs like nvim that don't have scrollback
        if pane:is_alt_screen_active() then
          pane:send_text('\x0c')
          return
        end

        -- scroll to bottom in case you aren't already
        window:perform_action(wezterm.action.ScrollToBottom, pane)

        -- get the current height of the viewport
        local height = pane:get_dimensions().viewport_rows

        -- build a string of new lines equal to the viewport height
        local blank_viewport = string.rep("\r\n", height)

        -- inject those new lines to push the viewport contents into the scrollback
        pane:inject_output(blank_viewport)

        -- send an escape sequence to clear the viewport (CTRL-L)
        pane:send_text('\x0c')
      end)
    },

    -- move between split panes
    nvsplit.split_nav('move', 'h'),
    nvsplit.split_nav('move', 'j'),
    nvsplit.split_nav('move', 'k'),
    nvsplit.split_nav('move', 'l'),

    -- resize panes
    nvsplit.split_nav('resize', 'h'),
    nvsplit.split_nav('resize', 'j'),
    nvsplit.split_nav('resize', 'k'),
    nvsplit.split_nav('resize', 'l'),
  },

  key_tables = {
    copy_mode = {
      { key = 'Tab',        mods = 'NONE',  action = act.CopyMode 'MoveForwardWord' },
      { key = 'Tab',        mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'Enter',      mods = 'NONE',  action = act.CopyMode 'MoveToStartOfNextLine' },
      { key = 'Escape',     mods = 'NONE',  action = act.CopyMode 'Close' },
      { key = 'Space',      mods = 'NONE',  action = act.CopyMode { SetSelectionMode = 'Cell' } },
      { key = '$',          mods = 'NONE',  action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = '$',          mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = ',',          mods = 'NONE',  action = act.CopyMode 'JumpReverse' },
      { key = '0',          mods = 'NONE',  action = act.CopyMode 'MoveToStartOfLine' },
      { key = ';',          mods = 'NONE',  action = act.CopyMode 'JumpAgain' },
      { key = 'F',          mods = 'NONE',  action = act.CopyMode { JumpBackward = { prev_char = false } } },
      { key = 'F',          mods = 'SHIFT', action = act.CopyMode { JumpBackward = { prev_char = false } } },
      { key = 'G',          mods = 'NONE',  action = act.CopyMode 'MoveToScrollbackBottom' },
      { key = 'G',          mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom' },
      { key = 'H',          mods = 'NONE',  action = act.CopyMode 'MoveToViewportTop' },
      { key = 'H',          mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },
      { key = 'L',          mods = 'NONE',  action = act.CopyMode 'MoveToViewportBottom' },
      { key = 'L',          mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },
      { key = 'M',          mods = 'NONE',  action = act.CopyMode 'MoveToViewportMiddle' },
      { key = 'M',          mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle' },
      { key = 'O',          mods = 'NONE',  action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
      { key = 'O',          mods = 'SHIFT', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
      { key = 'T',          mods = 'NONE',  action = act.CopyMode { JumpBackward = { prev_char = true } } },
      { key = 'T',          mods = 'SHIFT', action = act.CopyMode { JumpBackward = { prev_char = true } } },
      { key = 'V',          mods = 'NONE',  action = act.CopyMode { SetSelectionMode = 'Line' } },
      { key = 'V',          mods = 'SHIFT', action = act.CopyMode { SetSelectionMode = 'Line' } },
      { key = '^',          mods = 'NONE',  action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = '^',          mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = 'b',          mods = 'NONE',  action = act.CopyMode 'MoveBackwardWord' },
      { key = 'b',          mods = 'ALT',   action = act.CopyMode 'MoveBackwardWord' },
      { key = 'b',          mods = 'CTRL',  action = act.CopyMode 'PageUp' },
      { key = 'c',          mods = 'CTRL',  action = act.CopyMode 'Close' },
      { key = 'd',          mods = 'CTRL',  action = act.CopyMode { MoveByPage = (0.5) } },
      { key = 'e',          mods = 'NONE',  action = act.CopyMode 'MoveForwardWordEnd' },
      { key = 'f',          mods = 'NONE',  action = act.CopyMode { JumpForward = { prev_char = false } } },
      { key = 'f',          mods = 'ALT',   action = act.CopyMode 'MoveForwardWord' },
      { key = 'f',          mods = 'CTRL',  action = act.CopyMode 'PageDown' },
      { key = 'g',          mods = 'NONE',  action = act.CopyMode 'MoveToScrollbackTop' },
      { key = 'g',          mods = 'CTRL',  action = act.CopyMode 'Close' },
      { key = 'h',          mods = 'NONE',  action = act.CopyMode 'MoveLeft' },
      { key = 'j',          mods = 'NONE',  action = act.CopyMode 'MoveDown' },
      { key = 'k',          mods = 'NONE',  action = act.CopyMode 'MoveUp' },
      { key = 'l',          mods = 'NONE',  action = act.CopyMode 'MoveRight' },
      { key = 'm',          mods = 'ALT',   action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = 'o',          mods = 'NONE',  action = act.CopyMode 'MoveToSelectionOtherEnd' },
      { key = 'q',          mods = 'NONE',  action = act.CopyMode 'Close' },
      { key = 't',          mods = 'NONE',  action = act.CopyMode { JumpForward = { prev_char = true } } },
      { key = 'u',          mods = 'CTRL',  action = act.CopyMode { MoveByPage = (-0.5) } },
      { key = 'v',          mods = 'NONE',  action = act.CopyMode { SetSelectionMode = 'Cell' } },
      { key = 'v',          mods = 'CTRL',  action = act.CopyMode { SetSelectionMode = 'Block' } },
      { key = 'w',          mods = 'NONE',  action = act.CopyMode 'MoveForwardWord' },
      { key = 'y',          mods = 'NONE',  action = act.Multiple { { CopyTo = 'ClipboardAndPrimarySelection' }, { CopyMode = 'Close' } } },
      { key = 'PageUp',     mods = 'NONE',  action = act.CopyMode 'PageUp' },
      { key = 'PageDown',   mods = 'NONE',  action = act.CopyMode 'PageDown' },
      { key = 'End',        mods = 'NONE',  action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = 'Home',       mods = 'NONE',  action = act.CopyMode 'MoveToStartOfLine' },
      { key = 'LeftArrow',  mods = 'NONE',  action = act.CopyMode 'MoveLeft' },
      { key = 'LeftArrow',  mods = 'ALT',   action = act.CopyMode 'MoveBackwardWord' },
      { key = 'RightArrow', mods = 'NONE',  action = act.CopyMode 'MoveRight' },
      { key = 'RightArrow', mods = 'ALT',   action = act.CopyMode 'MoveForwardWord' },
      { key = 'UpArrow',    mods = 'NONE',  action = act.CopyMode 'MoveUp' },
      { key = 'DownArrow',  mods = 'NONE',  action = act.CopyMode 'MoveDown' },
    },

    search_mode = {
      { key = 'Enter',     mods = 'NONE', action = act.CopyMode 'PriorMatch' },
      { key = 'Escape',    mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 'n',         mods = 'CTRL', action = act.CopyMode 'NextMatch' },
      { key = 'p',         mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
      { key = 'r',         mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
      { key = 'u',         mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
      { key = 'PageUp',    mods = 'NONE', action = act.CopyMode 'PriorMatchPage' },
      { key = 'PageDown',  mods = 'NONE', action = act.CopyMode 'NextMatchPage' },
      { key = 'UpArrow',   mods = 'NONE', action = act.CopyMode 'PriorMatch' },
      { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
    },
  }
}
