if [[ ${OSTYPE}="darwin*" ]]; then
  alias op-hosts='vim /private/etc/hosts'

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
fi

