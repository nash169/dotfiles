#!/bin/bash
source ../distros/$1.sh

browser=(firefox)
pkginstall $2 ${browser[@]} || "Error: could not install BROWSER packages."