#/bin/sh

set -e

function usage() {
  echo "usage: ./venv.sh <folder>"
  echo "Create a virtual environment in the provided folder if it does not already exists."
  echo "Then chroot into that environment and span a bash process."
}

function create() {
  echo "creating environment in $VENV..."
  mkdir $VENV
  mkdir $VENV/{upper,work,mount}
}

function mount() {
  sudo mount -t overlay -o lowerdir=/,upperdir=$VENV/upper,workdir=$VENV/work overlayfs $VENV/mount
  sudo mount -t proc proc $VENV/mount/proc
  sudo mount -t sysfs sys $VENV/mount/sys
  sudo mount -t devtmpfs dev $VENV/mount/dev
  # Needed for tty
  sudo mount --bind /dev/pts $VENV/mount/dev/pts
  # Needed for networking (/etc/resolv.conf is pointing to /run)
  sudo mount --bind /run $VENV/mount/run
}

function umount() {
  sudo umount /tmp/rust/mount/proc 
  sudo umount /tmp/rust/mount/sys 
  sudo umount /tmp/rust/mount/dev/pts 
  sudo umount /tmp/rust/mount/dev
  sudo umount /tmp/rust/mount/run 
  sudo umount /tmp/rust/mount/
}

if [[ $# -ne 1 ]]; then
  echo "error: invalid number of argument"
  usage
  exit 1
fi

# The folder where the environment is to be created if necessary and used
VENV=$1

if [[ -e "$VENV" ]] && [[ ! -d "$VENV" ]]; then
  echo "error: $VENV should be a directory"
  usage
  exit 2
elif [[ ! -x "$VENV" ]]; then
  create
fi

# Mounting the overlay
mount
echo "chrooting to $VENV..."
sudo env HOME=/home/$USER chroot --userspec=$USER:$GROUPS $VENV/mount /bin/bash --login
# Unmounting the overlay
umount
echo "exited virtual environment $VENV"
