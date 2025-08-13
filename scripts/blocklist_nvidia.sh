sudo bash -c "echo -e 'blacklist nouveau\nblacklist nvidia\nblacklist nvidiafb\nblacklist nvidia_drm\nblacklist nvidia_modeset\nblacklist nvidia_uvm' > /etc/modprobe.d/blacklist-nvidia.conf"
