#!/bin/bash
source scripts/utils.sh
source scripts/$1.sh

# ADD USER
read -p "Insert user name (and pass): " username
if id "$username" &>/dev/null; then
    echo 'User already exists'
else
    adduser $username wheel || "Error: could not add user."
    addsudo $username || "Error: could not add user to sudoers."
fi

# INSTALL BASIC UTILS
utils=(curl unzip sudo sed stow htop-vim)
pkginstall ${utils[@]} || "Error: could not install UTILS packages."

# INSTALL ZSH
zsh=(zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting)
pkginstall ${zsh[@]} || "Error: could not install ZSH packages."
stow configs/zsh -t /home/$username/

# SSH & GIT
stow configs/ssh -t /home/$username/
ssh=(openssh keychain)
pkginstall ${ssh[@]} || "Error: could not install SSH packages."
read -p "Insert your email: " email
ssh-keygen -t ed25519 -C "$email"
git config --global user.email "$email"

# DESkTOP
xorg=(xorg-server xorg-xwininfo xorg-xinit xorg-xprop xorg-xdpyinfo xorg-xbacklight xorg-xrandr xorg-xrdb xorg-xbacklight)
pkginstall ${xorg[@]} || "Error: could not install XORG packages."
stow configs/xserver -t /home/$username/

gitmakeinstall https://github.com/nash169/dwm.git
desktop=(xcompmgr feh slock dmenu)
pkginstall ${desktop[@]} || "Error: could not install DESKTOP packages."
stow configs/walls -t /home/$username/
feh --bg-scale /home/$username/.config/walls/01.png

# TERMINAL
gitmakeinstall https://github.com/nash169/st.git
terminal=(tmux exa nerd-fonts-hack)
pkginstall ${terminal[@]} || "Error: could not install TERMINAL packages."

# EDITOR
editor=(neovim python-pynvim) # ninja tree-sitter lua luarocks
pkginstall ${editor[@]} || "Error: could not install EDITOR packages."
stow configs/neovim -t /home/$username/

# DEVELOP
develop=(cmake texlive-core eigen waf clang)
pkginstall ${develop[@]} || "Error: could not install DEVELOP packages."
stow configs/format -t /home/$username/

# EXPLORER
explorer=(ripgrep fzf lf-git ueberzug)
pkginstall ${explorer[@]} || "Error: could not install EXPLORER packages."

# BROWSER
browser=(firefox)
pkginstall ${browser[@]} || "Error: could not install BROWSER packages."

# MULTIMEDIA
multimedia=(sxiv mpd mpc mpv)
pkginstall ${multimedia[@]} || "Error: could not install MULTIMEDIA packages."

# READER
reader=(zathura zathura-pdf-mupdf zotero)
pkginstall ${reader[@]} || "Error: could not install READER packages."

# EMAIL
email=(mutt-wizard-git)
pkginstall ${email[@]} || "Error: could not install EMAIL packages."

# AUDIO
audio=(wireplumber pipewire-pulse pulsemixer)
pkginstall ${audio[@]} || "Error: could not install AUDIO packages."

# # BLUETOOTH
# bluetooth=(pulseaudio-bluetooth bluez bluez-libs bluez-utils blueberry)
# pkginstall ${bluetooth[@]} || "Error: could not install BLUETOOTH packages."
# sudo systemctl enable bluetooth.service
# sudo systemctl start bluetooth.service
# sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf

# DOWNLOAD
download=(rtorrent-ps youtube-dl)
pkginstall ${download[@]} || "Error: could not install DOWNLOAD packages."

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
