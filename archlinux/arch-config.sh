#!/bin/bash

set -e

# USE ALL CORES & UPDATE
#==============================================================
numberofcores=$(grep -c ^processor /proc/cpuinfo)

if [ $numberofcores -gt 1 ]
then
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j'$(($numberofcores+1))'"/g' /etc/makepkg.conf;
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T '"$numberofcores"' -z -)/g' /etc/makepkg.conf
else
        echo "No change."
fi

sudo pacman -Syyu --noconfirm


# DESKTOP (TILING WINDOW) MANAGER
#==============================================================
sudo pacman -S bspwm sxhkd --noconfirm --needed


# LOGIN MANAGER
#==============================================================
# sudo pacman -S --noconfirm --needed lightdm
# sudo pacman -S --noconfirm --needed arcolinux-lightdm-gtk-greeter arcolinux-lightdm-gtk-greeter-settings
# sudo pacman -S --noconfirm --needed arcolinux-wallpapers-git

# sudo systemctl enable lightdm.service -f
# sudo systemctl set-default graphical.target


# SOUND
#==============================================================
sudo pacman -S pulseaudio --noconfirm --needed
sudo pacman -S pulseaudio-alsa --noconfirm --needed
sudo pacman -S pavucontrol  --noconfirm --needed
sudo pacman -S alsa-utils alsa-plugins alsa-lib alsa-firmware --noconfirm --needed
sudo pacman -S gstreamer --noconfirm --needed
sudo pacman -S gst-plugins-good gst-plugins-bad gst-plugins-base gst-plugins-ugly --noconfirm --needed
sudo pacman -S volumeicon --noconfirm --needed
sudo pacman -S playerctl --noconfirm --needed


# BLUETOOTH
#==============================================================
sudo pacman -S --noconfirm --needed pulseaudio-bluetooth
sudo pacman -S --noconfirm --needed bluez
sudo pacman -S --noconfirm --needed bluez-libs
sudo pacman -S --noconfirm --needed bluez-utils
sudo pacman -S --noconfirm --needed blueberry

sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service

sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf

# reboot your system then ...
# bluetooth icon in bottom right corner
# change to have a2dp if needed
# read -n 1 -s -r -p "Press any key to continue"

# Fix bluetooth switch not working
# Adding the current user to the group rfkill in order to be able to switch blueberry on and off
# https://github.com/linuxmint/blueberry/issues/75
sudo usermod  -a -G rfkill $USER


# PRINTER
#==============================================================
sudo pacman -S --noconfirm --needed cups cups-pdf

#first try if you can print without foomatic
#sudo pacman -S foomatic-db-engine --noconfirm --needed
#sudo pacman -S foomatic-db foomatic-db-ppds foomatic-db-nonfree-ppds foomatic-db-gutenprint-ppds --noconfirm --needed
sudo pacman -S ghostscript gsfonts gutenprint --noconfirm --needed
sudo pacman -S gtk3-print-backends --noconfirm --needed
sudo pacman -S libcups --noconfirm --needed
sudo pacman -S hplip --noconfirm --needed
sudo pacman -S system-config-printer --noconfirm --needed

sudo systemctl enable org.cups.cupsd.service


# NETWORK DISCOVERY
#==============================================================
sudo pacman -S --noconfirm --needed avahi
sudo systemctl enable avahi-daemon.service
sudo systemctl start avahi-daemon.service

#shares on a mac
sudo pacman -S --noconfirm --needed nss-mdns

#shares on a linux
sudo pacman -S --noconfirm --needed gvfs-smb

#change nsswitch.conf for access to nas servers
#original line comes from the package filesystem
#hosts: files mymachines myhostname resolve [!UNAVAIL=return] dns
#ArcoLinux line
#hosts: files mymachines resolve [!UNAVAIL=return] mdns dns wins myhostname

#first part
sudo sed -i 's/files mymachines myhostname/files mymachines/g' /etc/nsswitch.conf
#last part
sudo sed -i 's/\[\!UNAVAIL=return\] dns/\[\!UNAVAIL=return\] mdns dns wins myhostname/g' /etc/nsswitch.conf


# TLP FOR BATTERY LIFE
#==============================================================
sh tlp_battery.sh


# SOFTWARE
#==============================================================
# Accessories
sudo pacman -S --noconfirm --needed catfish
sudo pacman -S --noconfirm --needed cronie
sudo pacman -S --noconfirm --needed galculator
sudo pacman -S --noconfirm --needed gnome-screenshot
#sudo pacman -S --noconfirm --needed plank
#sudo pacman -S --noconfirm --needed xfburn
sudo pacman -S --noconfirm --needed variety
#sudo pacman -S --noconfirm --needed
sudo pacman -S --noconfirm --needed unace unrar zip unzip sharutils  uudeview  arj cabextract file-roller
sudo pacman -S --noconfirm --needed discord
sudo pacman -S --noconfirm --needed telegram-desktop

sh install-aur.sh conky-lua-archers
sh install-aur.sh python2-pyparted
sh install-aur.sh mintstick-git

# Development
sudo pacman -S --noconfirm --needed atom
sudo pacman -S --noconfirm --needed geany
sudo pacman -S --noconfirm --needed meld
#sudo pacman -S --noconfirm --needed

sh install-aur.sh sublime-text-dev

# Education
#sudo pacman -S --noconfirm --needed

# Games
#sudo pacman -S --noconfirm --needed

# Graphics
#sudo pacman -S --noconfirm --needed darktable
sudo pacman -S --noconfirm --needed gimp
#sudo pacman -S --noconfirm --needed gnome-font-viewer
#sudo pacman -S --noconfirm --needed gpick
sudo pacman -S --noconfirm --needed inkscape
sudo pacman -S --noconfirm --needed nomacs
#sudo pacman -S --noconfirm --needed pinta
sudo pacman -S --noconfirm --needed ristretto
#sudo pacman -S --noconfirm --needed

# Internet
sudo pacman -S --noconfirm --needed chromium
#sudo pacman -S --noconfirm --needed filezilla
sudo pacman -S --noconfirm --needed firefox
#sudo pacman -S --noconfirm --needed hexchat
sudo pacman -S --noconfirm --needed qbittorrent
#sudo pacman -S --noconfirm --needed

# Multimedia
#sudo pacman -S --noconfirm --needed clementine
#sudo pacman -S --noconfirm --needed deadbeef
sudo pacman -S --noconfirm --needed mpv
#sudo pacman -S --noconfirm --needed openshot
sudo pacman -S --noconfirm --needed pragha
#sudo pacman -S --noconfirm --needed shotwell
sudo pacman -S --noconfirm --needed simplescreenrecorder
#sudo pacman -S --noconfirm --needed smplayer
sudo pacman -S --noconfirm --needed vlc
#sudo pacman -S --noconfirm --needed

sh install-aur.sh gradio
sh install-aur.sh peek
sh install-aur.sh radiotray

# Office
sudo pacman -S --noconfirm --needed evince
sudo pacman -S --noconfirm --needed evolution
#sudo pacman -S --noconfirm --needed geary
#sudo pacman -S --noconfirm --needed libreoffice-fresh
#sudo pacman -S --noconfirm --needed

# Other
#sudo pacman -S --noconfirm --needed

# System
sudo pacman -S --noconfirm --needed arc-gtk-theme
sudo pacman -S --noconfirm --needed accountsservice
#sudo pacman -S --noconfirm --needed archey3
sudo pacman -S --noconfirm --needed baobab
#sudo pacman -S --noconfirm --needed bleachbit
sudo pacman -S --noconfirm --needed curl
sudo pacman -S --noconfirm --needed dconf-editor
sudo pacman -S --noconfirm --needed dmidecode
sudo pacman -S --noconfirm --needed ffmpegthumbnailer
sudo pacman -S --noconfirm --needed git
sudo pacman -S --noconfirm --needed glances
sudo pacman -S --noconfirm --needed gnome-disk-utility
sudo pacman -S --noconfirm --needed gnome-keyring
#sudo pacman -S --noconfirm --needed gnome-system-monitor
#sudo pacman -S --noconfirm --needed gnome-terminal
#sudo pacman -S --noconfirm --needed gnome-tweak-tool
sudo pacman -S --noconfirm --needed gparted
sudo pacman -S --noconfirm --needed grsync
sudo pacman -S --noconfirm --needed gtk-engine-murrine
sudo pacman -S --noconfirm --needed gvfs gvfs-mtp
sudo pacman -S --noconfirm --needed hardinfo
sudo pacman -S --noconfirm --needed hddtemp
sudo pacman -S --noconfirm --needed htop
sudo pacman -S --noconfirm --needed kvantum-qt5
sudo pacman -S --noconfirm --needed kvantum-theme-arc
sudo pacman -S --noconfirm --needed lm_sensors
sudo pacman -S --noconfirm --needed lsb-release
sudo pacman -S --noconfirm --needed mlocate
sudo pacman -S --noconfirm --needed net-tools
#sudo pacman -S --noconfirm --needed notify-osd
sudo pacman -S --noconfirm --needed noto-fonts
sudo pacman -S --noconfirm --needed numlockx
sudo pacman -S --noconfirm --needed polkit-gnome
sudo pacman -S --noconfirm --needed qt5ct
sudo pacman -S --noconfirm --needed sane
sudo pacman -S --noconfirm --needed screenfetch
sudo pacman -S --noconfirm --needed scrot
sudo pacman -S --noconfirm --needed simple-scan
sudo pacman -S --noconfirm --needed sysstat
#sudo pacman -S --noconfirm --needed terminator
sudo pacman -S --noconfirm --needed termite
sudo pacman -S --noconfirm --needed thunar
sudo pacman -S --noconfirm --needed thunar-archive-plugin
sudo pacman -S --noconfirm --needed thunar-volman
sudo pacman -S --noconfirm --needed ttf-ubuntu-font-family
sudo pacman -S --noconfirm --needed ttf-droid
sudo pacman -S --noconfirm --needed tumbler
sudo pacman -S --noconfirm --needed vnstat
sudo pacman -S --noconfirm --needed wget
sudo pacman -S --noconfirm --needed wmctrl
sudo pacman -S --noconfirm --needed unclutter
sudo pacman -S --noconfirm --needed rxvt-unicode
sudo pacman -S --noconfirm --needed urxvt-perls
sudo pacman -S --noconfirm --needed xdg-user-dirs
sudo pacman -S --noconfirm --needed xdo
sudo pacman -S --noconfirm --needed xdotool
sudo pacman -S --noconfirm --needed zenity
#sudo pacman -S --noconfirm --needed

sudo pacman -S --needed --noconfirm virtualbox-host-modules-arch
sudo pacman -S --noconfirm --needed virtualbox
#sudo grub-mkconfig -o /boot/grub/grub.cfg
# Removing all the messages virtualbox produce. You got to reboot.
VBoxManage setextradata global GUI/SuppressMessages "all"

# Aur packages
sh install-aur.sh downgrade
sh install-aur.sh font-manager-git
sh install-aur.sh inxi
sh install-aur.sh neofetch
sh install-aur.sh numix-circle-icon-theme-git
sh install-aur.sh oxy-neon
sh install-aur.sh pamac-aur
# sh install-aur.sh paper-icon-theme-git
# sh install-aur.sh papirus-icon-theme-git
sh install-aur.sh sardi-icons
sh arcolinux/install-sardi-extra-icons-v*.sh
sh install-aur.sh screenkey-git
sh install-aur.sh surfn-icons-git
sh install-aur.sh the_platinum_searcher-bin
sh install-aur.sh ttf-font-awesome
sh install-aur.sh ttf-mac-fonts
# sh install-aur.sh xcursor-breeze

# these come always last
sh install-aur.sh hardcode-fixer-git
sudo hardcode-fixer

#giving tmp folder extra gb in order not to run out of disk space while installing software
#only if you run into issues with that
#sudo mount -o remount,size=5G,noatime /tmp

if [ "$1" == "bspwm" ]; then
    # Accessories
    sudo pacman -S xfce4-terminal --noconfirm --needed

    # System
    sudo pacman -S arandr --noconfirm --needed
    sudo pacman -S awesome-terminal-fonts --noconfirm --needed
    sudo pacman -S picom  --noconfirm --needed
    sudo pacman -S dmenu  --noconfirm --needed
    sudo pacman -S feh --noconfirm --needed
    sudo pacman -S gmrun --noconfirm --needed
    sudo pacman -S gtop --noconfirm --needed
    sudo pacman -S imagemagick --noconfirm --needed
    # sudo pacman -S lxappearance-gtk3 --noconfirm --needed
    sudo pacman -S lxrandr --noconfirm --needed
    sudo pacman -S nitrogen --noconfirm --needed
    sudo pacman -S playerctl --noconfirm --needed
    sudo pacman -S rofi --noconfirm --needed
    sudo pacman -S thunar --noconfirm --needed
    sudo pacman -S w3m  --noconfirm --needed
    sudo pacman -S xfce4-appfinder --noconfirm --needed
    sudo pacman -S xfce4-power-manager --noconfirm --needed
    sudo pacman -S xfce4-screenshooter --noconfirm --needed
    sudo pacman -S xfce4-settings --noconfirm --needed
    sudo pacman -S xfce4-taskmanager --noconfirm --needed
    sudo pacman -S xfce4-notifyd --noconfirm --needed

    # AUR
    sh install-aur.sh gtk2-perl
    sh install-aur.sh perl-linux-desktopfiles
    sh install-aur.sh sutils-git
    sh install-aur.sh xtitle
    sh install-aur.sh python-pywal
    sh install-aur.sh polybar
    sh install-aur.sh urxvt-resize-font-git
fi

# ARCOLINUX
#==============================================================
sudo pacman -S arcolinux-arc-themes-nico-git --noconfirm --needed
sudo pacman -S arcolinux-bin-git --noconfirm --needed
#sudo pacman -S arcolinux-common-git --noconfirm --needed
sudo pacman -S arcolinux-conky-collection-git --noconfirm --needed
#sudo pacman -S arcolinux-conky-collection-plasma-git --noconfirm --needed
sudo pacman -S arcolinux-cron-git --noconfirm --needed
#sudo pacman -S arcolinux-docs-git --noconfirm --needed
#sudo pacman -S arcolinux-faces-git --noconfirm --needed
sudo pacman -S arcolinux-fonts-git --noconfirm --needed
sudo pacman -S arcolinux-geany-git --noconfirm --needed
sudo pacman -S arcolinux-hblock-git --noconfirm --needed
sudo pacman -S arcolinux-kvantum-git --noconfirm --needed
#sudo pacman -S arcolinux-kvantum-lxqt-git --noconfirm --needed
#sudo pacman -S arcolinux-kvantum-plasma-git --noconfirm --needed
sudo pacman -S arcolinux-lightdm-gtk-greeter --noconfirm --needed
#sudo pacman -S arcolinux-lightdm-gtk-greeter-plasma --noconfirm --needed
sudo pacman -S arcolinux-lightdm-gtk-greeter-settings --noconfirm --needed
sudo pacman -S arcolinux-local-applications-git --noconfirm --needed
#sudo pacman -S arcolinux-local-xfce4-git --noconfirm --needed
#sudo pacman -S arcolinux-logo-git --noconfirm --needed
#sudo pacman -S arcolinux-lxqt-applications-add-git --noconfirm --needed
#sudo pacman -S arcolinux-lxqt-applications-hide-git --noconfirm --needed
sudo pacman -S arcolinux-mirrorlist-git --noconfirm --needed
sudo pacman -S arcolinux-neofetch-git --noconfirm --needed
sudo pacman -S arcolinux-nitrogen-git --noconfirm --needed
sudo pacman -S arcolinux-oblogout --noconfirm --needed
sudo pacman -S arcolinux-oblogout-themes-git --noconfirm --needed
#sudo pacman -S arcolinux-obmenu-generator-git --noconfirm --needed
#sudo pacman -S arcolinux-obmenu-generator-minimal-git --noconfirm --needed
#sudo pacman -S arcolinux-obmenu-generator-xtended-git --noconfirm --needed
#sudo pacman -S arcolinux-openbox-themes-git --noconfirm --needed
sudo pacman -S arcolinux-pipemenus-git --noconfirm --needed
#sudo pacman -S arcolinux-plank-git --noconfirm --needed
#sudo pacman -S arcolinux-plank-themes-git --noconfirm --needed
sudo pacman -S arcolinux-polybar-git --noconfirm --needed
sudo pacman -S arcolinux-qt5-git --noconfirm --needed
#sudo pacman -S arcolinux-qt5-plasma-git --noconfirm --needed
sudo pacman -S arcolinux-rofi-git --noconfirm --needed
sudo pacman -S arcolinux-rofi-themes-git --noconfirm --needed
sudo pacman -S arcolinux-root-git --noconfirm --needed
sudo pacman -S arcolinux-slim --noconfirm --needed
sudo pacman -S arcolinux-slimlock-themes-git --noconfirm --needed
sudo pacman -S arcolinux-system-config-git --noconfirm --needed
sudo pacman -S arcolinux-termite-themes-git --noconfirm --needed
#sudo pacman -S arcolinux-tint2-git --noconfirm --needed
#sudo pacman -S arcolinux-tint2-themes-git --noconfirm --needed
sudo pacman -S arcolinux-variety-git --noconfirm --needed
sudo pacman -S arcolinux-wallpapers-git --noconfirm --needed
#sudo pacman -S arcolinux-wallpapers-lxqt-dual-git --noconfirm --needed
#sudo pacman -S arcolinux-xfce4-panel-profiles-git --noconfirm --needed
#sudo pacman -S arcolinux-xmobar-git --noconfirm --needed

if [ "$1" == "bspwm" ]; then
    sudo pacman -S arcolinux-bspwm-git --noconfirm --needed
    sudo pacman -S arcolinux-xfce-git --noconfirm --needed
    sudo pacman -S arcolinux-config-bspwm-git --noconfirm --needed
    sudo pacman -S --noconfirm --needed  arcolinux-bspwm-dconf-git
fi

cp -rT /etc/skel ~


# FONTS
#==============================================================
sudo pacman -S adobe-source-sans-pro-fonts --noconfirm --needed
sudo pacman -S cantarell-fonts --noconfirm --needed
sudo pacman -S noto-fonts --noconfirm --needed
sudo pacman -S ttf-bitstream-vera --noconfirm --needed
sudo pacman -S ttf-dejavu --noconfirm --needed
sudo pacman -S ttf-droid --noconfirm --needed
sudo pacman -S ttf-hack --noconfirm --needed
sudo pacman -S ttf-inconsolata --noconfirm --needed
sudo pacman -S ttf-liberation --noconfirm --needed
sudo pacman -S ttf-roboto --noconfirm --needed
sudo pacman -S ttf-ubuntu-font-family --noconfirm --needed
sudo pacman -S tamsyn-font --noconfirm --needed

[ -d $HOME"/.fonts" ] || mkdir -p $HOME"/.fonts"


# Copy fonts to .fonts
cp arcolinux/settings/fonts/* ~/.fonts/

# Building new fonts into the cache files
# Depending on the number of fonts, this may take a while
fc-cache -fv ~/.fonts

# FIXES
#==============================================================

# Run this if you see an error in your bootup screen or dmesg about microcode
# sudo pacman -S intel-ucode --noconfirm
# sudo grub-mkconfig -o /boot/grub/grub.cfg

# Everywhere Breeze-snow as cursor. Change cursor if you want.
# sudo cp -r Personal/settings/default/index.theme /usr/share/icons/default/


# ZSH
#==============================================================
sh install-aur.sh zsh
sh install-aur.sh zsh-completions
sh install-aur.sh zsh-syntax-highlighting

wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh

# changing the theme to random so you can enjoy tons of themes.

sudo sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"random\"/g' ~/.zshrc

# If above line did not work somehow. This is what you should do to enjoy the many themes.
# go find the hidden .zshrc file and look for ZSH_THEME="robbyrussell" (CTRL+H to find hidden files)
# change this to ZSH_THEME="random"

echo '
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
neofetch
' >>  ~/.zshrc

read -p "Adding keychain passphrase save?[y/n] " name
if [ "$name" == "y" ]; then
echo '
# Keychain run for ssh-agent
eval `keychain --eval --nogui -Q -q id_rsa`
' >> ~/.zshrc
fi

# PERSONAL PACKAGES
#==============================================================
# Symlink manager in order to handle the dotfiles
sudo pacman -S stow --no-confirm --needed
# Useful in order to save the passphrase in the ssh-agent
sudo pacman -S keychain --no-confirm --needed
# Mendeley
sh install-aur.sh mendeleydesktop-bundled
# Zotero
sh install-aur.sh zotero
# Replacement ls
sudo pacman -S exa --no-confirm --needed
# Bind keys
sudo pacman -S xbindkeys --no-confirm --needed
# fzf
sudo pacman -S fzf --no-confirm --needed
# zgen
sh install-aur.sh zgen-git
# youtube
sudo pacman -S youtube-dl --no-confirm --needed
# alacritty
sudo pacman -S alacritty --no-confirm --needed
# xautomation
sudo pacman -S xautomation --no-confirm --needed
# Watchman, tmux