#!/bin/bash

read -p "Do you want to install laptop module?[y/n] " name
if [ "$name" == "y" ]; then
    sh .modules/laptop.sh
fi





