#!/bin/bash

# Check if a package is installed
check_package() {
    if pacman -Qi $1 &> /dev/null; then
        tput setaf 2
        echo "The package "$1" is already installed"
        tput sgr0
        return false
    else
        tput setaf 1
        echo "Package "$1" has NOT been installed"
        tput sgr0
        return true
    fi
}

# Install package
install_package() {
	# pacman installation
    if pacman -Ss $1 &> /dev/null; then
        tput setaf 3
        echo "Installing package "$1" with pacman"
        tput sgr0
        sudo pacman -S --noconfirm --needed $1
    else if pacman -Qi yay &> /dev/null; then
	# Aur helper installation
		tput setaf 3
        echo "Installing package "$1" with yay"
        tput sgr0
        yay -S --noconfirm $1
	else
	# Manual installation with makepkg (in case aurhelper not installed)
		[ -f "/usr/bin/$1" ] || (
		dialog --infobox "Installing \"$1\"..." 4 50
		cd /tmp || exit 1
		rm -rf /tmp/"$1"*
		curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz &&
		sudo -u "$name" tar -xvf "$1".tar.gz >/dev/null 2>&1 &&
		cd "$1" &&
		sudo -u "$name" makepkg --noconfirm -si >/dev/null 2>&1
		cd /tmp || return 1)
	fi
}