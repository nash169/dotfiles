#!/bin/bash

source utils.sh arch.sh

echo "################################################################"
echo "Installation of battery software"
echo "################################################################"

install_category ../packages.csv battery

tput setaf 5;echo "################################################################"
echo "Enabling battery services"
echo "################################################################"
echo;tput sgr0

sudo systemctl enable tlp.service