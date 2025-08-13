#! /bin/sh
sudo apk update && sudo apk upgrade && sudo apk fix && sudo apk cache sync

#sudo rsync -a --no-i-r --info=progress2 --delete --exclude='fstab' /etc/ /mnt/etc/

for dir in bin etc home lib opt root sbin srv usr var; do sudo rsync -a --no-i-r --info=progress2 --delete --exclude='fstab' /$dir /mnt/$dir; done


echo "

#Starting chroot on alternate drive.

#Run sudo apk fix to sync packages.

"

for dir in dev proc run sys tmp; do sudo  mount --bind /$dir /mnt/$dir; done

sudo chroot /mnt

#for dir in dev proc run sys tmp; do sudo umount /mnt/$dir; done
#sudo umount /mnt

