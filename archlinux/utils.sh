#!/bin/bash

install_package() {
    # checking if application is already installed
	if pacman -Qi $1 &> /dev/null; then
		tput setaf 2
  		echo "###############################################################################"
  		echo "################## The package "$1" is already installed"
      	echo "###############################################################################"
      	echo
		tput sgr0
	else
        # install the package
        if pacman -Ss $1 &> /dev/null; then
            tput setaf 3
            echo "###############################################################################"
            echo "##################  Installing package "$1" with pacman"
            echo "###############################################################################"
            echo
            tput sgr0
            sudo pacman -S --noconfirm --needed $1
        elif pacman -Qi yay &> /dev/null; then
            tput setaf 3
            echo "################################################################"
            echo "######### Installing package "$1" with yay"
            echo "################################################################"
            echo
            tput sgr0
            yay -S --noconfirm $1
        fi
    fi

    # checking if installation was successful
    if pacman -Qi $1 &> /dev/null; then
        tput setaf 2
        echo "################################################################"
        echo "#########  Checking if package "$1" has been installed"
        echo "################################################################"
        echo
        tput sgr0
    else
        tput setaf 1
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo "!!!!!!!!!  Package "$1" has NOT been installed"
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo
        tput sgr0
    fi
}

package_category() {
	tput setaf 5;
	echo "################################################################"
	echo "Installing software for category " $1
	echo "################################################################"
	echo;tput sgr0
}