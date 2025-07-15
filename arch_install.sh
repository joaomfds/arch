#!/bin/bash
set -e

# List and ask for the target drive
echo "Available drives:"
lsblk -d -o NAME,SIZE,MODEL
echo
read -rp "Enter the drive to install Arch Linux on (e.g., /dev/sda): " DRIVE

# Ask for root password
while true; do
    read -rsp "Enter new root password: " ROOT_PASS
    echo
    read -rsp "Confirm root password: " ROOT_PASS2
    echo
    [[ "$ROOT_PASS" == "$ROOT_PASS2" ]] && break
    echo "Passwords do not match. Try again."
done

# Ask for new user info
read -rp "Enter new username: " USERNAME
while true; do
    read -rsp "Enter password for $USERNAME: " USER_PASS
    echo
    read -rsp "Confirm password for $USERNAME: " USER_PASS2
    echo
    [[ "$USER_PASS" == "$USER_PASS2" ]] && break
    echo "Passwords do not match. Try again."
done

# Partition, format and mount
sgdisk --zap-all $DRIVE
parted -s $DRIVE mklabel gpt
parted -s $DRIVE mkpart primary fat32 1MiB 512MiB
parted -s $DRIVE set 1 esp on
parted -s $DRIVE mkpart primary ext4 512MiB 100%

EFI_PART="${DRIVE}1"
ROOT_PART="${DRIVE}2"

mkfs.fat -F32 $EFI_PART
mkfs.ext4 -F $ROOT_PART

mount $ROOT_PART /mnt
mkdir /mnt/boot
mount $EFI_PART /mnt/boot

# Install base system
pacstrap /mnt base linux linux-firmware sudo

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Setup time zone and localization
arch-chroot /mnt ln -sf /usr/share/zoneinfo/UTC /etc/localtime
arch-chroot /mnt hwclock --systohc
echo "en_US.UTF-8 UTF-8" > /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

# Set hostname
echo "archlinux" > /mnt/etc/hostname

# Set root password
echo "root:$ROOT_PASS" | arch-chroot /mnt chpasswd

# Create new user and set password
arch-chroot /mnt useradd -m -G wheel -s /bin/bash "$USERNAME"
echo "$USERNAME:$USER_PASS" | arch-chroot /mnt chpasswd
arch-chroot /mnt bash -c "echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers"

# Install bootloader
arch-chroot /mnt pacman --noconfirm -S grub efibootmgr
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

echo "Installation complete! Reboot to use your new system."
