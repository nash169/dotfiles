#!/bin/bash

# read -p "Do you want to install laptop module?[y/n] " name
# if [ "$name" == "y" ]; then
#     sh .modules/laptop.sh
# fi

source utils.sh

add_package

# command for linking dotfiles
stow folder_name -t ~/




