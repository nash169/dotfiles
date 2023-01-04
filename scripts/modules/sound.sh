#!/bin/bash
source scripts/distros/$1.sh

audio=(wireplumber pipewire-pulse pulsemixer)
pkginstall $2 ${audio[@]} || "Error: could not install AUDIO packages."