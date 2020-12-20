#!/bin/bash

check_package() {
    # checking if installation was successful
    if pacman -Qi $1 &> /dev/null; then
        tput setaf 2
        echo "The package "$1" is already installed"
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

