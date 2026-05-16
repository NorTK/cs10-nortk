.PHONY: build-live build-disk clean distclean test-live test-disk test-disk-serial theme-preview
version=0.1.0
theme_path=root/boot/grub2/themes/nortk

build-live:
	-setenforce 0
	scripts/update-cdroot.bash || true
	kiwi --profile=Live system build --description=. --target-dir=result-live/
	-setenforce 1

build-disk: prepare-disk create-disk

prepare-disk:
	-setenforce 0
	scripts/update-cdroot.bash || true
	kiwi --profile=Disk system prepare --description=. --root=result-disk/build/image-root
	-setenforce 1

create-disk:
	-setenforce 0
	kiwi --profile=Disk system create --root=result-disk/build/image-root --target-dir=result-disk/
	scripts/fix-efi-stub.sh result-disk/NorTK-OS.x86_64-$(version).raw result-disk/build/image-root
	-setenforce 1

test-live:
	qemu-kvm -enable-kvm -machine pc,vmport=off -cpu host -smp 4 -m 8192 \
		-bios /usr/share/edk2/ovmf/OVMF_CODE.fd \
		-drive file=result-live/NorTK-OS.x86_64-$(version).iso,media=cdrom \
		-nic user,hostfwd=tcp::2222-:22 -usb -device usb-tablet \
		-vga virtio -display sdl,gl=on -s


test-disk:
	qemu-img create -f qcow2 test-disk.qcow2 20G
	cp /usr/share/edk2/ovmf/OVMF_VARS.fd test-vars.fd
	-qemu-kvm -enable-kvm -machine pc,vmport=off -cpu host -smp 4 -m 8192 \
		-drive if=pflash,format=raw,unit=0,file=/usr/share/edk2/ovmf/OVMF_CODE.fd,readonly=on \
		-drive if=pflash,format=raw,unit=1,file=test-vars.fd \
		-drive file=test-disk.qcow2,if=none,id=drive0,format=qcow2 \
		-device virtio-blk-pci,drive=drive0,bootindex=0 \
		-drive file=result-disk/NorTK-OS.x86_64-$(version).install.iso,if=none,id=drive1,media=cdrom,readonly=on \
		-device ide-cd,drive=drive1,bootindex=1 \
		-nic user,hostfwd=tcp::2222-:22 -usb -device usb-tablet -boot menu=on \
		-vga virtio -display sdl,gl=on
	rm -f test-disk.qcow2


test-disk-serial:
	qemu-img create -f qcow2 test-disk.qcow2 20G
	cp /usr/share/edk2/ovmf/OVMF_VARS.fd test-vars.fd
	-qemu-kvm -enable-kvm -machine pc,vmport=off -cpu host -smp 4 -m 8192 \
		-drive if=pflash,format=raw,unit=0,file=/usr/share/edk2/ovmf/OVMF_CODE.fd,readonly=on \
		-drive if=pflash,format=raw,unit=1,file=test-vars.fd \
		-drive file=test-disk.qcow2,if=none,id=drive0,format=qcow2 \
		-device virtio-blk-pci,drive=drive0,bootindex=0 \
		-drive file=result-disk/NorTK-OS.x86_64-$(version).install.iso,if=none,id=drive1,media=cdrom,readonly=on \
		-device ide-cd,drive=drive1,bootindex=1 \
		-nic user,hostfwd=tcp::2222-:22 -usb -device usb-tablet -boot menu=on \
		-nographic -serial mon:stdio

clean:
	rm -fr result-live/build/image-root*
	rm -f result-live/NorTK-OS*
	rm -fr result-disk/build/image-root*
	rm -f result-disk/NorTK-OS*
	rm -f *.qcow2 test-vars.fd
	rm -f config-cdroot.tar.zst

distclean:
	rm -fr result-*


theme-preview:
	grub2-theme-preview --resolution 1920x1080 $(CURDIR)/$(theme_path)
