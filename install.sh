#!/bin/bash
source scripts/modules.sh $1

# Basic package installation
installbasics || "Error!"

# Create user
username=$( createuser ) || "Error!"

# Allow sudo without pass
sed -i '/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers

# Aur helper (only for Arch)
aurhelperinstall $username || "Error: could not install aur helper."

# Create basic setup
sudo -u $username mkdir  /home/$username/documents  /home/$username/developments  /home/$username/repositories  /home/$username/workspaces
sudo -u $username mkdir -p /home/$username/developments/linux-config
sudo -u $username git clone https://github.com/nash169/linux-config.git /home/$username/developments/linux-config

# Install & configure zsh
configureshell $username || "Error!"

# Configure ssh & git
configuressh $username || "Error!"

# DESkTOP
configuredesktop $username || "Error!"

# TERMINAL
configureterminal $username || "Error!"

# # EDITOR
# source /root/linux-config/scripts/modules/editor.sh $1 $username

# # DEVELOP
# source /root/linux-config/scripts/modules/develop.sh $1 $username

# # EXPLORER
# source /root/linux-config/scripts/modules/explorer.sh $1 $username

# # BROWSER
# source /root/linux-config/scripts/modules/browser.sh $1 $username

# # MULTIMEDIA
# source /root/linux-config/scripts/modules/media.sh $1 $username

# # READER
# source /root/linux-config/scripts/modules/reader.sh $1 $username

# # EMAIL
# source /root/linux-config/scripts/modules/email.sh $1 $username

# # SOUND
# source /root/linux-config/scripts/modules/sound.sh $1 $username

# # BLUETOOTH
# source /root/linux-config/scripts/modules/bluetooth.sh $1 $username

# # DOWNLOAD
# source /root/linux-config/scripts/modules/download.sh $1 $username

#
sed -i '/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/s/^/#/g' /etc/sudoers

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
