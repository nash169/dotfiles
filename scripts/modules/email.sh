#!/bin/bash
source ../distros/$1.sh

email=(mutt-wizard-git)
pkginstall $2 ${email[@]} || "Error: could not install EMAIL packages."