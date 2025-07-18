#!/bin/bash
set -e

sudo reflector --threads 5 -c Austria -n 1 -p https --sort rate --save /etc/pacman.d/mirrorlist

# Partition, format and mount
parted -s /dev/sda mklabel gpt
parted -s /dev/sda mkpart primary fat32 1MiB 512MiB
parted -s /dev/sda set 1 esp on
parted -s /dev/sda mkpart primary ext4 512MiB 100%

mkfs.fat -F32 /dev/sda1
mkfs.ext4 -F /dev/sda2

mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# Install base system
pacstrap -c /mnt base linux linux-firmware sudo nano iwd dhcpcd efibootmgr grub thermald btop fastfetch git eza fd jq ripgrep yazi bash-completion starship zoxide fzf man-db man-pages reflector sway swaybg swaylock swayidle wmenu foot brightnessctl wireplumber pipewire-pulse pavucontrol chromium blueman thunar thunar-volman ristretto mousepad otf-font-awesome waybar archlinux-wallpaper autotiling wofi blueman chromium noto-fonts power-profiles-daemon xdg-user-dirs xorg-xwayland 

sed -i "s/'fallback'//g" /mnt/etc/mkinitcpio.d/linux.preset

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab
sed -i '/zram/{N;d;}' /mnt/etc/fstab

# Setup time zone and localization
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Poland /etc/localtime
arch-chroot /mnt hwclock --systohc
echo "en_US.UTF-8 UTF-8" > /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

# Set hostname
echo "archlinux" > /mnt/etc/hostname

# Set root password
echo "root:joao" | arch-chroot /mnt chpasswd

# Create new user and set password
arch-chroot /mnt useradd -m -G wheel -s /bin/bash joao
echo "joao:joao" | arch-chroot /mnt chpasswd
arch-chroot /mnt bash -c "echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"

# Install bootloader
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=SDA
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
arch-chroot /mnt systemctl enable iwd dhcpcd thermald bluetooth power-profiles-daemon

echo "Installation complete! Reboot to use your new system."
