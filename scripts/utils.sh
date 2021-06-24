#!/bin/bash

# Prompts user for new username an password.
getuserandpass() { \
	name=$(dialog --inputbox "First, please enter a name for the user account." 10 60 3>&1 1>&2 2>&3 3>&1) || exit 1
	while ! echo "$name" | grep -q "^[a-z_][a-z0-9_-]*$"; do
		name=$(dialog --no-cancel --inputbox "Username not valid. Give a username beginning with a letter, with only lowercase letters, - or _." 10 60 3>&1 1>&2 2>&3 3>&1)
	done
	pass1=$(dialog --no-cancel --passwordbox "Enter a password for that user." 10 60 3>&1 1>&2 2>&3 3>&1)
	pass2=$(dialog --no-cancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
	while ! [ "$pass1" = "$pass2" ]; do
		unset pass2
		pass1=$(dialog --no-cancel --passwordbox "Passwords do not match.\\n\\nEnter password again." 10 60 3>&1 1>&2 2>&3 3>&1)
		pass2=$(dialog --no-cancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
	done
}

# Set user and pass
adduserandpass() { \
	# Adds user `$name` with password $pass1.
	dialog --infobox "Adding user \"$name\"..." 4 50
	useradd -m -g wheel -s /bin/zsh "$name" >/dev/null 2>&1 ||
	usermod -a -G wheel "$name" && mkdir -p /home/"$name" && chown "$name":wheel /home/"$name"
	repodir="/home/$name/.local/src"; mkdir -p "$repodir"; chown -R "$name":wheel "$(dirname "$repodir")"
	echo "$name:$pass1" | chpasswd
	unset pass1 pass2
}

# Install a group of pacakge
install_category() {
    while IFS=, read -r tag category program comment; do
        if [ $2 = $category ]
        then
            if [$tag = "i"]; then
                if [check_package $program]; then
                    install_package $program
                fi
            fi
        fi
	done < $1
}

# Instal make-based package from git
gitmake_install() {
	progname="$(basename "$1" .git)"
	dir="~/repos/$progname"
	git clone --depth 1 "$1" "$dir" >/dev/null 2>&1 || { cd "$dir" || return 1 ; git pull --force origin master;}
	cd "$dir" || exit 1
	make clean install >/dev/null 2>&1
	cd /tmp || return 1
}

# Install python package via pip
pipinstall() {
	dialog --title "LARBS Installation" --infobox "Installing the Python package \`$1\` ($n of $total). $1 $2" 5 70
	[ -x "$(command -v "pip")" ] || installpkg python-pip >/dev/null 2>&1
	yes | pip install "$1"
}

# Error message
error() { 
	clear; printf "ERROR:\\n%s\\n" "$1" >&2; exit 1
}

# Check package
pkgcheck() {
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
pkginstall() {
	for item in "$@"; do
		if [! pkgcheck $item]; then
			# pacman installation
			if pacman -Ss $item &> /dev/null; then
				tput setaf 3
				echo "Installing package "$item" with pacman"
				tput sgr0
				sudo pacman -S --noconfirm --needed $item
			# Aur helper installation
			else if pacman -Qi paru &> /dev/null; then
				tput setaf 3
				echo "Installing package "$item" with paru"
				tput sgr0
				paru -S --noconfirm $item
			fi
		fi
	done
}

