#!/bin/bash

# git clone https://aur.archlinux.org/paru.git
# cd paru
# makepkg -si

# Check package
pkgcheck() {
    if pacman -Qi $1 &> /dev/null; then
        tput setaf 2
        echo "The package "$1" is already installed"
        tput sgr0
        true
    else
        tput setaf 1
        echo "Package "$1" has NOT been installed"
        tput sgr0
        false
    fi
}

# Install package
pkginstall() {
	for item in "$@"; do
		if ! pkgcheck $item; then
			# pacman installation
			if pacman -Ss $item &> /dev/null; then
				tput setaf 3
				echo "Installing package "$item" with pacman"
				tput sgr0
				sudo pacman -Ssq --noconfirm --needed $item
			# Aur helper installation
			elif pacman -Qi paru &> /dev/null; then
				tput setaf 3
				echo "Installing package "$item" with paru"
				tput sgr0
				paru -Ssq --noconfirm $item
			else
				[ -f "/usr/bin/$item" ] || (
				cd /tmp || exit 1
				rm -rf /tmp/"$item"*
				curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/"$item".tar.gz &&
				tar -xvf "$1".tar.gz >/dev/null 2>&1 &&
				cd "$1" &&
				makepkg --noconfirm -si >/dev/null 2>&1
				cd /tmp || return 1)
			fi
		fi
	done
}