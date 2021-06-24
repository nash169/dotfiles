#!/bin/bash
source utils.sh


# CONNECT
echo "Check if internet connection is present..."

ping -c 3 google.com
if [ $? -eq  0 ]; then
        echo "Ping Success";
else
        echo "Ping Failed";
        echo "Trying to connect..."
        wifi-menu || error "Wifi-menu not found. Connect and run the configurtion again."
fi

# CHANGE GROUP
read -p "Choose one of the following:
(1) Add group
(2) Change group
(3) Skip" input

if [ $input = "1" ]; then
    useradd -m -g wheel -s /bin/zsh "$name" >/dev/null 2>&1 ||
	usermod -a -G wheel "$name" && mkdir -p /home/"$name" && chown "$name":wheel /home/"$name"
else if [ $input = "2" ]; then
    read -p "Group to change: " oldname
    read -p "New group name: " newname
    
    groupmod −n newname oldname
fi

# CHANGE USER
read -p "Choose one of the following:
(1) Add user
(2) Change user
(3) Skip" input

if [ $input = "1" ]; then
    useradd -m -g wheel -s /bin/zsh "$name" >/dev/null 2>&1 ||
	usermod -a -G wheel "$name" && mkdir -p /home/"$name" && chown "$name":wheel /home/"$name"
else if [ $input = "2" ]; then
    read -p "Username to change: " oldname

    if [$oldname = "root"]; then
        read -p "Root selected. Do you want to change pass? [y/N]: " input
        if [ $input = "y" ] || [ $input = "Y" ]; then
            passwd root
        fi
    else
        read -p "Do you want to change the username? [y/N]: " input
        if [ $input = "y" ] || [ $input = "Y" ]; then
            read -p "New username: " newname
            usermod -l $newname $oldname
            usermod -m -d /home/$newname $newname
        fi
        read -p "Do you want to change the password? [y/N]: " input
        if [ $input = "y" ] || [ $input = "Y" ]; then
            passwd $newname
        fi
    fi
fi

# ADD USER TO SUDO
read -p "Do you want to add a user to sudoers? [y/N]: " input
if [ $input = "y" ] || [ $input = "Y" ]; then
    pkginstall sudo sed || error "Could not install desired packages."
    read -p "Username to add: " name
    sed "/^root ALL=(ALL) ALL.*/a "$name" ALL=(ALL) ALL" /etc/sudoers
fi

# SET MACHINE NAME
read -p "Do you want to set the machine name? [y/N]: " input
if [ $input = "y" ] || [ $input = "Y" ]; then
    read -p "Machine name: " name
    echo $name > /etc/hostname
    echo "127.0.0.1 localhost
    ::1     localhost
    127.0.0.1 "$name"" > /etc/hosts
fi

# Install configuration
pkginstall stow || error "Could not install desired packages."

read -p "Which configuration do you want to install?
(1) xserver
(2) zsh
(2) dwm
(3) bspwm
(4) sxhkd
(5) polybar
(6) ranger
(7) neovim
(8) clang format
(9) helpers
(3) Skip" input

# CONFIGURE XSERVER

# Install feh for setting the wallapaper
pkginstall feh

# Install xcompmgr for transparency
pkginstall xcompmgr


# TERMINAL

# Install font
pkginstall nerd-fonts-hack

# Github SSH
pkginstall xclip

ssh−keygen −t ed25519 −C ”bernardo.fichera@gmail.com”

xclip -selection clipboard < ~/.ssh/id_ed25519.pub
