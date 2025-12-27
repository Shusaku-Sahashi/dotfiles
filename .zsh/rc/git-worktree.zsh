gwt() {
  local args="$@"
  cd $(sh -lc "~/dotfiles/config/git/change-worktree.sh \"$args\"")
}

