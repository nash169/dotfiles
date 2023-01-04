#!/bin/bash
source scripts/utils.sh

# ADD USER
read -p "Insert user name (and pass): " username
if id "$username" &>/dev/null; then
    echo $username
else
    adduser $username wheel || "Error: could not add user."
    addsudo $username || "Error: could not add user to sudoers."
    echo $username
fi