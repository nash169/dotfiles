#!/bin/bash
source ../distros/$1.sh
source ../utils.sh

gitmakeinstall $2 https://github.com/nash169/st.git || "Error: could not install TERMINAL packages."
terminal=(tmux exa nerd-fonts-hack)
pkginstall $2 ${terminal[@]} || "Error: could not install TERMINAL packages."