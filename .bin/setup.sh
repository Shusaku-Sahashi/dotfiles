#!/bin/bash

set -e
set -x

# set up homobrew
if [ ! -x "$(command -v brew)" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# set up nix (CLI tools are managed declaratively via flake.nix + home-manager)
if [ ! -x "$(command -v nix)" ]; then
  curl -fsSL https://install.determinate.systems/nix | sh -s -- install --no-confirm
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# create symbolic link
DOT_FILES=(.gitconfig .vimrc .tmux.conf .global_gitignore .ideavimrc)
for file in "${DOT_FILES[@]}"; do
  ln -s "$HOME/dotfiles/$file" "$HOME/$file 2>/dev/null" || echo "Pass creating link of $file. It already exists"
done

## zshのセットアップを記述する。
## https://dev.classmethod.jp/articles/zsh-prezto/
if [ ! -d "$HOME/.zprezto" ]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi

DOT_FILES=(zlogin zlogout zpreztorc zprofile zshenv zshrc)
if [ ! -d "$HOME/zsh_bk" ]; then
  mkdir -p "$HOME/zsh_bk"
  for file in "${DOT_FILES[@]}"; do
    mv "$HOME/.$file" "$HOME/.zsh_bk/$file 2>/dev/null" || echo "Pass back-up $file, It doesn't exist."
  done
fi

for file in "${DOT_FILES[@]}"; do
  ln -s "$HOME/dotfiles/macOS/zsh/$file" "$HOME/.$file"
done

## install tools
##  https://github.com/Homebrew/homebrew-bundle
brew bundle --file "$(git rev-parse --show-toplevel)/Brewfile"

## install CLI tools declared in flake.nix via home-manager
nix run home-manager/master -- switch --flake "$(git rev-parse --show-toplevel)#mac" --impure

if [ ! -d "$HOME/.config" ]; then
  mkdir "$HOME/.config"
fi

for dir in $(basename "$(find ~/dotfiles/config -type d -name '.*')" | sed 's/\.//'); do
  ln -s "$HOME/dotfiles/config/$dir" "$HOME/.config/.$dir" 2>/dev/null || echo "Pass creating link of $dir. It already exists"
done

# other dotfles
ln -s ~/dotfiles/config/hammerspoon ~/.config/hammerspoon
ln -s ~/dotfiles/config/claude/settings.json ~/.claude/settings.json

## key repeating setting
## https://apple.stackexchange.com/questions/10467/how-to-increase-keyboard-key-repeat-rate-on-os-x
defaults write -g InitialKeyRepeat -int 12             # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1                     # normal minimum is 2 (30 ms)
defaults write -g ApplePressAndHoldEnabled -bool false # enalbe keyrepeating
