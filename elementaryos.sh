#!/bin/sh -e

# ElementaryOS Loki with crouton on Chromebook Pixel 2013
# Tjibbe van der Laan 2017
#
# --------------------------------------------------------
# Installation of elementaryOS Loki

set -e

# Add apt-get features
sudo apt-get -y -qq install software-properties-common

# Set elementary repositories
sudo apt-add-repository -y ppa:elementary-os/os-patches
sudo apt-add-repository -y ppa:elementary-os/stable

# Install elementary desktop
sudo apt-get -qq update
sudo apt-get -y -qq dist-upgrade
sudo apt-get -y -qq install elementary-desktop

# Correct elementary permissions
sudo chown -R $USER:$USER /home/$USER/.cache
sudo chown -R $USER:$USER /home/$USER/.config

# Set-up locales
# https://askubuntu.com/questions/162391/how-do-i-fix-my-locale-issue
sudo locale-gen "en_US.UTF-8"
sudo dpkg-reconfigure locales --u
    
# Create crouton startup scripts
cd /usr/bin
sudo sh -c "echo '#!/bin/sh\nexec xinit /usr/bin/xinit_pantheon' >> startelementary"
sudo sh -c "echo '#!/bin/sh\nXDG_CURRENT_DESKTOP=Pantheon\nexport XDG_CURRENT_DESKTOP\ngnome-session --session=pantheon' >> xinit_pantheon"
sudo chmod +x xinit_pantheon
sudo chown root:root xinit_pantheon
sudo chmod +x startelementary
sudo chown root:root startelementary
