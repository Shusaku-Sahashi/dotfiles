# .bashrc
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

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

################################################################
### pathの設定
##################################################################

# nodebrewのPATH
export PATH=$HOME/.nodebrew/current/bin:$PATH

# FOR ruby
export PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init -)"

# OPAM configuration
# OderQRのmake startコマンドが通らないため、コメントアウト
# . /Users/shusaku/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true


