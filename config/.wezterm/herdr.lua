local wezterm = require('wezterm')

local M = {}

local function basename(path)
  return (path or ''):match('([^/\\]+)$') or ''
end

-- herdr のクライアントなら argv から session 名を取り出す
--   herdr session attach <name> / herdr --session <name>
-- herdr ではない場合は nil
function M.session_name(pane)
  if not pane then return nil end
  local info = pane:get_foreground_process_info()
  if not info or basename(info.executable) ~= 'herdr' then return nil end
  local argv = info.argv or {}
  for i = 2, #argv do
    if argv[i] == '--session' or (argv[i] == 'attach' and argv[i - 1] == 'session') then
      return argv[i + 1]
    end
  end
  return 'default'
end

return M
