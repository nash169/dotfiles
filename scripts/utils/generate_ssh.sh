#!/bin/bash

read -p "Insert your email: " mail

ssh-keygen -t ed25519 -C $mail