#!/bin/bash

DOT_FILES=( .gitconfig .vimrc )

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/dotfiles/$file $HOME/$file
done 

## zshのセットアップを記述する。
## https://dev.classmethod.jp/articles/zsh-prezto/
# DOT_FILES=( .zlogin .zlogout .zpreztorc .zprofile .zshenv .zshrc )
# 
# for file in ${DOT_FILES[@]}
# do
#     ln -s $HOME/dotfiles/$file $HOME/.zprezto/$file
# done 
