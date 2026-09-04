alias hss=_herdr-session

function _herdr-session() {
  local selected
  case "$1" in
  -a|--attach)
      selected=$(herdr session list | fzf --reverse --header-lines=1 --preview-window=up:wrap --prompt "attach:" | awk '{print $1}')
      [[ -z "$selected" ]] && return 0
      herdr session attach "$selected"
     ;;
  -r|-remove) 
      selected=$(herdr session list | fzf --reverse --header-lines=1 --preview-window=up:wrap --prompt "remove:" | awk '{print $1}')
      [[ -z "${selected}" ]] && return 0
      echo "${selected} を削除します。"
      echo "press any key"
      read

      herdr session stop "$selected"
      herdr session delete "$selected"
    ;;
  -h|*) 
      echo "hss <options>"
      echo "-a, --attach ... attach ssession"
      echo "-r, --remove ... remove hss session"
    ;;
  esac
}
