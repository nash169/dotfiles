#!/bin/bash
source scripts/distros/$1.sh

bluetooth=(pulseaudio-bluetooth bluez bluez-libs bluez-utils blueberry)
pkginstall $2 ${bluetooth[@]} || "Error: could not install BLUETOOTH packages."
systemctl enable bluetooth.service
systemctl start bluetooth.service
sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf