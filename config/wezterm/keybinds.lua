local wezterm = require('wezterm')
local nvsplit = require('nvim-split')
local act = wezterm.action

return {
  keys = {
    { key = 'Enter', mods = 'CTRL|SHIFT', action = act.ToggleFullScreen },

    -- split screen
    { key = '-', mods = 'LEADER', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
    { key = '\\', mods = 'LEADER', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },

    -- zoom in/out and reset
    { key = '|', mods = 'SHIFT|CTRL', action = act.ResetFontSize },
    { key = '+', mods = 'SHIFT|CTRL', action = act.IncreaseFontSize },
    { key = '-', mods = 'SHIFT|CTRL', action = act.DecreaseFontSize },

    -- tab
    { key = 'T', mods = 'SHIFT|CTRL', action = act.SpawnTab 'CurrentPaneDomain' },

    -- tab move
    { key = '}', mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(1) },
    { key = '{', mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(-1) },
    { key = '@', mods = 'CTRL', action = act.ActivateTab(1) },
    { key = '@', mods = 'SHIFT|CTRL', action = act.ActivateTab(1) },
    { key = '#', mods = 'CTRL', action = act.ActivateTab(2) },
    { key = '#', mods = 'SHIFT|CTRL', action = act.ActivateTab(2) },
    { key = '$', mods = 'CTRL', action = act.ActivateTab(3) },
    { key = '$', mods = 'SHIFT|CTRL', action = act.ActivateTab(3) },
    { key = '%', mods = 'CTRL', action = act.ActivateTab(4) },
    { key = '%', mods = 'SHIFT|CTRL', action = act.ActivateTab(4) },
    { key = '^', mods = 'CTRL', action = act.ActivateTab(5) },
    { key = '^', mods = 'SHIFT|CTRL', action = act.ActivateTab(5) },
    { key = '&', mods = 'CTRL', action = act.ActivateTab(6) },
    { key = '&', mods = 'SHIFT|CTRL', action = act.ActivateTab(6) },
    { key = '*', mods = 'CTRL', action = act.ActivateTab(7) },
    { key = '*', mods = 'SHIFT|CTRL', action = act.ActivateTab(7) },
    { key = '(', mods = 'CTRL', action = act.ActivateTab(-1) },
    { key = '(', mods = 'SHIFT|CTRL', action = act.ActivateTab(-1) },

	-- workspace 
	-- see: https://zenn.dev/sankantsu/articles/e713d52825dbbb
	{ mods = 'LEADER', key = 's',     action = wezterm.action_callback (function (win, pane)
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
        action = wezterm.action_callback(function (_, _, id, label)
          if not id and not label then
            wezterm.log_info "Workspace selection canceled"  -- 入力が空ならキャンセル
          else
            win:perform_action(act.SwitchToWorkspace { name = id }, pane)  -- workspace を移動
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

    { key = 'C', mods = 'CTRL', action = act.CopyTo 'Clipboard' },
    { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
    { key = 'F', mods = 'CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },
    { key = 'F', mods = 'SHIFT|CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },
    { key = 'H', mods = 'CTRL', action = act.HideApplication },
    { key = 'H', mods = 'SHIFT|CTRL', action = act.HideApplication },
    { key = 'K', mods = 'CTRL', action = act.ClearScrollback 'ScrollbackOnly' },
    { key = 'K', mods = 'SHIFT|CTRL', action = act.ClearScrollback 'ScrollbackOnly' },
    { key = 'L', mods = 'CTRL', action = act.ShowDebugOverlay },
    { key = 'L', mods = 'SHIFT|CTRL', action = act.ShowDebugOverlay },
    { key = 'M', mods = 'CTRL', action = act.Hide },
    { key = 'M', mods = 'SHIFT|CTRL', action = act.Hide },
    { key = 'N', mods = 'CTRL', action = act.SpawnWindow },
    { key = 'N', mods = 'SHIFT|CTRL', action = act.SpawnWindow },
    { key = 'P', mods = 'CTRL', action = act.ActivateCommandPalette },
    { key = 'P', mods = 'SHIFT|CTRL', action = act.ActivateCommandPalette },
    { key = 'Q', mods = 'CTRL', action = act.QuitApplication },
    { key = 'Q', mods = 'SHIFT|CTRL', action = act.QuitApplication },
    { key = 'R', mods = 'CTRL', action = act.ReloadConfiguration },
    { key = 'R', mods = 'SHIFT|CTRL', action = act.ReloadConfiguration },
    { key = 'U', mods = 'CTRL', action = act.CharSelect{ copy_on_select = true, copy_to =  'ClipboardAndPrimarySelection' } },
    { key = 'U', mods = 'SHIFT|CTRL', action = act.CharSelect{ copy_on_select = true, copy_to =  'ClipboardAndPrimarySelection' } },
    { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
    { key = 'V', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
    { key = 'w', mods = 'LEADER', action = act.CloseCurrentTab{ confirm = true } },
    { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
    { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
    { key = '[', mods = 'SHIFT|SUPER', action = act.ActivateTabRelative(-1) },
    { key = ']', mods = 'SHIFT|SUPER', action = act.ActivateTabRelative(1) },
    { key = '_', mods = 'CTRL', action = act.DecreaseFontSize },
    { key = '_', mods = 'SHIFT|CTRL', action = act.DecreaseFontSize },
    { key = 'f', mods = 'SHIFT|CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },
    { key = 'f', mods = 'SUPER', action = act.Search 'CurrentSelectionOrEmptyString' },
    { key = 'h', mods = 'SHIFT|CTRL', action = act.HideApplication },
    { key = 'h', mods = 'SUPER', action = act.HideApplication },
    { key = 'k', mods = 'SHIFT|CTRL', action = act.ClearScrollback 'ScrollbackOnly' },
    { key = 'k', mods = 'SUPER', action = act.ClearScrollback 'ScrollbackOnly' },
    { key = 'l', mods = 'SHIFT|CTRL', action = act.ShowDebugOverlay },
    { key = 'm', mods = 'SHIFT|CTRL', action = act.Hide },
    { key = 'm', mods = 'SUPER', action = act.Hide },
    { key = 'n', mods = 'SHIFT|CTRL', action = act.SpawnWindow },
    { key = 'n', mods = 'SUPER', action = act.SpawnWindow },
    { key = 'p', mods = 'SHIFT|CTRL', action = act.ActivateCommandPalette },
    { key = 'q', mods = 'SHIFT|CTRL', action = act.QuitApplication },
    { key = 'q', mods = 'SUPER', action = act.QuitApplication },
    { key = 'r', mods = 'SHIFT|CTRL', action = act.ReloadConfiguration },
    { key = 'r', mods = 'SUPER', action = act.ReloadConfiguration },
    { key = 't', mods = 'SHIFT|CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 't', mods = 'SUPER', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'u', mods = 'SHIFT|CTRL', action = act.CharSelect{ copy_on_select = true, copy_to =  'ClipboardAndPrimarySelection' } },
    { key = 'v', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
    { key = 'v', mods = 'SUPER', action = act.PasteFrom 'Clipboard' },
    { key = 'z', mods = 'SHIFT|CTRL', action = act.TogglePaneZoomState },
    { key = '{', mods = 'SUPER', action = act.ActivateTabRelative(-1) },
    { key = '{', mods = 'SHIFT|SUPER', action = act.ActivateTabRelative(-1) },
    { key = '}', mods = 'SUPER', action = act.ActivateTabRelative(1) },
    { key = '}', mods = 'SHIFT|SUPER', action = act.ActivateTabRelative(1) },
    { key = 'phys:Space', mods = 'SHIFT|CTRL', action = act.QuickSelect },
    { key = 'PageUp', mods = 'SHIFT', action = act.ScrollByPage(-1) },
    { key = 'PageUp', mods = 'CTRL', action = act.ActivateTabRelative(-1) },
    { key = 'PageUp', mods = 'SHIFT|CTRL', action = act.MoveTabRelative(-1) },
    { key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(1) },
    { key = 'PageDown', mods = 'CTRL', action = act.ActivateTabRelative(1) },
    { key = 'PageDown', mods = 'SHIFT|CTRL', action = act.MoveTabRelative(1) },
    { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
    { key = 'LeftArrow', mods = 'SHIFT|CTRL', action = act.AdjustPaneSize{ 'Left', 1 } },
    { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
    { key = 'RightArrow', mods = 'SHIFT|CTRL', action = act.AdjustPaneSize{ 'Right', 1 } },
    { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
    { key = 'UpArrow', mods = 'SHIFT|CTRL', action = act.AdjustPaneSize{ 'Up', 1 } },
    { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
    { key = 'DownArrow', mods = 'SHIFT|CTRL', action = act.AdjustPaneSize{ 'Down', 1 } },
    { key = 'Copy', mods = 'NONE', action = act.CopyTo 'Clipboard' },
    { key = 'Paste', mods = 'NONE', action = act.PasteFrom 'Clipboard' },

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
      { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
      { key = 'Tab', mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'Enter', mods = 'NONE', action = act.CopyMode 'MoveToStartOfNextLine' },
      { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 'Space', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
      { key = '$', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = '$', mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
      { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
      { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
      { key = 'F', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
      { key = 'F', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
      { key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
      { key = 'G', mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom' },
      { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
      { key = 'H', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },
      { key = 'L', mods = 'NONE', action = act.CopyMode 'MoveToViewportBottom' },
      { key = 'L', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },
      { key = 'M', mods = 'NONE', action = act.CopyMode 'MoveToViewportMiddle' },
      { key = 'M', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle' },
      { key = 'O', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
      { key = 'O', mods = 'SHIFT', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
      { key = 'T', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
      { key = 'T', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
      { key = 'V', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Line' } },
      { key = 'V', mods = 'SHIFT', action = act.CopyMode{ SetSelectionMode =  'Line' } },
      { key = '^', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = '^', mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
      { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },
      { key = 'd', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (0.5) } },
      { key = 'e', mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd' },
      { key = 'f', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = false } } },
      { key = 'f', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
      { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
      { key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
      { key = 'g', mods = 'CTRL', action = act.CopyMode 'Close' },
      { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
      { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
      { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
      { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
      { key = 'm', mods = 'ALT', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd' },
      { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 't', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = true } } },
      { key = 'u', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (-0.5) } },
      { key = 'v', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
      { key = 'v', mods = 'CTRL', action = act.CopyMode{ SetSelectionMode =  'Block' } },
      { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
      { key = 'y', mods = 'NONE', action = act.Multiple{ { CopyTo =  'ClipboardAndPrimarySelection' }, { CopyMode =  'Close' } } },
      { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
      { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
      { key = 'End', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = 'Home', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
      { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
      { key = 'LeftArrow', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'RightArrow', mods = 'NONE', action = act.CopyMode 'MoveRight' },
      { key = 'RightArrow', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
      { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
      { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
    },

    search_mode = {
      { key = 'Enter', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
      { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 'n', mods = 'CTRL', action = act.CopyMode 'NextMatch' },
      { key = 'p', mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
      { key = 'r', mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
      { key = 'u', mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
      { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PriorMatchPage' },
      { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'NextMatchPage' },
      { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
      { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
    },
  }
}
