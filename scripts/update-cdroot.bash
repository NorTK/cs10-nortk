#!/usr/bin/bash
set -euo pipefail
echo "Generating config-cdroot.tar.zst from root/ overlay..."
rm -f config-cdroot.tar.zst

# We archive the 'boot' directory from the 'root/' overlay.
# This ensures it is unpacked into the ISO's root as /boot/grub2/themes/nortk/...
# and becomes available to the installer's GRUB.
tar --use-compress-program=zstd -cf config-cdroot.tar.zst -C root boot

ls -lh config-cdroot.tar.zst
echo "config-cdroot.tar.zst generated successfully."
