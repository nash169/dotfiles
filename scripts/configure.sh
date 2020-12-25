#!/bin/bash

# read -p "Do you want to install laptop module?[y/n] " name
# if [ "$name" == "y" ]; then
#     sh .modules/laptop.sh
# fi

source utils.sh

add_package

# command for linking dotfiles
stow folder_name -t ~/

# Set SSH
read -p "Insert your email: " mail

ssh-keygen -t ed25519 -C $mail

# Install ranger icons
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

# Vim command
nvim -c ':checkhealth'