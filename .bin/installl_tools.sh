#!/bin/bash

# install brew packages
APP_LISTS=( git tmux exa asdf fuwari kindle iterm2 obsidian 1password arc clibor alt-tab raycast jetbrains-toolbox karabiner-elements)
for app in ${APP_LISTS[@]}
do
    if [ ! -x "$(command -v $app)" ]; then
        brew install $app
    fi
done

# install font
brew tap homebrew/cask-fonts
brew install --cask font-hackgen
brew install --cask font-hackgen-nerd
