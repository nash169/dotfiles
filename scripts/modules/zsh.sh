#!/bin/bash
source scripts/distros/$1.sh

zsh=(zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting)
pkginstall $2 ${zsh[@]} || "Error: could not install ZSH packages."
cd /home/$2/developments/linux-config/configs && sudo -u $2 stow zsh -t /home/$2/
chsh -s /bin/zsh "$2" >/dev/null 2>&1