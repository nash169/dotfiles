#!/bin/bash

source ../utils.sh

###############################################################################
echo "Installation of the core software"
###############################################################################

list=(
# lightdm
bspwm
sxhkd
dmenu
xdo
feh
# sutils-git
# xtitle-git
polybar
)

count=0

for name in "${list[@]}" ; do
	count=$[count+1]
	tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
	package_install $name
done

###############################################################################

# tput setaf 6;echo "################################################################"
# echo "Copying all files and folders from /etc/skel to ~"
# echo "################################################################"
# echo;tput sgr0
# cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S) && cp -rf /etc/skel/* ~

# tput setaf 5;echo "################################################################"
# echo "Enabling lightdm as display manager"
# echo "################################################################"
# echo;tput sgr0
# sudo systemctl enable lightdm.service -f

tput setaf 11;
echo "################################################################"
echo "Reboot your system"
echo "################################################################"
echo;tput sgr0