# NorTK OS Engineering Standards

This document formalizes the technical truth and architectural mandates for the NorTK OS project.

## Architectural Mandates

### Bootloader (Resilient EFI)
- **Standalone GRUB**: We use a custom-built `grubx64.efi` generated via `grub2-mkimage` in `config.sh`.
- **Module Injection**: GRUB modules (`*.mod`, `*.lst`) must be staged in `/boot/efi/EFI/centos/x86_64-efi/` and injected into the final raw image's EFI partition using `scripts/fix-efi-stub.sh` via the `editbootinstall` hook.
- **Dynamic Stub**: The EFI partition `grub.cfg` must be a dynamic search stub to bypass static UUID dependencies. It searches for `/boot/grub2/grub.cfg` or `/grub2/grub.cfg`.

### Storage & Filesystem
- **Filesystem**: BTRFS is the mandatory root filesystem.
- **Subvolume Layout**:
    - `@root` (default)
    - `boot` -> `/boot`
    - `home` -> `/home`
    - `root` -> `/root`
    - `srv` -> `/srv`
    - `usr-local` -> `/usr/local`
    - `var` -> `/var`
- **EFI Partition**: Fixed at 512MB.

## Workflow Mandates

### Project Journaling Protocol (PJP)
- **Tool**: `ajourn` must be used for all state-altering decisions.
- **Startup**: `ajourn startup` is the first command of every session.
- **Logging**: Significant technical pivots (DEC), discoveries (GOT), or problems (PRB) must be logged with `ajourn log`.

### Build & Test
- **KIWI**: Use KIWI v10.3.0+.
- **Validation**: Every build must be verified in QEMU using `run_test.py` or manual inspection of the generated `.qcow2`.

## Engineering Principles
- **KISS**: Favor linear `scripts/` over complex KIWI internal magic.
- **DRY**: Use templates (`grub.cfg.*-template`) for configurations.
- **English Only**: All code, comments, and documentation must be in English.
- **Fail Fast**: The `editbootinstall` hook must fail loudly if it cannot find the EFI partition.
