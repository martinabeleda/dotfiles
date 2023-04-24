#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Base directory: ${BASEDIR}"

# Add an argument for the flag
UNLINK_FLAG=$1

# Function for linking
link_configs() {
    echo "Linking nvim to ~/.config/nvim/"
    ln -s ${BASEDIR}/nvim ~/.config/nvim

    echo "Linking zsh dotfiles to ~/"
    ln -s ${BASEDIR}/zsh/.zshrc ~/.zshrc
    ln -s ${BASEDIR}/zsh/.zprofile ~/.zprofile

    echo "Installing zsh plugins"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    echo "Linking .gitconfig to ~/"
    ln -s ${BASEDIR}/.gitconfig ~/.gitconfig

    echo "Linking starship.toml"
    ln -s ${BASEDIR}/starship.toml ~/.config/starship.toml

    echo "Installing tmux and tmux-plugins"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ln -s ${BASEDIR}/tmux/.tmux.conf ~/.tmux.conf
}

# Function for unlinking
unlink_configs() {
    unlink ~/.config/nvim
    unlink ~/.zshrc
    unlink ~/.zprofile
    unlink ~/.gitconfig
    unlink ~/.config/starship.toml
    rm -rf ~/.tmux/plugins/tpm
    unlink ~/.tmux.conf
    rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

# Check the flag and call the appropriate function
if [ "$UNLINK_FLAG" == "--unlink" ]; then
  echo "Unlinking symlinks..."
  unlink_configs
else
  echo "Creating symlinks..."
  link_configs
fi
