#!/bin/bash
source scripts/utils.sh
source scripts/$1.sh

# Basic package installation
sh scripts/modules/init.sh $1

# Create user
username=$( scripts/modules/user.sh )

# Allow sudo without pass
sed -i '/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers

# Aur helper (inly for Arch)
aurhelperinstall $username || "Error: could not install aur helper."

# Create basic setup
sudo -u $username mkdir  /home/$username/documents  /home/$username/developments  /home/$username/repositories  /home/$username/workspaces
sudo -u $username mkdir -p /home/$username/developments/linux-config
sudo -u $username git clone https://github.com/nash169/linux-config.git /home/$username/developments/linux-config

# Install & configure zsh
sh scripts/modules/zsh.sh $1 $username

# # Configure ssh & git
# sh scripts/modules/git.sh $1 $username

# # DESkTOP
# sh scripts/modules/desktop.sh $1 $username

# TERMINAL
# sh scripts/modules/terminal.sh $1 $username

# # EDITOR
# sh scripts/modules/editor.sh $1 $username

# # DEVELOP
# sh scripts/modules/develop.sh $1 $username

# # EXPLORER
# sh scripts/modules/explorer.sh $1 $username

# # BROWSER
# sh scripts/modules/browser.sh $1 $username

# # MULTIMEDIA
# sh scripts/modules/media.sh $1 $username

# # READER
# sh scripts/modules/reader.sh $1 $username

# # EMAIL
# sh scripts/modules/email.sh $1 $username

# # SOUND
# sh scripts/modules/sound.sh $1 $username

# # BLUETOOTH
# sh scripts/modules/bluetooth.sh $1 $username

# # DOWNLOAD
# sh scripts/modules/download.sh $1 $username

# #
# sed -i '/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/s/^/#/g' /etc/sudoers

# #  Node support
# pkginstall nodejs npm
# sudo npm install -g neovim

# # Python support
# pkginstall python-pip
# pip install pynvim --user

# # Package manager
# git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# pkginstall ripgrep fzf ranger

# # Allow to draw image in terminal
# pkginstall python-ueberzug-git

# # Don't know yet
# pkginstall neovim-remote
# npm install -g tree-sitter-cli

# nvim -u $HOME/.config/nvim/init.lua +PackerInstall
