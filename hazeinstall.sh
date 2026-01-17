#!/bin/bash

# HazeInstall - an installation script for the HaZe window manager
# Copyright (C) 2026 Karl "karl152"
# Licensed under the X11 License
# SPDX-License-Identifier: X11

echo ""
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
echo -e "$color -> updating system..."
sudo apt-get update
sudo apt-get dist-upgrade -y
echo -e "$color -> installing wget..."
sudo apt-get install wget -y
echo -e "$color -> downloading HaZe..."
wget http://www.escomposlinux.org/jes/haze_02/haze_0.2.tar.gz
echo -e "$color -> checking if HaZe was downloaded correctly..."
sha256sum --check haze_0.2.tar.gz.sha256
echo -e "$color -> extracting archive..."
tar -xzvf haze_0.2.tar.gz
echo -e "$color -> installing X.Org..."
sudo apt-get install xorg -y
echo -e "$color -> installing X11 tools..."
sudo apt-get install xinit x11-xserver-utils xterm x11-apps x11-utils -y
echo -e "$color -> installing HaZe dependencies and build tools..."
sudo apt-get install build-essential libx11-dev libxft-dev libxinerama-dev libxpm-dev libxext-dev pkg-config x11proto-dev checkinstall -y
echo -e "$color -> patching Makefile and source code..."
cd haze_0.2
sed -i 's|/usr/X11R6/include|/usr/include|g' Makefile
sed -i '155,$d' Makefile
sed -i '1i #include <string.h>' src/balloon.c
sed -i '1i #include <string.h>' src/wild.c
echo -e "$color -> compiling HaZe..."
make
echo -e "$color -> creating configuration..."
echo "#!/bin/dash" > ~/.xinitrc
echo "exec $HOME/haze_0.2/hazewm" > ~/.xinitrc
chmod +x ~/.xinitrc
touch ~/.hazerc
echo -e "$color -> starting X Server..."
startx
# sudo checkinstall #TODO
