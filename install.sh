#!/bin/bash
source scripts/utils.sh
source scripts/distros/$1.sh

# INSTALL BASIC PACKAGES
base = (zsh zsh-autosuggestions zsh-syntax-highlighting curl cmake unzip sudo sed stow)
pkginstall base || "Error: could not install base packages."

# # ADD USER
# read -p "Insert user name (and pass): " name
# adduser name wheel || "Error: could not add user."
# addsudo naem || "Error: could not add user to sudoers."

# # GENERATE SSH KEY
# ssh = (openssh keychain)
# pkginstall ssh || "Error: "
# read -p "Insert your email: " email
# ssh-keygen -t ed25519 -C "$email"

# # DESKTOP
# desktop = (xcompmgr feh)

# # EDITOR
# editor = (neovim python-pynvim nerd-fonts-hack) # ninja tree-sitter lua luarocks

# # INSTALL CONFIGURATION FILES
# for dir in configs/*/; do stow $dir -t ~/; done

# # UTILS
# utils = (ripgrep fzf ranger)


# # TERMINAL
# terminal = (tmux)


# # Prerequisite for the last versiono of neovim
# pkginstall 

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
