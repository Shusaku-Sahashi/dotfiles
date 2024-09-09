#!/bin/bash

set -e
set -x

# set up homobrew
if [ ! -x "$(command -v brew)" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

## install tools
##  https://github.com/Homebrew/homebrew-bundle
brew bundle --no-lock --file "$(git rev-parse --show-toplevel)/Brewfile"

# create symbolic link
DOT_FILES=( .gitconfig .vimrc .tmux.conf .global_gitignore .ideavimrc )
for file in ${DOT_FILES[@]}
do
    ln -s $HOME/dotfiles/$file $HOME/$file 2>/dev/null || echo "Pass creating link of $file. It already exists"
done

## create config symbolic link
DOT_CONFIG_DIR=( hammerspoon )
for dir in ${DOT_CONFIG_DIR[@]}
do
    ln -s $HOME/dotfiles/config/$dir $HOME/.$dir 2>/dev/null || echo "Pass creating link of $dir. It already exists"
done

## zshのセットアップを記述する。
## https://dev.classmethod.jp/articles/zsh-prezto/
if [ ! -d $HOME/.zprezto ]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi

DOT_FILES=( zlogin zlogout zpreztorc zprofile zshenv zshrc )
if [ ! -d $HOME/zsh_bk ]; then
    mkdir -p $HOME/zsh_bk
    for file in ${DOT_FILES[@]}
    do
        mv $HOME/.$file $HOME/.zsh_bk/$file 2>/dev/null || echo "Pass back-up $file, It doesn't exist."
    done
fi

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/dotfiles/macOS/zsh/$file $HOME/.$file
done

ln -s $HOME/dotfiles/config/wezterm ~/.config/wezterm 

## key repeating setting
## https://apple.stackexchange.com/questions/10467/how-to-increase-keyboard-key-repeat-rate-on-os-x
defaults write -g InitialKeyRepeat -int 12 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
