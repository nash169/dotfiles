#!/bin/bash

# Basic package installation
source scripts/modules/init.sh $1

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
scripts/modules/zsh.sh $1 $username

# # Configure ssh & git
# scripts/modules/git.sh $1 $username

# # DESkTOP
# scripts/modules/desktop.sh $1 $username

# TERMINAL
# scripts/modules/terminal.sh $1 $username

# # EDITOR
# scripts/modules/editor.sh $1 $username

# # DEVELOP
# scripts/modules/develop.sh $1 $username

# # EXPLORER
# scripts/modules/explorer.sh $1 $username

# # BROWSER
# scripts/modules/browser.sh $1 $username

# # MULTIMEDIA
# scripts/modules/media.sh $1 $username

# # READER
# scripts/modules/reader.sh $1 $username

# # EMAIL
# scripts/modules/email.sh $1 $username

# # SOUND
# scripts/modules/sound.sh $1 $username

# # BLUETOOTH
# scripts/modules/bluetooth.sh $1 $username

# # DOWNLOAD
# scripts/modules/download.sh $1 $username

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
