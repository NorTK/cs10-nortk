====================================
KIWI-ng Improvements Plan for NorTK
====================================

Based on kiwi-ng docs (elements.rst, build_live_iso.rst, customize_the_boot_process.rst)
and Gemini architectural review. **Corrected for execution pipeline and schema.**

Current State
=============
- Static GRUB configs + cdroot/root overlays work but are brittle.
- ``<bootloader-theme>`` added; theme loads but not ideal long-term.

Prioritized Improvements (Gemini + docs verified)
===========================================

1. **SELinux (High)**
   - Add ``selinux_policy="targeted"`` to both ``<type>`` elements.
   - Add packages ``selinux-policy-targeted policycoreutils`` (if not in groups).
   - **Do not** add ``restorecon`` in ``config.sh`` (KIWI runs ``setfiles`` automatically).

2. **Bootloader (High)**
   - Create ``editbootconfig.sh`` and ``editbootinstall.sh`` in project root (build-host only).
   - Add to ``<type>``: ``editbootconfig="editbootconfig.sh" editbootinstall="editbootinstall.sh"``.
   - Migrate from static ``grub.cfg``; use hooks + ``${theme}``.

3. **Dracut & Live ISO**
   - Use ``flags="overlay"`` on Live ``<type image="iso">`` (enables kiwi-live module).
   - Include ``dracut-kiwi-live`` in Live packages.
   - Add ``root/etc/dracut.conf.d/90-nortk.conf`` (documented for prototypes).

4. **Packaging & Maintainability**
   - ``root/`` + ``cdroot/`` OK for prototypes per docs; convert to RPMs for production.
   - Split packages by profile; reduce bootstrap duplication.
   - Expand README with build/SELinux notes.

Next Steps
==========
1. Update ``config.xml`` (add SELinux policy + ensure ``flags="overlay"``).
2. Implement ``editboot*.sh`` scripts.
3. Test: ``sudo make build-live && make test-live``.

References
==========
- kiwi-ng: ``~/src/kiwi/doc/source/image_description/elements.rst``
- Latest commit: 34e8c71
