#!/bin/bash

# Create user
adduser() {
	# Adds user
	useradd -m -g $2 "$1" >/dev/null 2>&1 ||
	# Something about the user to the group
	usermod -a -G $2 "$1" && mkdir -p /home/"$1" && chown "$1":$2 /home/"$1"
	# Set password
	passwd $1
}

changeuser() {
	# Change username
	usermod -l $2 $1
    # Creta home folder
	usermod -m -d /home/$2 $1
	# Set pasword
	if [$# -eq 3]; then
		passwd $2
	fi
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

