#!/bin/bash

AURHELPER=yay

aurhelperinstall() {
	tput setaf 3
	echo "Installing aur helper "$AURHELPER""
	tput sgr0
	sudo -u "$1" mkdir -p "/tmp/$AURHELPER"
	sudo -u "$1" git -C "/tmp" clone --depth 1 --single-branch --no-tags -q "https://aur.archlinux.org/$AURHELPER.git" "/tmp/$AURHELPER" ||
		{
			cd "/tmp/$AURHELPER" || return 1
			sudo -u "$1" git pull --force origin master
		}
	cd "/tmp/$AURHELPER" || exit 1
	sudo -u "$1" -D "/tmp/$AURHELPER" makepkg --noconfirm -si >/dev/null 2>&1 || return 1
}

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
				rm -rf "/tmp/$item"
				sudo -u "$username" mkdir -p "/tmp/$item"
				sudo -u "$username" git -C "/tmp" clone --depth 1 --single-branch --no-tags -q "https://aur.archlinux.org/$item.git" "/tmp/$item" ||
				{
					cd "/tmp/$item" || return 1
					sudo -u "$name" git pull --force origin master
				}
				cd "/tmp/$item" || exit 1
				sudo -u "$username" -D "/tmp/$item" makepkg --noconfirm -si >/dev/null 2>&1 || return 1
			fi
		fi
	done
}

refreshkeys() {
	tput setaf 3
	echo "Refresh arch keyring"
	tput sgr0
	case "$(readlink -f /sbin/init)" in
	*systemd*)
		pacman --noconfirm -S archlinux-keyring >/dev/null 2>&1
		;;
	*)
		if ! grep -q "^\[universe\]" /etc/pacman.conf; then
			echo "[universe]
Server = https://universe.artixlinux.org/\$arch
Server = https://mirror1.artixlinux.org/universe/\$arch
Server = https://mirror.pascalpuffke.de/artix-universe/\$arch
Server = https://artixlinux.qontinuum.space/artixlinux/universe/os/\$arch
Server = https://mirror1.cl.netactuate.com/artix/universe/\$arch
Server = https://ftp.crifo.org/artix-universe/" >>/etc/pacman.conf
			pacman -Sy --noconfirm >/dev/null 2>&1
		fi
		pacman --noconfirm --needed -S \
			artix-keyring artix-archlinux-support >/dev/null 2>&1
		for repo in extra community; do
			grep -q "^\[$repo\]" /etc/pacman.conf ||
				echo "[$repo]
Include = /etc/pacman.d/mirrorlist-arch" >>/etc/pacman.conf
		done
		pacman -Sy >/dev/null 2>&1
		pacman-key --populate archlinux >/dev/null 2>&1
		;;
	esac
}