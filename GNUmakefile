.PHONY: build-live build-disk clean distclean test-live test-disk
version=0.1.0

build-live:
	-setenforce 0
	kiwi-ng --profile=Live system build --description=. --target-dir=result-live/
	-setenforce 1

build-disk:
	-setenforce 0
	kiwi-ng --profile=Disk system build --description=. --target-dir=result-disk/
	-setenforce 1

test-live:
	qemu-kvm -enable-kvm -machine pc,vmport=off -cpu host -smp 4 -m 8192 -bios /usr/share/edk2/ovmf/OVMF_CODE.fd -drive file=result-live/NorTK-OS.x86_64-$(version).iso,media=cdrom -nic user,hostfwd=tcp::2222-:22 -usb -device usb-tablet

test-disk:
	qemu-img create -f qcow2 test-disk.qcow2 20G
	-qemu-kvm -enable-kvm -machine pc,vmport=off -cpu host -smp 4 -m 8192 -bios /usr/share/edk2/ovmf/OVMF_CODE.fd -drive file=test-disk.qcow2,format=qcow2 -drive file=result-disk/NorTK-OS.x86_64-$(version).install.iso,media=cdrom -nic user,hostfwd=tcp::2222-:22 -usb -device usb-tablet
	rm -f test-disk.qcow2

clean:
	sudo rm -fr result-live/build/image-root*
	sudo rm -f result-live/NorTK-OS*
	sudo rm -fr result-disk/build/image-root*
	sudo rm -f result-disk/NorTK-OS*
	rm -f *.qcow2

distclean:
	sudo rm -fr result-*
