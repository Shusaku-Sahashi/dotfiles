#!/bin/bash

set -e

if [ ! -e ./.devcontainer ]; then
  echo "Error: This command should be execute in the '.devcontainer' existing folder"
  exit 1
fi


rebuild_flag=""
case "$1" in
  "-r"|"--rebuild")
    rebuild_flag="--remove-existing-container"
    ;;
  "-h"|"--help")
    echo "-r or --rebuild ... rebuild devcontainer"
    ;;
  *)
    ;;
esac

devcontainer up $rebuild_flag \
    --mount type=bind,source=$(cd ~/.config/nvim/ && pwd -P),target=/nvim-config/nvim/ \
    --additional-features='{ \
        "ghcr.io/duduribeiro/devcontainer-features/neovim:1": { "version": "stable" }, \
        "ghcr.io/jungaretti/features/ripgrep:1": {}, \
    }' \
    --workspace-folder .

clear
devcontainer exec --remote-env XDG_CONFIG_HOME=/nvim-config --workspace-folder . zsh

exit 0
