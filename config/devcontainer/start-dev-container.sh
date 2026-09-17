#!/bin/bash

set -e

if [ ! -e ./.devcontainer ]; then
  echo "Error: This command should be execute in the '.devcontainer' existing folder"
  exit 1
fi

withUp=false

case "$1" in
"run")
  withUp=true
  ;;
"exec") ;;
"help" | *)
  echo "run: Start dev container"
  echo "exec: Execute command in dev container"
  exit 0
  ;;
esac

if [ "$withUp" = true ]; then
  rebuild_flag=""
  case "$2" in
  "-r" | "--rebuild")
    rebuild_flag="--remove-existing-container"
    ;;
  "-h" | "--help")
    echo "-r|--rebuild: rebuild devcontainer"
    exit 0
    ;;
  *) ;;
  esac

  rebuild_flag="--remove-existing-container"
  devcontainer up $rebuild_flag \
    --mount type=bind,source="$(cd ~/.config/nvim/ && pwd -P)",target=/nvim-config/nvim/ \
    --additional-features='{ \
        "ghcr.io/duduribeiro/devcontainer-features/neovim:1": { "version": "stable" }, \
        "ghcr.io/jungaretti/features/ripgrep:1": {}, \
    }' \
    --workspace-folder .
fi

devcontainer exec --remote-env XDG_CONFIG_HOME=/nvim-config --workspace-folder . zsh

exit 0
