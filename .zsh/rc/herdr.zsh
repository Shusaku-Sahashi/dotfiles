alias hss=_herdr-session

# セッション一覧を fzf で選択し、name 列を返す
function _herdr-session--pick() {
  herdr session list | fzf --reverse --header-lines=1 --preview-window=up:wrap --prompt "$1:" | awk '{print $1}'
}

# y/N の確認を取る。同意されなければ非0を返す
function _herdr-session--confirm() {
  echo -n "$1 [y/N] "
  read -q
  local ret=$?
  echo
  return $ret
}

function _herdr-session() {
  local selected
  case "$1" in
  -a|--attach)
      local output ret
      local -a lines

      # --print-query: 1 行目に入力したクエリ、2 行目に選択された行が出力される
      output=$(herdr session list | fzf --nth=1 --reverse --header-lines=1 --print-query --preview-window=up:wrap --prompt "attach:")
      ret=$?

      # 0: 選択あり / 1: マッチなし / それ以外 (2, 130) は中断・エラー
      (( ret >= 2 )) && return 0

      lines=("${(@f)output}")

      if (( ret == 0 )); then
        # 既存セッションを選択したので name 列を取り出す
        selected=${${(z)lines[2]}[1]}
      else
        # マッチしなかったので入力した文字列を新規セッション名として使う
        selected=$lines[1]
        [[ -z "$selected" ]] && return 0

        _herdr-session--confirm "Create '${selected}'." || return 0
      fi

      # 未登録の名前を渡すとそのままセッションが新規作成される
      herdr session attach "$selected"
     ;;
  -r|--remove)
      selected=$(_herdr-session--pick remove)
      [[ -z "$selected" ]] && return 0

      _herdr-session--confirm "remove '${selected}'?" || return 0

      herdr session stop "$selected"
      herdr session delete "$selected"
    ;;
  -h|*)
      echo "hss <options>"
      echo "-a, --attach ... attach or create session"
      echo "-r, --remove ... remove hss session"
    ;;
  esac
}

# zsh completion
source <(herdr completion zsh)
