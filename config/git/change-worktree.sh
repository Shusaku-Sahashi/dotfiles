#!/bin/bash

DIR_PATH="$HOME/.git_worktree"
REPOSITORY_NAME=$(basename "$(git rev-parse --show-toplevel)")

# Exit when .git doesn't exist
git rev-parse || exit

case "$1" in
"-h|--help")
  echo "
  This command is function as simple wrapper for git worktree comands.
  [options]
  command                      ... List up the worktree list and move to the selected directory.
  command -c <new_branch_name> ... Create new worktree with <new_branch_name>
  "
  ;;
"-c")
  BRANCH=$2
  if [[ "$#" != 2 ]]; then
    echo "command -c <new_branch_name>"
  fi
  git worktree add -b "$BRANCH" "${DIR_PATH}/${REPOSITORY_NAME}/${BRANCH}"
  echo pwd
  ;;
"-r")
  git worktree remove "$(git worktree list | fzf --query 'remove>' | awk '{ print "$1"}')"
  echo pwd
  ;;
*)
  git worktree list | fzf --prompt "CD > " --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899' | awk '{print $1}'
  ;;
esac
