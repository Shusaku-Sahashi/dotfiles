#!/bin/bash

# set up homobrew
if [ ! -x "$(command -v brew)" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

## install tools
./install_tools.sh

# create symbolic link
DOT_FILES=( .gitconfig .vimrc .tmux.conf .global_gitignore .ideavimrc )

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/dotfiles/$file $HOME/$file
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
        mv $HOME/.$file $HOME/.zsh_bk/$file
    done
fi

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/dotfiles/macOS/zsh/$file $HOME/.$file
done

## key repeating setting
## https://apple.stackexchange.com/questions/10467/how-to-increase-keyboard-key-repeat-rate-on-os-x
defaults write -g InitialKeyRepeat -int 12 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)