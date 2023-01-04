#!/bin/bash
source scripts/distros/$1.sh

browser=(firefox)
pkginstall $2 ${browser[@]} || "Error: could not install BROWSER packages."