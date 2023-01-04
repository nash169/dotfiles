#!/bin/bash
source scripts/distros/$1.sh
source scripts/utils.sh

xorg=(xorg-server xorg-xwininfo xorg-xinit xorg-xprop xorg-xdpyinfo xorg-xbacklight xorg-xrandr xorg-xrdb xorg-xbacklight)
pkginstall $2 ${xorg[@]} || "Error: could not install XORG packages."
cd /home/$2/developments/linux-config/configs && sudo -u $2 stow xserver -t /home/$2/

gitmakeinstall https://github.com/nash169/dwm.git || "Error: could not install TWM packages."
desktop=(xcompmgr feh slock dmenu)
pkginstall $2 ${desktop[@]} || "Error: could not install DESKTOP packages."
cd /home/$2/developments/linux-config/configs && sudo -u $2 stow walls -t /home/$2/
sudo -u $2 feh --bg-scale /home/$2/.config/walls/01.png