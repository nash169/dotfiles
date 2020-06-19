#!/bin/bash

source ../utils.sh

###############################################################################
echo "Installation of samba software"
###############################################################################

list=(
samba
gvfs-smb
)

count=0

for name in "${list[@]}" ; do
	count=$[count+1]
	tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
	func_install $name
done

###############################################################################

tput setaf 5;echo "################################################################"
echo "Getting the ArcoLinux Samba config"
echo "################################################################"
echo;tput sgr0

sudo cp /etc/samba/smb.conf.arcolinux /etc/samba/smb.conf

tput setaf 5;echo "################################################################"
echo "Give your username for samba"
echo "################################################################"
echo;tput sgr0

read -p "What is your login? It will be used to add this user to smb : " choice
sudo smbpasswd -a $choice

tput setaf 5;echo "################################################################"
echo "Enabling services"
echo "################################################################"
echo;tput sgr0

sudo systemctl enable smb.service
sudo systemctl enable nmb.service

tput setaf 11;
echo "################################################################"
echo "Software has been installed"
echo "################################################################"
echo;tput sgr0
