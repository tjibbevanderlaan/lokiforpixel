#!/bin/sh -e
#
# ElementaryOS Loki with crouton on Chromebook Pixel 2013
# Tjibbe van der Laan 2017
#
# --------------------------------------------------------
# Installation of crouton within ChromeOS shell

# Set-up crouton
# It is assumed that your crouton installer is located at ~/Downloads/crouton
# Would you like to install crouton at another location? Please add the argument 
# -p 'your/preferred/location'. Add -e to encrypt your chroot.
sudo sh ~/Downloads/crouton -r xenial -t x11,xiwi,extension,keyboard,touch -n loki 

sudo enter-chroot -n loki