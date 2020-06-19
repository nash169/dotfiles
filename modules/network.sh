#!/bin/bash

source ../utils.sh

###############################################################################
echo "Installation of network software"
###############################################################################

list=(
avahi
nss-mdns
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
echo "Change nsswitch.conf for access to nas servers"
echo "################################################################"
echo;tput sgr0

#hosts: files mymachines myhostname resolve [!UNAVAIL=return] dns
#ArcoLinux line
#hosts: files mymachines resolve [!UNAVAIL=return] mdns dns wins myhostname

#first part
sudo sed -i 's/files mymachines myhostname/files mymachines/g' /etc/nsswitch.conf
#last part
sudo sed -i 's/\[\!UNAVAIL=return\] dns/\[\!UNAVAIL=return\] mdns dns wins myhostname/g' /etc/nsswitch.conf

tput setaf 5;echo "################################################################"
echo "Enabling services"
echo "################################################################"
echo;tput sgr0

sudo systemctl enable avahi-daemon.service

tput setaf 11;
echo "################################################################"
echo "Software has been installed"
echo "################################################################"
echo;tput sgr0
