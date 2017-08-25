#!/bin/sh -e

# ElementaryOS Loki with crouton on Chromebook Pixel 2013
# Tjibbe van der Laan 2017
# 
# -------------------------------------------------------
# Additional installation of drivers, themes and programs

set -e

# Install git
# https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
sudo apt-get -y -qq install git

# Download preferences from repo
cd /tmp/
git clone https://github.com/tjibbevanderlaan/lokiforpixel.git
cd /tmp/lokiforpixel

# Install Hugh Greenbergs ported Pixel touchpad driver
# We need to build it for Xenial
# https://github.com/hugegreenbug
# http://marksolters.com/programming/2016/06/20/ubuntu-16.04-pixel.html
sudo apt-get -y -qq install xutils-dev xserver-xorg-dev build-essential libjsoncpp-dev libglib2.0-dev # build essentials
sudo apt-get -qq update
git clone https://github.com/hugegreenbug/libevdevc.git
cd /tmp/lokiforpixel/libevdevc
make
sudo make install
cd /tmp/lokiforpixel
git clone https://github.com/hugegreenbug/libgestures.git
cd /tmp/lokiforpixel/libgestures
make
sudo make install
cd /tmp/lokiforpixel
git clone https://github.com/hugegreenbug/xf86-input-cmt.git
cd /tmp/lokiforpixel/xf86-input-cmt
./configure --prefix=/usr
make
sudo make install
sudo cp xorg-conf/20-mouse.conf /usr/share/X11/xorg.conf.d/20-mouse.conf
sudo cp xorg-conf/40-touchpad-cmt.conf /usr/share/X11/xorg.conf.d/40-touchpad.conf
cd /tmp/lokiforpixel
sudo cp preferences/touchpad/50-touchpad-cmt-peppy.conf /usr/share/X11/xorg.conf.d/50-touchpad.conf
sudo mv /usr/share/X11/xorg.conf.d/50-synaptics.conf /usr/share/X11/xorg.conf.d/50-synaptics.conf-old
sudo apt-get -y -qq remove xutils-dev xserver-xorg-dev build-essential libjsoncpp-dev libglib2.0-dev # remove build essentials

# Install Arc dark theme
# https://github.com/horst3180/arc-theme
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/arc-theme.list"
sudo apt-get -qq update
sudo apt-get -y -qq --allow-unauthenticated install arc-theme

# Plank in arc dark
cd /tmp/lokiforpixel/preferences
wget https://raw.githubusercontent.com/horst3180/arc-theme/master/extra/Arc-Plank/dock.theme
sudo cp dock.theme /usr/share/plank/themes
cd /tmp/lokiforpixel

# Install curl
sudo apt-get -y -qq install curl

## App installation
# NodeJS and NPM
# https://nodejs.org/en/download/package-manager/
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get -y -qq install -y nodejs

# Correct NPM permissions according to option 2
# See docs: https://docs.npmjs.com/getting-started/fixing-npm-permissions
mkdir /home/$USER/.npm-global
npm config set prefix '~/.npm-global'
echo "export PATH=~/.npm-global/bin:$PATH" /home/$USER/.profile
source /home/$USER/.profile

# Sublime Text 3 + user packages
sudo apt-add-repository -y ppa:webupd8team/sublime-text-3
sudo apt-get -qq update
sudo apt-get -y -qq install sublime-text-installer
mkdir -p "/home/$USER/.config/sublime-text-3/Installed Packages"
cd /tmp/lokiforpixel
sudo cp "preferences/sublime/Package Controle.sublime-settings" "/home/$USER/.config/sublime-text-3/Installed Packages/"

# Arc dark theme for sublime + monokai
# https://github.com/GarthTheChicken/Sublime-Text-3-Arc-Dark-theme
cd /tmp/lokiforpixel
git clone "https://github.com/GarthTheChicken/Sublime-Text-3-Arc-Dark-theme"
mkdir -p /home/$USER/.config/sublime-text-3/Packages/User/
sudo cp -r Sublime-Text-3-Arc-Dark-theme/Arc-Dark /home/$USER/.config/sublime-text-3/Packages/User/
sudo cp Sublime-Text-3-Arc-Dark-theme/Widget.sublime-settings /home/$USER/.config/sublime-text-3/Packages/User/
sudo cp preferences/sublime/Arc-Monokai.tmTheme /home/$USER/.config/sublime-text-3/Packages/User/Arc-Dark/schemes/
sudo cp preferences/sublime/Preferences.sublime-settings /home/$USER/.config/sublime-text-3/Packages/User/

# Set arc-dark as default theme without using elementary-tweaks
gsettings set org.gnome.desktop.interface gtk-theme "Arc-Dark"

# You can run the chroot from the ChromeOs shell with the command:
# sudo enter-chroot -n xiwi -X xorg startelementary
