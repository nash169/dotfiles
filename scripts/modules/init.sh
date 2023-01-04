#!/bin/bash
source scripts/distros/$1.sh

# Refresh arch keyring
pacman --noconfirm -Sy archlinux-keyring >/dev/null 2>&1
# refreshkeys || "Error: could not refresh keys."

# Install base packages
base=(sudo sed curl stow)
pkginstall root ${base[@]} || "Error: could not install UTILS packages."