#!/bin/bash

source ../utils.sh

###############################################################################
echo "Installation of network software"
###############################################################################

install_category ../packages.csv network

tput setaf 5;echo "################################################################"
echo "Enabling services"
echo "################################################################"
echo;tput sgr0

sudo systemctl enable NetworkManager
