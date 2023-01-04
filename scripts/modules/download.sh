#!/bin/bash
source ../distros/$1.sh

download=(rtorrent-ps youtube-dl)
pkginstall $2 ${download[@]} || "Error: could not install DOWNLOAD packages."