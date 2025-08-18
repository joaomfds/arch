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
parted -s "$DRIVE" mklabel gpt
parted -s "$DRIVE" mkpart primary fat32 1MiB 512MiB
parted -s "$DRIVE" set 1 esp on
parted -s "$DRIVE" mkpart primary btrfs 512MiB 100%

EFI_PART="${DRIVE}1"
ROOT_PART="${DRIVE}2"

echo "Formatting boot partition..."
mkfs.fat -F32 "$EFI_PART"

echo "Formatting root partition..."
mkfs.btrfs -f "$ROOT_PART"

echo "Mounting root partition..."
mount "$ROOT_PART" /mnt

echo "Mounting boot partition..."
mount --mkdir "$EFI_PART" /mnt/boot

echo "Installing base system"
reflector -c at -p http -f 1 --save /etc/pacman.d/mirrorlist

sed -i '/ParallelDownloads/c\ParallelDownloads = 50' /etc/pacman.conf

pacstrap /mnt base linux linux-firmware-intel intel-media-driver intel-gpu-tools \
intel-ucode base-devel bash-completion aria2 btop btrfs-progs duf efibootmgr \
eza fastfetch fzf fish git man-db man-pages nano ncdu neovide openssh \
otf-font-awesome reflector starship stow tailscale wget yazi zoxide \
docker docker-compose \
plasma-meta kde-system-meta kde-utilities-meta ktorrent gnome-boxes \
hyprland hypridle hyprlock hyprpolkitagent brightnessctl cliphist \
foot grim mako nwg-look pavucontrol qt5ct slurp tlp waybar \
wl-clip-persist wofi xdg-desktop-portal-hyprland archlinux-xdg-menu 

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab
echo "/dev/sda1                                       /home           btrfs           rw,relatime,ssd,discard=async,space_cache=v2,subvol=/   0 0" >> /mnt/etc/fstab

sed -i "s/'fallback'//g" /mnt/etc/mkinitcpio.d/linux.preset

# Set up system inside chroot
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Poland /etc/localtime
arch-chroot /mnt hwclock --systohc
echo "en_US.UTF-8 UTF-8" > /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
echo "KEYMAP=us" >> /mnt/etc/vconsole.conf
echo "archlinux" > /mnt/etc/hostname

# Set root password
echo "root:$ROOT_PASS" | arch-chroot /mnt chpasswd

# Add new user with sudo
arch-chroot /mnt useradd -m -G wheel,input,rtkit -s /bin/bash "$USERNAME"
echo "$USERNAME:$USER_PASS" | arch-chroot /mnt chpasswd
arch-chroot /mnt bash -c "echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"

# Install systemd-boot
arch-chroot /mnt bootctl --path=/boot install
echo "timeout 0" >> /mnt/boot/loader/loader.conf
echo "default=archlinux" >> /mnt/boot/loader/loader.conf
echo "linux /vmlinuz-linux" > /mnt/boot/loader/entries/archlinux.conf
echo "initrd /intel-ucode.img" >> /mnt/boot/loader/entries/archlinux.conf
echo "initrd /initramfs-linux.img" >> /mnt/boot/loader/entries/archlinux.conf
echo "options root=$ROOT_PART rw modprobe.blacklist=nvidia,nvidia_modeset,nvidia_drm,nvidia_uvm,nouveau mitigations=off quiet splash" >> /mnt/boot/loader/entries/archlinux.conf

# Update tlp.conf
echo "CPU_ENERGY_PERF_POLICY_ON_AC=balance_performance" >> /mnt/etc/tlp.d/01-powersave.conf
echo "CPU_ENERGY_PERF_POLICY_ON_BAT=balance_power" >> /mnt/etc/tlp.d/01-powersave.conf
echo "STOP_CHARGE_THRESH_BAT0=80" >> /mnt/etc/tlp.d/02-battery_protection.conf

# Install Chaotic Aur
arch-chroot /mnt pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
arch-chroot /mnt pacman-key --lsign-key 3056513887B78AEB
arch-chroot /mnt pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
arch-chroot /mnt pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

# Append to the end of /etc/pacman.conf
CHAOTIC_AUR="[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist"
echo -e "$CHAOTIC_AUR" | sudo tee -a /mnt/etc/pacman.conf > /dev/null
arch-chroot /mnt pacman -Syuu --noconfirm google-chrome lazygit \
libinput-gestures nvchad octopi onedrive-abraunegg pacseek \
qt6ct-kde stremio wlogout yay

echo "Chaotic AUR repository added to /etc/pacman.conf"

arch-chroot /mnt systemctl enable bluetooth NetworkManager rtkit-daemon sddm tlp tailscaled

echo "Installation complete! You can reboot after unmounting /mnt."
