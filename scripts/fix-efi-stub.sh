#!/usr/bin/bash
set -e
RAW_DISK="$1"
IMG_ROOT="${2:-.}"

echo "===> Running robust EFI stub patcher (Native Mount) <==="
echo "Target raw image: $RAW_DISK"
echo "Image root: $IMG_ROOT"

# Step 1: Obtain the exact sector offset for the EFI partition
# We use fdisk -l and look for the 'EFI System' partition. 
# The start sector is typically the second column.
START_SECTOR=$(fdisk -l "$RAW_DISK" | grep "EFI System" | awk '{print $2}')

if [ -z "$START_SECTOR" ] || ! [[ "$START_SECTOR" =~ ^[0-9]+$ ]]; then
    echo "FATAL: Could not parse EFI system partition offset!"
    fdisk -l "$RAW_DISK"
    exit 1
fi

OFFSET=$(( START_SECTOR * 512 ))
echo "Found EFI partition at sector $START_SECTOR (Offset: $OFFSET bytes)"

# Step 2: Mount the partition surgically
MNT=$(mktemp -d)
cleanup() {
    echo "Cleaning up mount point..."
    sync
    umount "$MNT" 2>/dev/null || true
    rmdir "$MNT" 2>/dev/null || true
}
trap cleanup EXIT

echo "Mounting EFI partition..."
mount -o loop,offset=$OFFSET "$RAW_DISK" "$MNT"

# Step 3: Inject configuration
echo "Injecting NorTK boot configuration..."
mkdir -p "$MNT/EFI/centos" "$MNT/EFI/BOOT"
cat << 'EOF' > "$MNT/EFI/centos/grub.cfg"
# Dynamically resolved loader stub created by NorTK fixing script
# This stub is embedded in the EFI partition to find the main boot partition.

# Set video mode early for branding scale
set gfxmode=1920x1080,1024x768,auto
insmod all_video
insmod gfxterm
terminal_output gfxterm

echo "NorTK OS Bootloader"
echo "Searching for boot configuration..."

# Search common paths for BTRFS subvolume layouts
search --file --set=root /boot/grub2/grub.cfg
if [ -z "$root" ]; then
    search --file --set=root /@root/boot/grub2/grub.cfg
fi
if [ -z "$root" ]; then
    search --file --set=root /grub2/grub.cfg
fi

if [ -n "$root" ]; then
    echo "Found boot partition on $root"
    # Determine the correct prefix path
    if [ -f ($root)/boot/grub2/grub.cfg ]; then
        set prefix=($root)/boot/grub2
    elif [ -f ($root)/@root/boot/grub2/grub.cfg ]; then
        set prefix=($root)/@root/boot/grub2
    else
        set prefix=($root)/grub2
    fi
    echo "Using prefix: $prefix"
    export prefix
    configfile $prefix/grub.cfg
else
    echo "ERROR: Could not find NorTK boot configuration!"
    echo "Attempting manual recovery..."
    ls (hd0,gpt3)/
    ls (hd0,gpt3)/@root/
fi
EOF

# Copy configuration to fallback path
cp "$MNT/EFI/centos/grub.cfg" "$MNT/EFI/BOOT/grub.cfg"

# Step 4: Inject modules (Safety Fallback)
# Even though KIWI builds modules into the binary, we keep them in the 
# directory structure as a standard EFI practice.
MOD_DIR="$IMG_ROOT/usr/lib/grub/x86_64-efi"
if [ -d "$MOD_DIR" ]; then
    echo "Injecting $(ls "$MOD_DIR"/*.mod | wc -l) GRUB modules to EFI partition..."
    mkdir -p "$MNT/EFI/centos/x86_64-efi"
    cp "$MOD_DIR"/*.mod "$MNT/EFI/centos/x86_64-efi/"
    cp "$MOD_DIR"/*.lst "$MNT/EFI/centos/x86_64-efi/"
fi

sync
echo "===> Patch injection successfully completed <==="
exit 0
