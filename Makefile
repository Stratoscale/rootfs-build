ROOTFS = build/root

all: $(ROOTFS)

submit:
	sudo -E solvent submitproduct rootfs $(ROOTFS)

approve:
	sudo -E solvent approve --product=rootfs

clean:
	sudo rm -fr build

prepareForCleanBuild:
	cd ../install-laptop/build/install-laptop && ./install.sh

$(ROOTFS): Makefile solvent.manifest
	echo "Bringing source"
	-sudo mv $(ROOTFS)/ $(ROOTFS).tmp/
	-mkdir $(@D)
	sudo solvent bring --repositoryBasename=rootfs-build-nostrato --product=rootfs --destination=$(ROOTFS).tmp
	echo "Installing strato packages"
	sudo tar -xf ../install-laptop/build/installer/install-laptop.tgz -C $(ROOTFS).tmp/tmp
	sudo ./chroot.sh $(ROOTFS).tmp sh -c "cd /tmp/install-laptop && ./install.sh"
	sudo rm -fr $(ROOTFS).tmp/tmp/* $(ROOTFS).tmp/var/tmp/*
	echo "Done"
	sudo mv $(ROOTFS).tmp $(ROOTFS)
