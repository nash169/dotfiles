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

# Create symbolic link for packages list
ln -s rsc/packages.csv ~/.packages