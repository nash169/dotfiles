#!/bin/sh

error() {
    printf "%s\n" "$1" >&2
    return 1
}

pkg-check() {
    pacman -Qi $1 &> /dev/null && return 0
    return 1
}

username() {
    if [ -z ${NAME+x} ]; then
        NAME=$(whiptail --inputbox "Enter the username." 8 78 3>&1 1>&2 2>&3) || return
    fi
}

userrepo() {
    username || error "Could not get username."
    if [ -z "$REPODIR" ]; then
        REPODIR=/home/$NAME/$(whiptail --inputbox "Enter repository directory." 8 78 3>&1 1>&2 2>&3) || return
    fi
    [ -d "$REPODIR" ] || sudo -u "$NAME" mkdir -p "$REPODIR"
}

dotfiles() {
    userrepo || { echo "Could not repository directory"; return; }
    if [ ! -d "$REPODIR/dotfiles" ]; then
        whiptail --title "Dotfiles" --yesno "Install Dofiles?" 8 78 || return
        sudo -u "$NAME" git clone https://github.com/nash169/dotfiles.git "$REPODIR/dotfiles"
        if [ ! -d "/home/$NAME/.config" ]; then
            sudo -u "$NAME" mkdir -p "/home/$NAME/.config"
        fi
    fi
}

pkg-install() {
    username=$1
    shift
    for item in "$@"; do
	if ! pkg-check $item; then
	    if pacman -Ss $item &> /dev/null; then
                tput setaf 3
                echo "Installing package "$item" with pacman"
                tput sgr0
                pacman -S --noconfirm --needed $item
	    elif pacman -Qi $AURHELPER &> /dev/null; then
                sed -i '/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers
                tput setaf 3
                echo "Installing package "$item" with "$AURHELPER""
                tput sgr0
                sudo -u "$username" $AURHELPER -S --noconfirm $item
                sed -i '/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/s/^/#/g' /etc/sudoers
	    else
                sed -i '/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers
                tput setaf 3
                echo "Installing package "$item" from source"
                tput 
                rm -rf "/tmp/$item"
                sudo -u "$username" mkdir -p "/tmp/$item"
                sudo -u "$1" git -C "/tmp" clone --depth 1 --single-branch --no-tags -q "https://aur.archlinux.org/$2.git" "/tmp/$2" ||
                    {
                        cd "/tmp/$item" || return 1
                        sudo -u "$username" git pull --force origin master
                    }
                cd "/tmp/$2" || exit 1
                sudo -u "$1" makepkg --noconfirm -si >/dev/null 2>&1 || return 1
                sed -i '/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/s/^/#/g' /etc/sudoers
	    fi
	fi
    done
}

font-install() {
    sudo -u $NAME curl -L -o /tmp/fonts.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
    [ $? -eq 0 ] || { echo "Download failed."; return; }

    sudo -u $NAME mkdir -p /tmp/fonts
    sudo -u $NAME unzip /tmp/fonts.zip -d /tmp/fonts/
    [ $? -eq 0 ] || { echo "Extraction failed."; return; }

    FONTSDIR=/home/$NAME/.local/share/fonts
    [ ! -d $FONTSDIR ] && sudo -u $NAME mkdir -p $FONTSDIR
    cp /tmp/fonts/JetBrainsMonoNerdFont-* $FONTSDIR
    # rm -rf /tmp/file.zip /tmp/fonts
}

tools-install() {
    TOOLS=$1
    shift
    whiptail --title "Install $TOOLS tools" --yesno "Do you want to install $TOOLS tools?" 8 78 || { echo "User exit"; return; }
    username || error "Could not get username."
    CHECKLIST=()
    for PKG in "$@"; do
        echo "$PKG"
        CHECKLIST+=("$PKG" "" OFF)
    done

    CHOICES=$(whiptail --title "Install $TOOLS tools" \
        --checklist "Choose packages to install" 20 78 12 \
        "${CHECKLIST[@]}" 3>&1 1>&2 2>&3) || { echo "User exit"; return; }
    CHOICES=$(echo "$CHOICES" | tr -d '"')
    pkg-install $NAME ${CHOICES[@]} || error "Could not install $TOOLS tools packages."
}


#====================================================================================================
# MODULES
#====================================================================================================
user-add() {
    whiptail --title "Add User" --yesno "Add new user?" 8 78 || return
    NAME=$(whiptail --inputbox "Enter username" 8 78 --title "Add User" 3>&1 1>&2 2>&3) || return
    while ! echo "$NAME" | grep -q "^[a-z_][a-z0-9_-]*$"; do
        NAME=$(whiptail --inputbox "Username not valid. Give a username beginning with a letter, with only lowercase letters, - or _." 8 78 --title "Add User" 3>&1 1>&2 2>&3 3>&1) || return
    done
    if id -u "$NAME" >/dev/null 2>&1; then 
        whiptail --title "Warning" --msgbox "The user already exist." 8 78
        return
    fi
    PASS=$(whiptail --passwordbox "Enter password" 8 78 --title "Add User" 3>&1 1>&2 2>&3) || return
    useradd -m -g wheel -s /bin/zsh "$NAME" >/dev/null 2>&1 || usermod -a -G wheel "$NAME" && mkdir -p /home/"$NAME" && chown "$NAME":wheel /home/"$NAME"
    echo "$NAME:$PASS" | chpasswd
    unset PASS

    [ -d /home/$NAME/.config ] || sudo -u $NAME mkdir -p /home/$NAME/.config
    cat >/home/$NAME/.config/user-dirs.dirs <<EOF
        XDG_DESKTOP_DIR=""
        XDG_DOWNLOAD_DIR="$HOME/downloads"
        XDG_TEMPLATES_DIR=""
        XDG_PUBLICSHARE_DIR=""
        XDG_DOCUMENTS_DIR="$HOME/docs"
        XDG_MUSIC_DIR="$HOME/music"
        XDG_PICTURES_DIR="$HOME/pictures"
        XDG_VIDEOS_DIR="$HOME/videos"
EOF
}
#====================================================================================================
aurhelper-install() {
    PKGS=$(whiptail --title "Install AUR helper?" --checklist "Choose AUR helper" 8 78 \
        "yay" "" ON \
        "paru" "" OFF 3>&1 1>&2 2>&3) || { echo "User exit"; return; }
    username || error "Could not get username."
    [ -z "$PKGS" ] && { echo "No option selected"; return; }
    sed -i '/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers
    for PKG in $PKGS; do
        rm -rf "/tmp/$PKG"
        sudo -u "$NAME" mkdir -p "/tmp/$PKG"
        sudo -u "$1" git -C "/tmp" clone --depth 1 --single-branch --no-tags -q "https://aur.archlinux.org/$2.git" "/tmp/$2" ||
            {
                cd "/tmp/$item" || return 1
                sudo -u "$NAME" git pull --force origin master
            }
        cd "/tmp/$2" || exit 1
        sudo -u "$1" makepkg --noconfirm -si >/dev/null 2>&1 || return 1
    done
    sed -i '/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/s/^/#/g' /etc/sudoers
}
#====================================================================================================
keyboard-setup() {
    # setup xorg
    cat >/etc/X11/xorg.conf.d/00-keyboard.conf <<EOF
        Section "InputClass"
                Identifier "system-keyboard"
                MatchIsKeyboard "on"
                Option "XkbLayout" "us"
                Option "XkbModel" "default"
                Option "XkbOptions" "ctrl:swapcaps,compose:ralt"
        EndSectionSection "InputClass"
EOF

    # setup console
    cat >/etc/vconsole.conf <<EOF
        KEYMAP=us
        XKBLAYOUT=us
        XKBMODEL=default
        XKBOPTIONS=ctrl:swapcaps,compose:ralt
EOF
}
#====================================================================================================
audio-setup() {
    whiptail --title "Install audio tools?" --yesno "Audio" 8 78 || return
    username || error "Could not get username."

    # install audio
    PKGS=(
        pipewire 
        wireplumber 
        pipewire-pulse
    )
    pkginstall $NAME ${PKGS[@]} || error "Could not install AUDIO packages."

    # autostart
    [ $INITSYS == "systemd" ] && systemctl start pipewire-pulse.socket
    [ $INITSYS == "runit" ] && {
        cat > /etc/pipewire/pipewire.conf.d/user-session.congf <<EOF
            context.exec = [
                { path = "/usr/bin/wireplumber" args = "" condition = [ { exec.session-manager = null } { exec.session-manager = true } ] }
                { path = "/usr/bin/pipewire" args = "-c pipewire-pulse.conf" condition = [ { exec.pipewire-pulse = null } { exec.pipewire-pulse = true } ] }
            ]
EOF
    }
}
#====================================================================================================
bluetooth-setup() {
    whiptail --title "Install the bluetooth tools?" --yesno "Bluetooth" 8 78 || return
    username || error "Could not get username."

    # install bluetooth
    PKGS=(
        bluez
        bluez-utils
    )
    pkg-install $NAME ${PKGS[@]} || error "Could not install BLUETOOTH packages."

    # autostart
    [ $INITSYS == "runint" ] && pkg-install $NAME bluez-ruinit && sudo ln -s /etc/runit/sv/bluetoothd /run/runit/service/ && sudo sv up bluetoothd
    [ $INITSYS == "systemd" ] && systemctl enable bluetooth.service && systemctl start bluetooth.service
    sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf
}
#====================================================================================================
desktop-setup() {
    whiptail --title "Desktop" --yesno "Install Desktop?" 8 78 || return
    dotfiles || error "Could not fetch the dotfiles."

    # install xorg
    XORG=(xorg-server xorg-xwininfo xorg-xinit xorg-xprop xorg-xdpyinfo xorg-xbacklight xorg-xrandr xorg-xrdb xorg-xbacklight)
    pkginstall $NAME ${XORG[@]} || error "Could not install XORG packages."

    # install desktop tool
    DESKTOP=(
        xcompmgr    # -> terminal transparency
        feh         # -> set desktop background
        maim        # -> take screenshot
        xautolock   # -> autolock screen
        lm_sensor   # -> temp monitor in status bar
        # lm_sensors-runit
    )
    pkginstall $NAME ${DESKTOP[@]} || error "Could not install XORG packages."

    # install fonts
    [ ! -f "/home/$NAME/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf" ] && font-install

    # install dwm
    sudo -u $NAME git clone https://github.com/nash169/dwm.git $REPODIR/dwm 
    sudo -u $NAME git -C $REPODIR/dwm remote add upstream git://git.suckless.org/dwm
    # sudo -u $NAME git -C $REPODIR/dwm fetch upstream
    # sudo -u $NAME git -C $REPODIR/dwm merge[rebase] upstream/master
    [ -d "/home/$NAME/.local/bin" ] || sudo -u "$NAME" mkdir -p "/home/$NAME/.local/bin"
    if [ -d "$REPODIR/dotfiles" ]; then
        cd $REPODIR/dotfiles && sudo -u $NAME stow walls -t /home/$NAME 
        cd $REPODIR/dotfiles && sudo -u $NAME stow xserver -t /home/$NAME 
        cd $REPODIR/dotfiles && sudo -u $NAME stow dwm -t $REPODIR/dwm 
    fi
    cd $REPODIR/dwm && make install

    # install statusbar
    sudo -u $NAME git clone https://github.com/nash169/dwmstatus.git $REPODIR/dwmstatus 
    sudo -u $NAME git -C $REPODIR/dwmstatus remote add upstream git://git.suckless.org/dwmstatus 
    cd "$REPODIR/dwmstatus" && make clean install

    # install lock screen
    sudo -u $NAME git clone https://github.com/nash169/slock.git $REPODIR/slock 
    sudo -u $NAME git -C $REPODIR/slock remote add upstream git://git.suckless.org/slock 
    cd "$REPODIR/slock" && make clean install

    # lock on sleep
    if [ $INITSYS == "systemd" ]; then
        cat >/etc/systemd/system/slock@.service <<EOF
            [Unit]
            Description=Lock X session using slock for user %i
            Before=sleep.target

            [Service]
            User=%i
            Environment=DISPLAY=:0
            ExecStartPre=/usr/bin/xset dpms force suspend
            ExecStart=/usr/bin/local/slock

            [Install]
            WantedBy=sleep.target
EOF
        systemctl enable "slock@$NAME.service"
    elif [ $INITSYS == "runit" ]; then 
        cat >/etc/elogind/system-sleep/lockonsleep <<EOF
            #!/bin/sh
            # /lib/elogind/system-sleep/lock.sh
            # Lock before suspend integration with elogind

            username=$NAME
            userhome=/home/$username
            export XAUTHORITY="$userhome/.Xauthority"
            export DISPLAY=":0.0"
            case "${1}" in
                pre)
                    su $username -c "/usr/bin/slock" &
                    sleep 1s;
                    ;;
            esac
EOF
        chmod +x /etc/elogind/system-sleep/lockonsleep
    fi

    # install menu bar
    sudo -u $NAME git clone https://github.com/nash169/dmenu.git $REPODIR/dmenu 
    sudo -u $NAME git -C $REPODIR/dmenu remote add upstream git://git.suckless.org/dmenu 
    cd "$REPODIR/dmenu" && make clean install

}
#====================================================================================================
terminal-setup() {
    whiptail --title "Terminal" --yesno "Install Terminal?" 8 78 || return
    dotfiles || error "Could not fetch the dotfiles."

    # install font
    [ ! -f "/home/$NAME/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf" ] && font-install

    # install terminal
    sudo -u $NAME git clone https://github.com/nash169/st.git $REPODIR/st 
    sudo -u $NAME git -C $REPODIR/st remote add upstream git://git.suckless.org/st 
    [ -d "$REPODIR/dotfiles" ] && cd $REPODIR/dotfiles && sudo -u stow st -t $REPODIR/st 
    cd $REPODIR/st && make install
}
#====================================================================================================
shell-setup() {
    whiptail --title "Shell" --yesno "Install Shell?" 8 78 || return
    dotfiles || error "Could not fetch the dotfiles."

    # install shell tools
    PKGS=(
        tmux
        eza
        bat
        ripgrep
        fzf
        htop
        xclip
        qrencode
        zbar
        pdftk
        zsh
        zsh-completions
        zsh-autosuggestions
        zsh-syntax-highlighting
    )
    pkginstall $NAME ${PKGS[@]} || error "Could not install SHELL packages."

    # activate shell
    chsh -s /bin/zsh "$NAME" >/dev/null 2>&1
    [ -d "$REPODIR/dotfiles" ] && cd $REPODIR/dotfiles && sudo -u $NAME stow zsh -t /home/$NAME
    mkdir -p "/home/$NAME/.cache/zsh" && touch "$HISTFILE"
}
#====================================================================================================
editor-setup() {
    whiptail --title "Editor" --yesno "Install Editor?" 8 78 || return
    dotfiles || error "Could not fetch the dotfiles."

    # install editor
    PKGS=(
        neovim 
        python-pynvim
        python-pip
        npm
        wget
        ninja
        tree-sitter
        lua51
        luarocks
        lazygit
        xclip
        ripgrep
        fd
    )
    # sudo -u $NAME npm install -g neovim
    pkginstall $NAME ${PKGS[@]} || error "Could not install EDITOR packages."
    if [ ! -d "$REPODIR/dotfiles" ]; then
        cd $REPODIR/dotfiles && sudo -u $NAME stow nvim -t /home/$NAME
        cd $REPODIR/dotfiles && sudo -u $NAME stow format -t /home/$NAME
    fi

    # install tex
    whiptail --title "Editor" --yesno "Install Tex?" 8 78 && {
        PKGS=(
            texlive-bin 
            texlive-fontsrecomended 
            texlive-latexextra 
            texlive-latexrecomended 
            texlive-latex 
            texlive-basic 
            texlive-xetex 
            texlive-mathscience 
            texlive-fontsextra 
            texlive-langenglish 
            texlive-context
            texlive-luatex
            texlive-plaingeneric
            texlive-binextra
            texlive-bibtexextra
            texlive-pictures
            texlive-langfrench
            texlive-langgerman
            texlive-fontutils
        )
        pkginstall $NAME ${PKGS[@]} || error "Could not install EDITOR packages."
    }
}
#====================================================================================================
explorer-setup() {
    whiptail --title "Explorer" --yesno "Install Explorer?" 8 78 || return
    dotfiles || error "Could not fetch the dotfiles."

    # install file explorer
    PKGS=(
        lf-git
        # ueberzug
        ueberzugpp-new-git
    )
    pkginstall $NAME ${PKGS[@]} || error "Could not install EXPLORER packages."
    [ -d "$REPODIR/dotfiles" ] && cd $REPODIR/dotfiles && sudo -u $NAME stow lf -t /home/$NAME
}
#====================================================================================================
browser-setup() {
    whiptail --title "Browser" --yesno "Install Browser?" 8 78 || return
    username || { echo "Could not get username"; return; }
    userrepo || { echo "Could not repository directory"; return; }
    PKGS=(
        firefox
    )
    pkg-install $NAME ${PKGS[@]} || error "Could not install BROWSER packages."
    PROFILENAME=$(whiptail --title "Browser" --inputbox "Enter profile name" 8 78 "default-release" 3>&1 1>&2 2>&3) || return
    sudo -u "$NAME" firefox --headless >/dev/null 2>&1 &
    sleep 1
    PROFILEDIR=/home/$NAME/.mozilla/firefox/$(sed -n "/Path=.*.$PROFILENAME/ s/.*=//p" "/home/$NAME/.mozilla/firefox/profiles.ini")
    whiptail --title "Browser" --yesno "Install Arkenfox?" 8 78 && {
        sudo -u $NAME git clone https://github.com/arkenfox/user.js.git $REPODIR/user.js 
        sudo -u $NAME ln -s "$REPODIR/dotfiles/browser/user-overrides.js" "$PROFILEDIR/user-overrides.js"
        sudo -u $NAME cp $REPODIR/user.js/updater.sh $PROFILEDIR && cd $PROFILEDIR && sudo -u $NAME sh updater.sh <<< $'Y'
        sudo -u $NAME cp $REPODIR/user.js/prefsCleaner.sh $PROFILEDIR && cd $PROFILEDIR && sudo -u $NAME sh prefsCleaner.sh <<< $'1'
    }
    # temp clone arkenfox/user.js and copy into fox profile user-overrides.js, updater.sh, prefsCleaner.sh
    ADDONS=$(whiptail --title "Firefox extensions" --separate-output --checklist "Choose extensions" 25 52 16 \
        "ublock-origin" "" OFF \
        "cookies-txt" "" OFF \
        "istilldontcareaboutcookies" "" OFF \
        "auth-helper" "" OFF 3>&1 1>&2 2>&3) || return
    # decentraleyes vim-vixen
    sudo -u "$username" mkdir -p "$PROFILEDIR/extensions/"
    for ADDON in $ADDONS; do
        addonurl="$(curl --silent "https://addons.mozilla.org/en-US/firefox/addon/${ADDON}/" | grep -o 'https://addons.mozilla.org/firefox/downloads/file/[^"]*')"
        file="${addonurl##*/}"
        sudo -u $NAME curl -L -o "/tmp/$file" "$addonurl"
        id="$(sudo -u $NAME unzip -p "/tmp/$file" manifest.json | grep "\"id\"")"
        id="${id%\"*}"
        id="${id##*\"}"
        sudo -u $NAME mv "/tmp/$file" "$PROFILEDIR/extensions/$id.xpi"
    done
    sudo -u $NAME pkill firefox
}
#====================================================================================================
gpg-setup() {
    whiptail --title "GPG Key" --yesno "Generate GPG key?" 8 78 && {
    username || error "Could not get username."

    # generate gpg key
    KEYTYPE=$(whiptail --title "GPG Keygen" --inputbox "Enter key type" 8 78 "1" 3>&1 1>&2 2>&3) || return
    KEYLENGTH=$(whiptail --title "GPG Keygen" --inputbox "Enter key length" 8 78 "3072" 3>&1 1>&2 2>&3) || return
    KEYVALIDITY=$(whiptail --title "GPG Keygen" --inputbox "Enter key expiration time" 8 78 "0" 3>&1 1>&2 2>&3) || return
    REALNAME=$(whiptail --title "GPG Keygen" --inputbox "Enter real name" 8 78 3>&1 1>&2 2>&3) || return
    EMAIL=$(whiptail --title "GPG Keygen" --inputbox "Enter email" 8 78 3>&1 1>&2 2>&3) || return
    COMMENT=$(whiptail --title "GPG Keygen" --inputbox "Enter comment" 8 78 3>&1 1>&2 2>&3) || return
    PASSPHRASE=$(whiptail --title "GPG Keygen" --passwordbox "Enter passphrase" 8 78 3>&1 1>&2 2>&3) || return
cat >/tmp/gpg-key-params <<EOF
    Key-Type: $KEYTYPE
    Key-Length: $KEYLENGTH
    Name-Real: $REALNAME
    Name-Comment: $COMMENT
    Name-Email: $EMAIL
    Expire-Date: $KEYVALIDITY
    Passphrase: $PASSPHRASE

    Subkey-Type: $KEYTYPE
    Subkey-Length: $KEYLENGTH
    Subkey-Usage: encrypt

    Subkey-Type: $KEYTYPE
    Subkey-Length: $KEYLENGTH
    Subkey-Usage: auth

    %commit
EOF
    sudo -u $NAME gpg --batch --generate-key /tmp/gpg-key-params
    rm -rf /tmp/gpg-key-params
    unset KEYTYPE KEYLENGTH REALNAME COMMENT KEYVALIDITY PASSPHRASE
    }

    if [ -z ${EMAIL+x} ]; then
        EMAIL=$(whiptail --inputbox "Enter email to specify GPG" 8 78 3>&1 1>&2 2>&3) || return
    fi

    # install ssh and pam-gnupg
    PKG=(
        openssh
        pam-gnupg
    )
    pkginstall $NAME ${PKG[@]} || error "Could not install SSH packages."

    # set gpg agent conf
    dotfiles || error "Could not fetch the dotfiles."
    [ -d "$REPODIR/dotfiles" ] && cd $REPODIR/dotfiles && sudo -u $NAME stow gpg -t /home/$NAME

    # set auth subkey for ssh
    gpg -K --with-keygrip $EMAIL | awk '
    /^\s*ssb.*\[A\]/ { in_ssb_e = 1; next }
    in_ssb_e && /Keygrip/ { print $3; exit }
    ' > /home/$NAME/.gnupg/sshcontrol

    # activate auth and encrypt key at login
    gpg -K --with-keygrip $EMAIL | awk '
    /^\s*ssb.*\[E\]/ { in_ssb_e = 1; next }
    in_ssb_e && /Keygrip/ { print $3; exit }
    ' > /home/$NAME//.pam-gnupg
    gpg -K --with-keygrip $EMAIL | awk '
    /^\s*ssb.*\[A\]/ { in_ssb_e = 1; next }
    in_ssb_e && /Keygrip/ { print $3; exit }
    ' > /home/$NAME//.pam-gnupg

    # pam login service
    cat <<EOT >> /etc/pam.d/system-local-login
    auth     optional  pam_gnupg.so store-only
    session  optional  pam_gnupg.so
EOT
}
#====================================================================================================
email-setup() {
    whiptail --title "Email Client" --yesno "Install Email Client?" 8 78 || return
    username || { echo "Could not get username"; return; }
    gpg-keygen || { echo "Could not generate GPG key pair"; return; }
    PKGS=(neomutt isync msmtp pass pass-otp ca-certificates gettext lynx notmuch abook urlview cronie mutt-wizard-git)
    pkg-install $NAME ${PKGS[@]} || error "Could not install EMAIL packages."
    EMAILID=$(whiptail --title "Email Client" --inputbox "Insert email" 8 78 3>&1 1>&2 2>&3) || return
    IMAPSERVER=$(whiptail --title "Email Client" --inputbox "Insert IMAP server" 8 78 3>&1 1>&2 2>&3) || return
    SMTPSERVER=$(whiptail --title "Email Client" --inputbox "Insert SMTP server" 8 78 $IMAPSERVER 3>&1 1>&2 2>&3) || return
    EMAILPASS=$(whiptail --title "Email Client" --passwordbox "Enter password" 8 78 3>&1 1>&2 2>&3) || return
    GPGPUBLIC=$(whiptail --title "Email Client" --inputbox "Insert GPG public" 8 78 3>&1 1>&2 2>&3) || return
    GPGPASS=$(whiptail --title "Email Client" --passwordbox "Enter GPG passphrase" 8 78 3>&1 1>&2 2>&3) || return
    sudo -u $NAME pass init $GPGPUBLIC
    sudo -u $NAME mw -a $EMAILID <<EOF
$IMAPSERVER
$SMTPSERVER
$EMAILPASS
$EMAILPASS
$GPGPASS
EOF
    unset EMAILID IMAPSERVER SMTPSERVER GPGPUBLIC EMAILPASS GPGPASS
}
#====================================================================================================
amdcpu-setup() {
    PGKS=(amd-ucode)
}

nvidiagpu-setup() {
    PGKS=(nvidia)
}

if [ "${1}" != "--source" ]; then
    DISTRO=$(awk '/DISTRIB_ID=/' /etc/*-release | sed 's/DISTRIB_ID=//' | tr '[:upper:]' '[:lower:]')
    INITSYS=
    AURHELPER=
    whiptail --title "Install Config" --yesno "Install configuration?" 8 78 || { echo "User exit"; exit; }
    sed -i 's/'#Color'/'Color'/g' /etc/pacman.conf
    pacman --noconfirm --needed -Sy libnewt
    pacman --noconfirm -Sy archlinux-keyring >/dev/null 2>&1
    PKGS=(
        stow
        unzip
        git
    )
    pkg-install root ${PKGS[@]} || "Error: could not install BASIC packages."

    CHOICES=$(whiptail --title "Install Config" --checklist \
        "Choose modules to install/setup" 20 78 12 \
        "Add User" "Create new user" OFF \
        "AUR_helper" "Install AUR helper" OFF \
        "Keyboard" "Set us keyboard and swap ctrl with caps lock" OFF \
        "Audio" "Install & setup audio system" OFF \
        "Bluetooth" "Instal & setup bluetooth" OFF \
        "Desktop" "Install and configure dwm environment" OFF \
        "Terminal" "Install and configure st terminal" OFF \
        "Shell" "Install and activate ZSH plus other usefull tools" OFF \
        "GPG" "Generate GPG key pair and setup ssh/pam" OFF \
        "Email" "Install & setup neomutt client" OFF \
        "Browser" "Install firefox, apply arkenfox and install puglins" OFF \
        "Tools" "Install various tools" OFF 3>&1 1>&2 2>&3) || { echo "User exit"; exit; }

    for CHOICE in $CHOICES; do
        CHOICE="${CHOICE%\"}"
        CHOICE="${CHOICE#\"}"
        case $CHOICE in
            "Add User")
                user-add
                ;;
            "AUR helper")
                aurhelper-install
                ;;
            "Keyboard")
                keyboard-setup
                ;;
            "Audio")
                audio-setup
                ;;
            "Bluetooth")
                bluetooth-setup
                ;;
            "Desktop")
                desktop-setup
                ;;
            "Terminal")
                terminal-setup
                ;;
            "Shell")
                shell-setup
                ;;
            "GPG")
                gpg-setup
                ;;
            "Email")
                email-setup
                ;;
            "Browser")
                browser-setup
                ;;
            "Tools")
                MEDIA=(nsxiv mpd mpc mpv)
                tools-install "Media" ${MEDIA[@]}
                IOT=(transmission-cli stig wireguard-tools yt-dlp rsync syncthing cifs-utils) # rtorrent youtube-dl
                # insert this line in ~/.config/mimeapps.list under [Default Application] if transmission-cli is requested
                # x-scheme-handler/magnet=torrent.desktop;
                # application/x-bittorrent=torrent.desktop;
                tools-install "IoT" ${IOT[@]}
                READER=(libreoffice-fresh zathura zathura-pdf-mupdf)
                tools-install "Reader" ${READER[@]}
                ORGANIZER=(logseq-desktop-bin zotero calcurse mochi-appimage)
                # envsubst < zotero/user.js > path/to/zotero/profile/user.js
                tools-install "Organizer" ${ORGANIZER[@]}
                SOCIAL=(telegram-desktop zoom slack-bin)
                tools-install "Social" ${SOCIAL[@]}
                GRAPHICS=(blender gimp inkscape ifcopenshell shapely lark freecad)
                tools-install "Graphics" ${GRAPHICS[@]}
                DEV=(cmake eigen clang uv cuda)
                tools-install "Dev" ${DEV[@]}
                GAMING=(steam)
                tools-install "Gaming" ${GAMING[@]}
                ;;
        esac
    done
fi
