################################################################
###共通設定
##################################################################

# スクリプト読み込み
source /usr/local/etc/bash_completion.d/git-prompt.sh
source /usr/local/etc/bash_completion.d/git-completion.bash

# プロンプトに各種情報を表示
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_SHOWUNTRACKEDFILES=
GIT_PS1_SHOWSTASHSTATE=1

############### ターミナルのコマンド受付状態の表示変更
# \u ユーザ名
# \h ホスト名
# \W カレントディレクトリ
# \w カレントディレクトリのパス
# \n 改行
# \d 日付
# \[ 表示させない文字列の開始
# \] 表示させない文字列の終了
# \$ $
export PS1='\[\033[1;32m\]\u\[\033[00m\]:\[\033[1;34m\]\w\[\033[1;31m\]$(__git_ps1)\[\033[00m\] \$ '
##############

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

alias ls='ls -FG'

alias start-psql='pg_ctl -l /usr/local/var/postgres11/server.log start'
alias stop-psql='pg_ctl -m smart stop'
export HOMEBREW_GITHUB_API_TOKEN=74ff0baf985f6d47622e0108ed2653ed689046b4

######
# AWS CIL
######
export PATH=~/.local/bin:$PATH

# https://blog.y-ohgi.com/entry/2018/06/26/013128
# 現在開いているFinderのパスへ移動する。
cdf() {
  target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
  if [ "$target" != "" ]; then
    builtin cd "$target"; pwd
  else
    echo 'No Finder window found' >&2
  fi
}
alias cdf='cdf'

## csharp-scriptのsandbox用のショートカット
alias open-cs-sbox='code ~/Programing/Tutorials/015_C\#/csharp-script-sandbox'

## pbcopyのalias
alias C="pbcopy "
