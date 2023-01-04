#!/bin/bash
source scripts/distros/$1.sh

cd /home/$2/developments/linux-config/configs && sudo -u $2 stow ssh -t /home/$2/
ssh=(openssh keychain)
pkginstall $2 ${ssh[@]} || "Error: could not install SSH packages."
read -p "Insert your email: " email
sudo -u $2 ssh-keygen -t ed25519 -C "$email"
sudo -u $2 git config --global user.email "$email"