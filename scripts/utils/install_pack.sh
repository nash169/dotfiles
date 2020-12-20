#!/bin/bash

# ARCH
pacman_install() {
    if pacman -Ss $1 &> /dev/null; then
        tput setaf 3
        echo "Installing package "$1" with pacman"
        tput sgr0
        sudo pacman -S --noconfirm --needed $1
    fi
}

aur_install() {
    if pacman -Qi yay &> /dev/null; then
        tput setaf 3
        echo "Installing package "$1" with yay"
        tput sgr0
        yay -S --noconfirm $1
    fi
}

makepkg_install() { # Installs $1 manually if not installed. Used only for AUR helper here.
	[ -f "/usr/bin/$1" ] || (
	dialog --infobox "Installing \"$1\"..." 4 50
	cd /tmp || exit 1
	rm -rf /tmp/"$1"*
	curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz &&
	sudo -u "$name" tar -xvf "$1".tar.gz >/dev/null 2>&1 &&
	cd "$1" &&
	sudo -u "$name" makepkg --noconfirm -si >/dev/null 2>&1
	cd /tmp || return 1)
}

gitmake_install() {
	progname="$(basename "$1" .git)"
	dir="~/repos/$progname"
	git clone --depth 1 "$1" "$dir" >/dev/null 2>&1 || { cd "$dir" || return 1 ; git pull --force origin master;}
	cd "$dir" || exit 1
	make clean install >/dev/null 2>&1
	cd /tmp || return 1
}