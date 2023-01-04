#!/bin/bash
source ../distros/$1.sh

explorer=(ripgrep fzf lf-git ueberzug)
pkginstall $2 ${explorer[@]} || "Error: could not install EXPLORER packages."