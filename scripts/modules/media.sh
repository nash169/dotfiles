#!/bin/bash
source ../distros/$1.sh

multimedia=(sxiv mpd mpc mpv)
pkginstall $2 ${multimedia[@]} || "Error: could not install MULTIMEDIA packages."