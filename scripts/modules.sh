#!/bin/bash
source scripts/utils.sh
source scripts/distros/$1.sh

installbasics() {
    # Refresh arch keyring
    pacman --noconfirm -Sy archlinux-keyring >/dev/null 2>&1
    # refreshkeys || "Error: could not refresh keys."

    # Install base packages
    base=(sudo sed curl stow unzip)
    pkginstall root ${base[@]} || "Error: could not install UTILS packages."
}

createuser() {
    read -p "Insert user name: " username
    if id "$username" &>/dev/null; then
        echo $username
    else
        adduser $username wheel || "Error: could not add user."
        addsudo $username || "Error: could not add user to sudoers."
        echo $username
    fi
}

configureshell() {
    zsh=(zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting)
    pkginstall $1 ${zsh[@]} || "Error: could not install ZSH packages."
    cd /home/$1/developments/linux-config/configs && sudo -u $1 stow zsh -t /home/$1/
    chsh -s /bin/zsh "$1" >/dev/null 2>&1
}

configuressh() {
    cd /home/$1/developments/linux-config/configs && sudo -u $1 stow ssh -t /home/$1/
    ssh=(openssh keychain)
    pkginstall $1 ${ssh[@]} || "Error: could not install SSH packages."
    read -p "Insert your email: " email
    sudo -u $1 ssh-keygen -t ed25519 -C "$email"
    sudo -u $1 git config --global user.email "$email"
}

configuredesktop() {
    xorg=(xorg-server xorg-xwininfo xorg-xinit xorg-xprop xorg-xdpyinfo xorg-xbacklight xorg-xrandr xorg-xrdb xorg-xbacklight)
    pkginstall $1 ${xorg[@]} || "Error: could not install XORG packages."
    cd /home/$1/developments/linux-config/configs && sudo -u $1 stow xserver -t /home/$1/

    gitmakeinstall https://github.com/nash169/dwm.git || "Error: could not install TWM packages."
    desktop=(xcompmgr feh slock dmenu)
    pkginstall $1 ${desktop[@]} || "Error: could not install DESKTOP packages."
    cd /home/$1/developments/linux-config/configs && sudo -u $1 stow walls -t /home/$1/
}

configureterminal() {
    gitmakeinstall https://github.com/nash169/st.git || "Error: could not install TERMINAL packages."
    terminal=(tmux exa)
    pkginstall $1 ${terminal[@]} || "Error: could not install TERMINAL packages."

    curl --output-dir /tmp/ -LO https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip
    unzip /tmp/Hack-v3.003-ttf.zip
    mkdir -p /home/$1/.local/share/fonts/
    cp /tmp/ttf/* /home/$1/.local/share/fonts/
}