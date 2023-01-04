#!/bin/bash
source ../distros/$1.sh

# Refresh arch keyring
refreshkeys || "Error: could not refresh keys."

# Install base packages
base=(sudo sed curl stow)
pkginstall root ${base[@]} || "Error: could not install UTILS packages."