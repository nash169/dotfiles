#!/bin/bash

# Add user -> $1: name, $2: group
adduser() {
	# Adds user
	useradd -m -g $2 "$1" >/dev/null 2>&1 ||
	# Something about the user to the group
	usermod -a -G $2 "$1" && mkdir -p /home/"$1" && chown "$1":$2 /home/"$1"
	# Set password
	passwd $1
}

# Change user -> $1: oldname, $2: newname
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

# Add user to sudoers -> $1: username
addsudo() {
	sed -i "/^root ALL=(ALL:ALL) ALL.*/a "$1" ALL=(ALL:ALL) ALL" /etc/sudoers
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

# Install make-based package from git -> $1: user, $2: git address
gitmakeinstall() {
	progname="$(basename "$2" .git)"
	rm -rf /tmp/"$progname"*
	dir="/tmp/$progname"
	sudo -u "$1" git clone --depth 1 "$2" "$dir" >/dev/null 2>&1 || { cd "$dir" || return 1 ; sudo -u "$1" make clean install >/dev/null 2>&1;}
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