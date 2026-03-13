#!/usr/bin/bash
set -euo pipefail

echo "Updating config-cdroot.tar.zst from cdroot/ directory..."

rm -f config-cdroot.tar.zst

# Use persistent cdroot/ directory (user wants to edit files directly here)
tar --use-compress-program=zstd -cf config-cdroot.tar.zst -C cdroot .

ls -lh config-cdroot.tar.zst
echo "config-cdroot.tar.zst updated successfully from cdroot/."