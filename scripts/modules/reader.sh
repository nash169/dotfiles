#!/bin/bash
source scripts/distros/$1.sh

reader=(zathura zathura-pdf-mupdf zotero)
pkginstall $2 ${reader[@]} || "Error: could not install READER packages."