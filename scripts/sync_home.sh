#!/bin/bash
sudo pacman -S rsync --needed
sudo mount /dev/sdc1 /mnt
sudo rsync -rtv --progress --exclude='.local/' --exclude='.cache/' "$HOME/" /mnt/backup

