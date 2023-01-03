#!/bin/bash

AURHELPER=paru

# aurhelperinstall() {
# 	tput setaf 3
# 	echo "Installing aur helper "$AURHELPER""
# 	tput sgr0
# 	sudo -u "$1" mkdir -p "/tmp/$AURHELPER"
# 	sudo -u "$1" git -C "/tmp" clone --depth 1 --single-branch --no-tags -q "https://aur.archlinux.org/$AURHELPER.git" "/tmp/$AURHELPER" ||
# 		{
# 			cd "/tmp/$AURHELPER" || return 1
# 			sudo -u "$1" git pull --force origin master
# 		}
# 	cd "/tmp/$AURHELPER" || exit 1
# 	sudo -u "$1" -D "/tmp/$AURHELPER" makepkg --noconfirm -si >/dev/null 2>&1 || return 1
# }

# Check package -> $1: package
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

# Install package -> $1: user, $@: packages
pkginstall() {
	username=$1
	shift
	for item in "$@"; do
		if ! pkgcheck $item; then
			# pacman installation
			if pacman -Ss $item &> /dev/null; then
				tput setaf 3
				echo "Installing package "$item" with pacman"
				tput sgr0
				pacman -S --noconfirm --needed $item
			# Aur helper installation
			elif pacman -Qi $AURHELPER &> /dev/null; then
				tput setaf 3
				echo "Installing package "$item" with "$AURHELPER""
				tput sgr0
				sudo -u "$username" $AURHELPER -S --noconfirm $item
			else
				tput setaf 3
				echo "Installing package "$item" from source"
				tput 
				dir="/home/$username/$item"
				rm -rf "$dir"
				sudo -u "$username" mkdir -p "$dir"
				sudo -u "$username" git -C "/tmp" clone --depth 1 --single-branch --no-tags -q "https://aur.archlinux.org/$item.git" "$dir" ||
					{
						cd "$dir" || return 1
						sudo -u "$name" git pull --force origin master
					}
				cd "$dir" || exit 1
				sudo -u "$username" -D "$dir" makepkg --noconfirm -si >/dev/null 2>&1 || return 1
			fi
		fi
	done
}