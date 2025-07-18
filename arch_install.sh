#!/bin/bash
set -e

# List drives and ask for selection
echo "Available drives:"
lsblk -d -o NAME,SIZE,MODEL
echo
read -rp "Enter the drive to install Arch Linux on (e.g., /dev/sda): " DRIVE

# Securely get root password
while true; do
    read -rsp "Enter new root password: " ROOT_PASS
    echo
    read -rsp "Confirm root password: " ROOT_PASS2
    echo
    [[ "$ROOT_PASS" == "$ROOT_PASS2" ]] && break
    echo "Passwords do not match. Try again."
done

# User creation info
read -rp "Enter new username: " USERNAME
while true; do
    read -rsp "Enter password for $USERNAME: " USER_PASS
    echo
    read -rsp "Confirm password for $USERNAME: " USER_PASS2
    echo
    [[ "$USER_PASS" == "$USER_PASS2" ]] && break
    echo "Passwords do not match. Try again."
done

# Partition and format using parted & fdisk (MBR)
echo "Creating DOS partition table and partitions..."
parted -s "$DRIVE" mklabel msdos
parted -s "$DRIVE" mkpart primary ext4 1MiB 100%
ROOT_PART="${DRIVE}1"

echo "Formatting root partition..."
mkfs.ext4 -F "$ROOT_PART"

echo "Mounting root partition..."
mount "$ROOT_PART" /mnt

# Install base system
pacstrap /mnt base linux linux-firmware sudo

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Set up system inside chroot
arch-chroot /mnt ln -sf /usr/share/zoneinfo/UTC /etc/localtime
arch-chroot /mnt hwclock --systohc
echo "en_US.UTF-8 UTF-8" > /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
echo "archlinux" > /mnt/etc/hostname

# Set root password
echo "root:$ROOT_PASS" | arch-chroot /mnt chpasswd

# Add new user with sudo
arch-chroot /mnt useradd -m -G wheel -s /bin/bash "$USERNAME"
echo "$USERNAME:$USER_PASS" | arch-chroot /mnt chpasswd
arch-chroot /mnt bash -c "echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers"

# Install GRUB for BIOS/MBR
arch-chroot /mnt pacman --noconfirm -S grub
arch-chroot /mnt grub-install --target=i386-pc --recheck "$DRIVE"
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

echo "Installation complete! You can reboot after unmounting /mnt."
