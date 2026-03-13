#!/usr/bin/bash
set -euo pipefail

# KIWI editbootconfig hook for NorTK GRUB theme
# Args from KIWI: $1=image_type, $2=boot_part, $3=working_dir or image root

echo "NorTK editbootconfig: injecting nortk theme"

# Find the generated grub.cfg (common locations)
GRUB_CFG=""
for path in "$3/boot/grub2/grub.cfg" "$3/grub.cfg" "$3/EFI/BOOT/grub.cfg" "$3/boot/grub2/grub.cfg"; do
  if [ -f "$path" ]; then
    GRUB_CFG="$path"
    break
  fi
done

if [ -z "$GRUB_CFG" ] || [ ! -f "$GRUB_CFG" ]; then
  echo "Warning: No grub.cfg found to edit"
  exit 0
fi

# Inject theme loading after terminal_output gfxterm if not present
if ! grep -q "set theme=/boot/grub2/themes/nortk/theme.txt" "$GRUB_CFG"; then
  sed -i '/terminal_output gfxterm/a\
insmod font\
loadfont /boot/grub2/themes/nortk/hackb_22.pf2\
loadfont /boot/grub2/themes/nortk/norwester_24.pf2\
loadfont /boot/grub2/themes/nortk/norwester_28.pf2\
loadfont /boot/grub2/themes/nortk/norwester_30.pf2\
set theme=/boot/grub2/themes/nortk/theme.txt' "$GRUB_CFG"
  echo "Theme injected into $GRUB_CFG"
else
  echo "Theme already present in $GRUB_CFG"
fi

# Preserve dynamic kernelcmdline from KIWI
echo "editbootconfig completed successfully for NorTK"