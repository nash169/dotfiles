#!/bin/bash

source ../utils.sh

echo "################################################################"
echo "Installation of bluetooth software"
echo "################################################################"

install_category ../packages.csv bluetooth

tput setaf 5;echo "################################################################"
echo "Enabling services"
echo "################################################################"
echo;tput sgr0

sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf
