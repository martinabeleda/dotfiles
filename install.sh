#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# nvim
ln -s ${BASEDIR}/nvim ~/.config/nvim

# zsh
ln -s ${BASEDIR}/zshrc ~/.zshrc

# git
# ln -s ${BASEDIR}/gitconfig ~/.gitconfig

# starship
ln -s ${BASEDIR}/starship.toml ~/.config/starship.toml

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s ${BASEDIR}/.tmux.conf ~/.tmux.conf
