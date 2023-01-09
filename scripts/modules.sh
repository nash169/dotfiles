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

    gitmakeinstall $1 https://github.com/nash169/dwm.git || "Error: could not install TWM packages."
    desktop=(xcompmgr feh slock dmenu)
    pkginstall $1 ${desktop[@]} || "Error: could not install DESKTOP packages."
    cd /home/$1/developments/linux-config/configs && sudo -u $1 stow walls -t /home/$1/
}

configureterminal() {
    gitmakeinstall $1 https://github.com/nash169/st.git || "Error: could not install TERMINAL packages."
    terminal=(tmux exa)
    pkginstall $1 ${terminal[@]} || "Error: could not install TERMINAL packages."

    sudo -u $1 curl --output-dir /tmp/ -LO https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip
    unzip /tmp/Hack-v3.003-ttf.zip -d /tmp/
    sudo -u $1 mkdir -p /home/$1/.local/share/fonts/
    sudo -u $1 cp /tmp/ttf/* /home/$1/.local/share/fonts/
}

configureeditor() {
    editor=(neovim python-pynvim) # ninja tree-sitter lua luarocks
    pkginstall $1 ${editor[@]} || "Error: could not install EDITOR packages."
    cd /home/$1/developments/linux-config/configs && sudo -u $1 stow neovim -t /home/$1/
}

developtools() {
    develop=(cmake texlive-core eigen clang)
    pkginstall $1 ${develop[@]} || "Error: could not install DEVELOP packages."
    cd /home/$1/developments/linux-config/configs && sudo -u $1 stow format -t /home/$1/
}

fileexplorer() {
    explorer=(ripgrep fzf lf-git ueberzug)
    pkginstall $1 ${explorer[@]} || "Error: could not install EXPLORER packages."
}

installbrowser() {
    browser=(firefox)
    pkginstall $1 ${browser[@]} || "Error: could not install BROWSER packages."
}

multimedia() {
    multimedia=(sxiv mpd mpc mpv)
    pkginstall $1 ${multimedia[@]} || "Error: could not install MULTIMEDIA packages."
}

readertools() {
    reader=(zathura zathura-pdf-mupdf zotero)
    pkginstall $1 ${reader[@]} || "Error: could not install READER packages."
}

configureemail() {
    email=(mutt-wizard-git)
    pkginstall $1 ${email[@]} || "Error: could not install EMAIL packages."
}

configuresound() {
    audio=(wireplumber pipewire-pulse pulsemixer)
    pkginstall $1 ${audio[@]} || "Error: could not install AUDIO packages."
}

configurebluetooth() {
    bluetooth=(pulseaudio-bluetooth bluez bluez-libs bluez-utils blueberry)
    pkginstall $1 ${bluetooth[@]} || "Error: could not install BLUETOOTH packages."
    systemctl enable bluetooth.service
    systemctl start bluetooth.service
    sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf
}

downloadtools() {
    download=(rtorrent-ps youtube-dl)
    pkginstall $1 ${download[@]} || "Error: could not install DOWNLOAD packages."
}