#!/bin/bash
source scripts/distros/$1.sh
source scripts/utils.sh

gitmakeinstall $2 https://github.com/nash169/st.git || "Error: could not install TERMINAL packages."
terminal=(tmux exa nerd-fonts-hack-complete-git)
pkginstall $2 ${terminal[@]} || "Error: could not install TERMINAL packages."