#!/bin/bash
source scripts/utils.sh
source scripts/$1.sh

refreshkeys || "Error: could not refresh keys."

# ESSENTIAL
base=(sudo sed curl stow)
pkginstall root ${base[@]} || "Error: could not install UTILS packages."

# ADD USER
read -p "Insert user name (and pass): " username
if id "$username" &>/dev/null; then
    echo 'User already exists'
else
    adduser $username wheel || "Error: could not add user."
    addsudo $username || "Error: could not add user to sudoers."
fi
sed -i '/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers

# BASIC UTILS
aurhelperinstall $username || "Error: could not install aur helper."

# FOLDERS
sudo -u $username mkdir  /home/$username/documents  /home/$username/developments  /home/$username/repositories  /home/$username/workspaces
sudo -u $username mkdir -p /home/$username/developments/linux-config
sudo -u $username git clone https://github.com/nash169/linux-config.git /home/$username/developments/linux-config

# ZSH
zsh=(zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting)
pkginstall $username ${zsh[@]} || "Error: could not install ZSH packages."
cd /home/$username/developments/linux-config/configs && sudo -u $username stow zsh -t /home/$username/
chsh -s /bin/zsh "$name" >/dev/null 2>&1

# SSH & GIT
cd /home/$username/developments/linux-config/configs && sudo -u $username stow ssh -t /home/$username/
ssh=(openssh keychain)
pkginstall $username ${ssh[@]} || "Error: could not install SSH packages."
read -p "Insert your email: " email
sudo -u $username ssh-keygen -t ed25519 -C "$email"
sudo -u $username git config --global user.email "$email"

# DESkTOP
xorg=(xorg-server xorg-xwininfo xorg-xinit xorg-xprop xorg-xdpyinfo xorg-xbacklight xorg-xrandr xorg-xrdb xorg-xbacklight)
pkginstall $username ${xorg[@]} || "Error: could not install XORG packages."
cd /home/$username/developments/linux-config/configs && sudo -u $username stow xserver -t /home/$username/

gitmakeinstall https://github.com/nash169/dwm.git || "Error: could not install TWM packages."
desktop=(xcompmgr feh slock dmenu)
pkginstall $username ${desktop[@]} || "Error: could not install DESKTOP packages."
cd /home/$username/developments/linux-config/configs && sudo -u $username stow walls -t /home/$username/
sudo -u $username feh --bg-scale /home/$username/.config/walls/01.png

# TERMINAL
gitmakeinstall $username https://github.com/nash169/st.git || "Error: could not install TERMINAL packages."
terminal=(tmux exa nerd-fonts-hack)
pkginstall $username ${terminal[@]} || "Error: could not install TERMINAL packages."

# EDITOR
editor=(neovim python-pynvim) # ninja tree-sitter lua luarocks
pkginstall $username ${editor[@]} || "Error: could not install EDITOR packages."
cd /home/$username/developments/linux-config/configs && sudo -u $username stow neovim -t /home/$username/

# DEVELOP
develop=(cmake texlive-core eigen waf clang)
pkginstall $username ${develop[@]} || "Error: could not install DEVELOP packages."
cd /home/$username/developments/linux-config/configs && sudo -u $username stow format -t /home/$username/

# EXPLORER
explorer=(ripgrep fzf lf-git ueberzug)
pkginstall $username ${explorer[@]} || "Error: could not install EXPLORER packages."

# BROWSER
browser=(firefox)
pkginstall $username ${browser[@]} || "Error: could not install BROWSER packages."

# MULTIMEDIA
multimedia=(sxiv mpd mpc mpv)
pkginstall $username ${multimedia[@]} || "Error: could not install MULTIMEDIA packages."

# READER
reader=(zathura zathura-pdf-mupdf zotero)
pkginstall $username ${reader[@]} || "Error: could not install READER packages."

# EMAIL
email=(mutt-wizard-git)
pkginstall $username ${email[@]} || "Error: could not install EMAIL packages."

# AUDIO
audio=(wireplumber pipewire-pulse pulsemixer)
pkginstall $username ${audio[@]} || "Error: could not install AUDIO packages."

# BLUETOOTH
bluetooth=(pulseaudio-bluetooth bluez bluez-libs bluez-utils blueberry)
pkginstall $username ${bluetooth[@]} || "Error: could not install BLUETOOTH packages."
systemctl enable bluetooth.service
systemctl start bluetooth.service
sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf

# DOWNLOAD
download=(rtorrent-ps youtube-dl)
pkginstall $username ${download[@]} || "Error: could not install DOWNLOAD packages."

#
sed -i '/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/s/^/#/g' /etc/sudoers

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
