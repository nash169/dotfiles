#!/bin/bash
source scripts/distros/$1.sh

develop=(cmake texlive-core eigen waf clang)
pkginstall $2 ${develop[@]} || "Error: could not install DEVELOP packages."
cd /home/$2/developments/linux-config/configs && sudo -u $2 stow format -t /home/$2/