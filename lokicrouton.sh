# ElementaryOS Loki with crouton on Chromebook Pixel 2013
# Tjibbe van der Laan
# 
# Loki for crouton on Chromebook Pixel 2013 installs:
# - a chroot with the name loki
# - elementary os loki, based on xenial, within this chroot
# - loki startup scripts for crouton
# - Git
# - Hugh Greenbergs ported Atmel driver for the touchpad
# - Arc dark theme
# - Node and NPM, with corrected permissions
# - Sublime Text
# --------------------------------------------------------

# Set-up crouton
# It is assumed that your crouton installer is located at ~/Downloads/crouton
# Would you like to install crouton at another location? Please add the argument 
# -p 'your/preferred/location'. Add -e to encrypt your chroot.
sudo sh ~/Downloads/crouton -r xenial -t x11,xiwi,extension,keyboard,touch -n loki 

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
sudo dpkg-reconfigure locales
    
# Create crouton startup scripts
cd /usr/bin
sudo sh -c "echo -e '#!/bin/sh\nexec xinit /usr/bin/xinit_pantheon' >> startelementary"
sudo sh -c "echo -e '#!/bin/sh\nXDG_CURRENT_DESKTOP=Pantheon\nexport XDG_CURRENT_DESKTOP\ngnome-session --session=pantheon' >> xinit_pantheon"
sudo chmod +x xinit_pantheon
sudo chown root:root xinit_pantheon
sudo chmod +x startelementary
sudo chown root:root startelementary

# Install git
# https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
sudo apt-get -y -qq install git-all

# Install Hugh Greenbergs ported Pixel touchpad driver
# We need to build it for Xenial
# https://github.com/hugegreenbug
# http://marksolters.com/programming/2016/06/20/ubuntu-16.04-pixel.html
sudo apt-get -y -qq install build-essential libjsoncpp-dev libglib2.0-dev # build essentials
git clone https://github.com/hugegreenbug/libevdevc.git
cd libevdevc
make
sudo make install
cd ..
git clone https://github.com/hugegreenbug/libgestures.git
cd libgestures
make
sudo make install
cd ..
git clone https://github.com/hugegreenbug/xf86-input-cmt.git
cd xf86-input-cmt
./configure --prefix=/usr
make
sudo make install
sudo cp xorg-conf/20-mouse.conf /usr/share/X11/xorg.conf.d/20-mouse.conf
sudo cp xorg-conf/40-touchpad.conf /usr/share/X11/xorg.conf.d/40-touchpad.conf
cd ..
sudo cp preferences/touchpad/50-touchpad-cmt-peppy.conf /usr/share/X11/xorg.conf.d/50-touchpad.conf
sudo mv /usr/share/X11/xorg.conf.d/50-synaptics.conf /usr/share/X11/xorg.conf.d/50-synaptics.conf-old
sudo apt-get -y -qq remove build-essential libjsoncpp-dev libglib2.0-dev # remove build essentials

# Install Arc dark theme
# https://github.com/horst3180/arc-theme
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/arc-theme.list"
sudo apt-get -qq update
sudo apt-get -y -qq install arc-theme

# Plank in arc dark
cd preferences
wget https://raw.githubusercontent.com/horst3180/arc-theme/master/extra/Arc-Plank/dock.theme
sudo cp dock.theme /usr/share/plank/themes
cd ..

## App installation
# NodeJS and NPM
# https://nodejs.org/en/download/package-manager/
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get -y -qq install -y nodejs

# Correct NPM permissions according to option 2
# See docs: https://docs.npmjs.com/getting-started/fixing-npm-permissions
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo "export PATH=~/.npm-global/bin:$PATH" ~/.profile
source ~/.profile

# Sublime Text 3 + user packages
sudo apt-add-repository -y ppa:webupd8team/sublime-text-3
sudo apt-get -qq update
sudo apt-get -y -qq install sublime-text-installer
cd preferences/sublime
sudo cp "Package Control.sublime-settings" "~/.config/sublime-text-3/Installed Packages/"
cd ../..

# Arc dark theme for sublime + monokai
# https://github.com/GarthTheChicken/Sublime-Text-3-Arc-Dark-theme
cd preferences/sublime
git clone "https://github.com/GarthTheChicken/Sublime-Text-3-Arc-Dark-theme"
cd Sublime-Text-3-Arc-Dark-theme
sudo cp Arc-Dark ~/.config/sublime-text-3/Packages/User/
sudo cp Widget.sublime-settings ~/.config/sublime-text-3/Packages/User/
cd ..
sudo cp Arc-Monokai.tmTheme ~/.config/sublime-text-3/Packages/User/Arc-Dark/schemes/
sudo cp Preferences.sublime-settings ~/.config/sublime-text-3/Packages/User/
cd ../..

# You can run the chroot from the ChromeOs shell with the command:
# sudo enter-chroot -n xiwi -X xorg startelementary