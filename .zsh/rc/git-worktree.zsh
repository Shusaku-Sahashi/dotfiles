alias gwt=_git_worktree

_git_worktree() {
  local output ret
  output=$("$HOME/dotfiles/config/git/change-worktree.sh" "$@")
  ret=$?
  if [[ $ret -ne 0 ]]; then
    print -r -- "$output"
    return $ret
  fi
  if [[ -d "$output" ]]; then
    cd -- "$output"
  else
    print -r -- "$output"
  fi
}

