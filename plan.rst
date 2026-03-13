====================================
KIWI-ng Improvements Plan for NorTK
====================================

Based on review of kiwi-ng documentation (elements.rst, build_live_iso.rst,
customize_the_boot_process.rst, etc.) and current project state.

Current Strengths
=================
- Good use of profiles, repositories with signing, hybrid live ISO.
- Custom nortk theme in cdroot/ and root/, Plymouth integration.
- update-cdroot.bash workflow.

Prioritized Improvements
========================

1. **SELinux Hardening** (High)
   - Add ``selinux_policy="targeted"`` to both ``<type>`` elements.
   - Add packages: ``selinux-policy-targeted policycoreutils``.
   - Add ``restorecon -R -v /`` (or targeted paths) in ``config.sh``.
   - Remove temporary ``setenforce 0`` from Makefile where possible.

2. **Dynamic Bootloader Configuration**
   - Create ``editbootconfig.sh`` and ``editbootinstall.sh`` in root.
   - Add to ``<type>``: ``editbootconfig="editbootconfig.sh" editbootinstall="editbootinstall.sh"``.
   - Reduce reliance on fully static ``grub.cfg`` files; leverage ``${theme}``, ``${gfxmode}`` variables.

3. **Dracut and Overlay Enhancements**
   - Add ``root/etc/dracut.conf.d/90-nortk.conf`` with kiwi-live/overlay modules.
   - Consider switching Live to ``flags="overlay"`` for better kiwi integration.
   - Add custom dracut hooks for boot-time customizations.

4. **Package and Profile Refinements**
   - Split packages by profile (Live vs Disk).
   - Package the nortk Plymouth theme properly.
   - Add missing dracut-kiwi modules and reduce bootstrap duplication.

5. **GRUB Theme Consistency**
   - Ensure both live (Dark Matter/nortk) and installed themes are fully covered.
   - Update templates to consistently reference theme.

6. **Documentation and Maintainability**
   - Expand README.rst with build troubleshooting and SELinux notes.
   - Add ``<include>`` for shared config fragments.
   - Create dedicated ``plan.rst`` (this file) and update after changes.

Next Steps
==========
- Implement highest priority items (SELinux + editboot scripts).
- Test with ``make build-live`` and ``make test-live``.
- Run ``kiwi-ng system build --debug ...`` for validation.

References
==========
- kiwi-ng docs: ``~/src/kiwi/doc/source/image_description/elements.rst``
- Current commit: bb83fe3 (feat(grub): enable nortk theme)

.. vim: set filetype=rst: