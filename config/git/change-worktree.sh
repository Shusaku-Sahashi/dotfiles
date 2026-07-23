#!/bin/bash

set -e

# Exit when .git doesn't exist
git rev-parse || exit

DIR_PATH="$HOME/.git_worktree"
REPOSITORY_NAME=$(basename "$(git worktree list | awk 'NR==1 { print $1 }')")

case $1 in
"-l" | "--list")
  git worktree list | fzf --prompt "CD: " --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899' | awk '{print $1}'
  ;;
"-c")
  BRANCH=$2
  ORIGIN=$3
  if [[ "$#" -lt 2 || "$#" -gt 3 || -z "$BRANCH" ]]; then
    echo "command -c <new_branch_name> [<origin_branch>]"
    exit 1
  fi
  git worktree add -b "$BRANCH" "${DIR_PATH}/${REPOSITORY_NAME}/${BRANCH}" ${ORIGIN:+"$ORIGIN"} 1>&2
  echo "${DIR_PATH}/${REPOSITORY_NAME}/${BRANCH}"
  ;;
"-r")
  MAIN_ROOT="$(git worktree list | awk 'NR==1 { print $1 }')"
  SELECTED_LINE="$(git worktree list | fzf --prompt "remove: ")"
  SELECTED="$(echo "$SELECTED_LINE" | awk '{ print $1 }')"
  SELECTED_BRANCH="$(echo "$SELECTED_LINE" | awk '{ if ($NF ~ /^\[.*\]$/) { gsub(/[][]/, "", $NF); print $NF } }')"

  # tempolary move to MAIN_ROOT ensurely to remove the branch and workingdir
  cd "$MAIN_ROOT"
  git worktree remove "$SELECTED" 1>&2
  if [[ -n "$SELECTED_BRANCH" ]]; then
    git branch -D "$SELECTED_BRANCH" 1>&2
  fi
  echo "$MAIN_ROOT"
  ;;
*)
  echo "
  This command is a simple wrapper for git worktree commands.
  [options]
  command -l, --list           ... List up the worktree list and move to the selected directory.
  command -c <new_branch_name> [<origin_branch>] ... Create new worktree with <new_branch_name> (branched from <origin_branch> if given).
  command -r                   ... Remove the selected worktree (and force-delete its branch with 'git branch -D').
  "
  exit 1
  ;;
esac
