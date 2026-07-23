alias hss=_herdr-session

function _herdr-session() {
  local selected
  selected=$(herdr session list | fzf --reverse --header-lines=1 --preview-window=up:wrap | awk '{print $1}')
  [[ -z "$selected" ]] && return 0
  herdr session attach "$selected"
}
