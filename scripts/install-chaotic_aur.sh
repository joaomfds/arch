#!/bin/bash

echo "Adding Chaotic AUR repository"
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

CHAOTIC_AUR="[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist"

# Append to the end of /etc/pacman.conf
echo -e "$CHAOTIC_AUR" | sudo tee -a /etc/pacman.conf > /dev/null

echo "Chaotic AUR repository added to /etc/pacman.conf"
