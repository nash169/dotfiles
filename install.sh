#!/bin/sh

AURHELPER=(
    yay
    paru
)

DESKTOP=(
    xorg-server
    xorg-xwininfo
    xorg-xinit
    xorg-xprop
    xorg-xdpyinfo
    xorg-xbacklight
    xorg-xrandr
    xorg-xrdb
    xorg-xbacklight
    xcompmgr
    feh
    slock
    dmenu
    maim
    xautolock
)

IOT=(
    wireguard-tools
)


AUDIO=(
    pipewire 
    wireplumber 
    pipewire-pulse
)

TOOLS=(
    htop
    xclip
    qrencode
    lazygit
)

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

#=============================================
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
}

pkg-install() {
    username=$1
    shift
    for item in "$@"; do
	if ! pkgcheck $item; then
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

ssh-generate() {
    whiptail --title "SSH Key" --yesno "Generate SSH key?" 8 78 || return
    username || error "Could not get username."
    PKG=(
        openssh
    )
    pkginstall $NAME ${PKG[@]} || error "Could not install SSH packages."
    if [ ! -d "/home/$NAME/.ssh" ]; then
        sudo -u $NAME mkdir -p "/home/$NAME/.ssh"
    fi
    EMAIL=$(whiptail --title "SSH Keygen" --inputbox "Enter email" 8 78 3>&1 1>&2 2>&3) || return
    KEYNAME=$(whiptail --title "SSH Keygen" --inputbox "Enter key's name" 8 78 "id_ed25519" 3>&1 1>&2 2>&3) || return
    PASSPHRASE=$(whiptail --title "SSH Keygen" --passwordbox "Enter passphrase (empty for no passphrase)" 8 78 3>&1 1>&2 2>&3) || return
    ssh-keygen -t ed25519 -f /home/$NAME/.ssh/$KEYNAME -q -N "$PASSPHRASE" -C $EMAIL
    unset EMAIL KEYNAME PASSPHRASE
}

gpg-generate() {
    whiptail --title "GPG Key" --yesno "Generate GPG key?" 8 78 || return
    username || error "Could not get username."
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
    Subkey-Type: $KEYTYPE
    Subkey-Length: $KEYLENGTH
    Name-Real: $REALNAME
    Name-Comment: $COMMENT
    Name-Email: $EMAIL
    Expire-Date: $KEYVALIDITY
    Passphrase: $PASSPHRASE
EOF
    sudo -u $NAME gpg --batch --generate-key /tmp/gpg-key-params
    rm -rf /tmp/gpg-key-params
    unset KEYTYPE KEYLENGTH REALNAME COMMENT EMAIL KEYVALIDITY PASSPHRASE
}
#=============================================

desktop() {
    whiptail --title "Desktop" --yesno "Install Desktop?" 8 78 || return
    dotfiles || error "Could not fetch the dotfiles."

    desktop=(xorg-server xorg-xwininfo xorg-xinit xorg-xprop xorg-xdpyinfo xorg-xbacklight xorg-xrandr xorg-xrdb xorg-xbacklight xcompmgr feh slock dmenu maim xautolock)
    # xcompmgr	-> terminal transparency
    # feh	-> set desktop background
    # slock	-> lock screen
    # maim	-> take screenshot
    pkginstall $NAME ${desktop[@]} || error "Could not install XORG packages."

    [ ! -f "/home/$NAME/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf" ] && fonts

    sudo -u $NAME git clone https://github.com/nash169/dwm.git $REPODIR/dwm 
    sudo -u $NAME git -C $REPODIR/dwm remote add upstream git://git.suckless.org/dwm
    # sudo -u $NAME git -C $REPODIR/dwm fetch upstream
    # sudo -u $NAME git -C $REPODIR/dwm merge upstream/master
    # sudo -u $NAME git -C $REPODIR/dwm rebase upstream/master

    if [ -d "$REPODIR/dotfiles" ]; then
        cd $REPODIR/dotfiles && sudo -u $NAME stow walls -t /home/$NAME 
        cd $REPODIR/dotfiles && sudo -u $NAME stow xserver -t /home/$NAME 
        cd $REPODIR/dotfiles && sudo -u $NAME stow dwm -t $REPODIR/dwm 
    fi

    cd $REPODIR/dwm && make install

    sudo -u $NAME git clone https://github.com/nash169/dwmstatus.git $REPODIR/dwmstatus 
    sudo -u $NAME git -C $REPODIR/dwmstatus remote add upstream git://git.suckless.org/dwmstatus 
    # sudo -u $NAME git -C $REPODIR/dwmstatus fetch upstream
    # sudo -u $NAME git -C $REPODIR/dwmstatus rebase upstream/master
    cd "$REPODIR/dwmstatus" && make install

cat >/etc/systemd/system/slock@.service <<EOF
    [Unit]
    Description=Lock X session using slock for user %i
    Before=sleep.target

    [Service]
    User=%i
    Environment=DISPLAY=:0
    ExecStartPre=/usr/bin/xset dpms force suspend
    ExecStart=/usr/bin/slock

    [Install]
    WantedBy=sleep.target
EOF

    systemctl enable "slock@$NAME.service"


#!/bin/sh
# /lib/elogind/system-sleep/lock.sh
# Lock before suspend integration with elogind

username=cooluser
userhome=/home/$username
export XAUTHORITY="$userhome/.Xauthority"
export DISPLAY=":0.0"
case "${1}" in
    pre)
        su $username -c "/usr/bin/slock" &
        sleep 1s;
        ;;
esac
}

terminal() {
    whiptail --title "Terminal" --yesno "Install Terminal?" 8 78 || return
    dotfiles || error "Could not fetch the dotfiles."
    [ ! -f "/home/$NAME/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf" ] && fonts
    [ -d "$REPODIR/dotfiles" ] && cd $REPODIR/dotfiles && sudo -u stow st -t $REPODIR/st 
    sudo -u $NAME git clone https://github.com/nash169/st.git $REPODIR/st 
    sudo -u $NAME git -C $REPODIR/st remote add upstream git://git.suckless.org/st 
    # sudo -u $NAME git -C $REPODIR/st fetch upstream
    # sudo -u $NAME git -C $REPODIR/st merge upstream/master
    sudo -u $NAME git -C $REPODIR/st checkout custom
    # sudo -u $NAME git -C $REPODIR/st rebase upstream/master
    cd $REPODIR/st && make install
}

shell() {
    whiptail --title "Shell" --yesno "Install Shell?" 8 78 || return
    dotfiles || error "Could not fetch the dotfiles."
    PKGS=(tmux exa bat zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting)
    pkginstall $NAME ${PKGS[@]} || error "Could not install SHELL packages."
    chsh -s /bin/zsh "$NAME" >/dev/null 2>&1
    if [ -d "$REPODIR/dotfiles" ]; then
        cd $REPODIR/dotfiles && sudo -u $NAME stow zsh -t /home/$NAME
    fi
    mkdir -p "/home/$NAME/.cache/zsh" && touch "$HISTFILE"
}

explorer() {
    whiptail --title "Explorer" --yesno "Install Explorer?" 8 78 || return
    dotfiles || error "Could not fetch the dotfiles."
    explorer=(ripgrep fzf lf-git ueberzug)
    pkginstall $NAME ${explorer[@]} || error "Could not install EXPLORER packages."
    if [ -d "$REPODIR/dotfiles" ]; then
        cd $REPODIR/dotfiles && sudo -u $NAME stow lf -t /home/$NAME
    fi
}

editor() {
    whiptail --title "Editor" --yesno "Install Editor?" 8 78 || return
    dotfiles || error "Could not fetch the dotfiles."
    PKGS=(neovim python-pynvim) 
    # texlive-bin texlive-fontsrecomended texlive-latexextra texlive-latexrecomended texlive-latex texlive-basic texlive-xetex texlive-mathscience texlive-fontsextra texlive-langenglish texlive-context texlive-luatex texlive-plaingeneric texlive-binextra texlive-bibtexextra texlive-pictures texlive-langfrench texlive-langgerman texlive-fontutils) # ninja tree-sitter lua luarocks
    pkginstall $NAME ${PKGS[@]} || error "Could not install EDITOR packages."
    if [ ! -d "$REPODIR/dotfiles" ]; then
        cd $REPODIR/dotfiles && sudo -u $NAME stow nvim -t /home/$NAME
        cd $REPODIR/dotfiles && sudo -u $NAME stow format -t /home/$NAME
    fi
}

browser() {
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
    ADDONS=$(whiptail --title "Firefox extensions" --separate-output --checklist "Choose extensions" 25 52 16 \
        "ublock-origin" "" OFF \
        "cookies.txt" "" OFF \
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
    # Settings -> Privacy and Security -> Cookies and Site Data -> Manage Exceptions
}

email() {
    whiptail --title "Email Client" --yesno "Install Email Client?" 8 78 || return
    username || { echo "Could not get username"; return; }
    gpgkeygen || { echo "Could not generate GPG key pair"; return; }
    PKGS=(neomutt isync msmtp pass ca-certificates gettext pam-gnupg lynx notmuch abook urlview cronie mutt-wizard-git)
    pkginstall $NAME ${PKGS[@]} || error "Could not install EMAIL packages."
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

keyboard() {
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "us"
        Option "XkbModel" "default"
        Option "XkbOptions" "ctrl:swapcaps,compose:ralt"
EndSectionSection "InputClass"
}

bluetooth() {
    whiptail --title "Install the bluetooth tools?" --yesno "Bluetooth" 8 78 || return
    username || error "Could not get username."

    bluetooth=(bluez bluez-utils) 
    pkg-install $NAME ${bluetooth[@]} || error "Could not install BLUETOOTH packages."
    [ $INITSYS == "runint" ] && pkg-install $NAME bluez-ruinit && sudo ln -s /etc/runit/sv/bluetoothd /run/runit/service/ && sudo sv up bluetoothd
    [ $INITSYS == "systemd" ] && systemctl enable bluetooth.service && systemctl start bluetooth.service
    sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf
}

audio() {
    whiptail --title "Install audio tools?" --yesno "Audio" 8 78 || return
    username || error "Could not get username."
    pkginstall $NAME ${AUDIO[@]} || error "Could not install AUDIO packages."
    [ $INITSYS == "systemd" ] && systemctl start pipewire-pulse.socket
}

tools() {
    whiptail --title "Install basic tools?" --yesno "Media" 8 78 || return
    username || error "Could not get username."

    TOOLS=(xclip fd qrencode yt-dlp)
    pkginstall "$NAME" "${TOOLS[@]}" || error "Could not install TOOLS packages."
}

mediatools() {
    whiptail --title "Install media tools?" --yesno "Media" 8 78 || return
    username || error "Could not get username."

    mediatools=(nsxiv mpd mpc mpv zathura zathura-pdf-mupdf zotero)
    pkginstall $NAME ${mediatools[@]} || error "Could not install MEDIA TOOLS packages."
}

downtools() {
    whiptail --title "Install Download Tools?" --yesno "Download" 8 78 || return
    username || error "Could not get username."

    download=(transmission-cli youtube-dl) # rtorrent
    pkginstall $NAME ${download[@]} || error "Could not install DOWNLOAD TOOLS packages."
}

devtools() {
    whiptail --title "Install Dev Tools?" --yesno "Download" 8 78 || return
    username || error "Could not get username."

    devtools=(cmake eigen clang)
    pkginstall $NAME ${devtools[@]} || error "Could not install DEVELOPMENT TOOLS packages."
}

if [ "${1}" != "--source" ]; then
    # DISTRO=$(awk '/DISTRIB_ID=/' /etc/*-release | sed 's/DISTRIB_ID=//' | tr '[:upper:]' '[:lower:]')
    # INITSYS=
    whiptail --title "Install Config" --yesno "Install configuration?" 8 78 || return
    sed -i 's/'#Color'/'Color'/g' /etc/pacman.conf
    pacman --noconfirm --needed -Sy libnewt
    pacman --noconfirm -Sy archlinux-keyring >/dev/null 2>&1
    PKGS=(
        stow
        unzip
        git
    )
    pkginstall root ${PKGS[@]} || "Error: could not install BASIC packages."
    
    [ -d "/home/$NAME/.local/bin" ] || sudo -u "$NAME" mkdir -p "/home/$NAME/.local/bin"
    #
    # adduser || error "User exit"
    # aurhelper || error "User exit"
    # desktop || error "User exit"
    # terminal || error "User exit"
    # shell|| error "User exit"
    # explorer || error "User exit"
    # editor || error "User exit"
    # email || error "User exit"
    browser || error "User exit"
    # mediatools || error "User exit"
    # downtools || error "User exit"
    # devtools || error "User exit"
fi


# pkgcheck() {
#     if pacman -Qi $1 &> /dev/null; then
#         tput setaf 2
#         echo "The package "$1" is already installed"
#         tput sgr0
#         true
#     else
#         tput setaf 1
#         echo "Package "$1" has NOT been installed"
#         tput sgr0
#         false
#     fi
# }
