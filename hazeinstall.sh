#!/bin/bash

# HazeInstall - an installation script for the HaZe window manager
# Copyright (C) 2026 Karl "karl152"
# Licensed under the X11 License
# SPDX-License-Identifier: X11

echo "HazeInstall by karl152"
echo "**********************"
echo "This script installs the HaZe window manager. Please choose a color for the installation script."
colors=("yellow" "green" "nocolor" "exit")
select col in "${colors[@]}"; do
    case $col in
        "yellow")
            color="\e[1;33m"
            break
            ;;
        "green")
            color="\e[1;32m"
            break
            ;;
        "nocolor")
            color="\e[0m"
            break
            ;;
        "exit")
            exit
            ;;
        *)
            echo "unknown option"
            ;;
    esac
done
echo -e "$color -> downloading HaZe..."
wget http://www.escomposlinux.org/jes/haze_02/haze_0.2.tar.gz
echo -e "$color -> checking if HaZe was downloaded correctly..."
sha256sum --check haze_0.2.tar.gz.sha256
echo -e "$color -> extracting archive..."
tar -xzvf haze_0.2.tar.gz
echo -e "$color -> updating system..."
sudo apt-get update
sudo apt-get dist-upgrade -y
echo -e "$color -> installing X.Org..."
sudo apt-get install xorg -y
echo -e "$color -> installing X11 tools..."
sudo apt-get install xinit x11-server-utils xterm x11-apps x11-utils -y
echo -e "$color -> installing HaZe dependencies and build tools..."
sudo apt-get install build-essential libx11-dev libxft-dev libxinerama-dev libxpm-dev libxext-dev pkg-config x11proto-dev checkinstall -y
echo -e "$color -> compiling HaZe..."
cd haze_0.2
sed -i 's|/usr/X11R6/include|/usr/include|g' Makefile
make
sudo checkinstall #TODO
