#!/bin/bash
source scripts/distros/$1.sh

editor=(neovim python-pynvim) # ninja tree-sitter lua luarocks
pkginstall $2 ${editor[@]} || "Error: could not install EDITOR packages."
cd /home/$2/developments/linux-config/configs && sudo -u $2 stow neovim -t /home/$2/