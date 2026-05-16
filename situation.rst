NorTK OS: Final Branding Polish & Resolution Persistence
======================================================

Current Status (2026-05-15)
--------------------------

We have achieved synchronized branding for NorTK OS on CentOS Stream 10, covering both the installer environment and the target system.

Accomplishments
~~~~~~~~~~~~~~~

1.  **GRUB Branding Synchronization**:
    - The NorTK theme (logo, background, and fonts) is correctly applied to both the Live/Install ISO and the installed system.
    - Successfully integrated 'Terminus Regular 18' and 'Unifont Regular 32' fonts.
2.  **Resolution Hardening (Installer)**:
    - The Install/Live media successfully operates at 1920x1080.
    - Robust `grub.cfg` templates ensure the theme is found via search and video drivers are pre-loaded.
3.  **Plymouth Integration**:
    - Implemented a 'two-step' (spinner) Plymouth theme with the NorTK logo watermark.
    - Verified resolution handover from GRUB to Plymouth via `GRUB_GFXPAYLOAD_LINUX="keep"`.
4.  **Resilient Boot Architecture**:
    - Custom `grubx64.efi` built with BTRFS, ZSTD, and RAID support.
    - Automated EFI stub patching script (`fix-efi-stub.sh`) ensures the raw disk image contains our custom bootloader and modules.
5.  **KIWI Build Pipeline**:
    - Resolved `KiwiTemplateError` by correctly escaping GRUB runtime variables in XML templates.
    - Automated `cdroot` asset packaging via `update-cdroot.bash`.
6.  **Installed System Resolution Workaround**:
    - Overcame KIWI's `system create` phase overwriting `/etc/default/grub` defaults. By re-initializing `gfxterm` (bouncing `terminal_output` to `console` and back to `gfxterm`) in `/etc/grub.d/01_nortk_theme`, GRUB correctly enforces 1920x1080 on the installed system.
    - Filed upstream bug report against `OSInside/kiwi` (Issue #2998) to officially support `1920x1080x32` in `defaults.py`.

Known Issues
~~~~~~~~~~~~

- Refine the GRUB theme to better handle non-1080p fallbacks using relative positioning if possible.

Next Steps
~~~~~~~~~~

Technical Summary

- **Target**: CentOS Stream 10 (x86_64)
- **Framework**: KIWI-ng v10.3.0
- **Filesystem**: BTRFS (Default subvolume layout)
- **Resolution**: 1920x1080 (Primary)
