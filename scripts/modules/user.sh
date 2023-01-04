#!/bin/bash
source scripts/utils.sh

# ADD USER
read -p "Insert user name (and pass): " username
if id "$username" &>/dev/null; then
    echo 'User already exists'
else
    adduser $username wheel || "Error: could not add user."
    addsudo $username || "Error: could not add user to sudoers."
fi
echo $username