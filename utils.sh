#!/bin/bash

install_package() {
    # checking if application is already installed
	if pacman -Qi $1 &> /dev/null; then
		tput setaf 2
  		echo "The package "$1" is already installed"
		tput sgr0
	else
        # install the package
        if pacman -Ss $1 &> /dev/null; then
            tput setaf 3
            echo "Installing package "$1" with pacman"
            tput sgr0
            sudo pacman -S --noconfirm --needed $1
        elif pacman -Qi yay &> /dev/null; then
            tput setaf 3
            echo "Installing package "$1" with yay"
            tput sgr0
            yay -S --noconfirm $1
        fi
    fi

    
}

check_package() {
    # checking if installation was successful
    if pacman -Qi $1 &> /dev/null; then
        tput setaf 2
        echo "Checking if package "$1" has been installed"
        tput sgr0
    else
        tput setaf 1
        echo "Package "$1" has NOT been installed"
        tput sgr0
    fi
}

install_category() {
    while IFS=, read -r tag category program comment; do
        if [ $2 = $category ]
        then
            if [$tag = "i"]
            then
                install_package $program
                check_package $program
            fi
        fi
	done < $1
}

add_package() { 
    if [ -z "$1" ]
        then
            fileName="packages.csv"
        else
            fileName="$1/package.csv"
    fi

    read -p "Package name: " name
    read -p "Package comment: " comment
    read -p "Package category: " category
    read -p "Package tag: " tag

    echo "$tag,$category,$name,"$comment" " >> $fileName
}

manual_install() { # Installs $1 manually if not installed. Used only for AUR helper here.
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