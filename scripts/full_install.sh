#!/bin/bash

echo "Enabling parallel downloads in pacman.conf (25)"

sudo sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 25/' /etc/pacman.conf

echo "Adding Chaotic AUR repository"
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U --noconfirm'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

CHAOTIC_AUR="[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist"

# Append to the end of /etc/pacman.conf
echo -e "$CHAOTIC_AUR" | sudo tee -a /etc/pacman.conf > /dev/null

echo "Chaotic AUR repository added to /etc/pacman.conf"

echo "Installing all pacman packages"
sudo pacman -Syuu --needed --noconfirm - < packages

echo "Installing Asus Fan Control"
yay -S --noconfirm asus-fan-control

echo "Enabling AFC system service"
sudo systemctl enable afc

echo " Installing Powertop Service"
sudo cp  powertop.service /etc/systemd/system/ && sudo systemctl enable powertop

echo "Installing Battery Protection Service"
sudo cp battery-charge-threshold.service /etc/systemd/system/ && sudo systemctl enable battery-charge-threshold
echo " Enabling all services"
sudo systemctl enable battery-charge-threshold bluetooth cups NetworkManager powertop supergfxd thermald upower 
