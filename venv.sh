#/bin/sh

mkdir .env
mkdir .env/{upper,work,mount}
sudo mount -t overlay -o lowerdir=/,upperdir=.env/upper,workdir=.env/work overlayfs .env/mount
sudo mount -t proc proc .env/mount/proc
sudo mount -t sysfs sys .env/mount/sys
sudo mount -t devtmpfs dev .env/mount/dev
# Needed for tty
sudo mount --bind /dev/pts .env/mount/dev/pts
# Needed for networking (/etc/resolv.conf is pointing to /run)
sudo mount --bind /run .env/mount/run
sudo env HOME=/home/$USER chroot --userspec=$USER:$GROUPS env/mount /bin/bash --login
