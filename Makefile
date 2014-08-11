ROOTFS = build/root

all: $(ROOTFS)

submit: $(ROOTFS)
	sudo -E solvent submitproduct rootfs $<

approve: $(ROOTFS)
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
	mkdir $(ROOTFS).tmp/tmp/install-laptop
	cp -a ../inaugurator ../install-laptop ../osmosis ../rackattack-api ../rackattack-virtual ../solvent ../upseto ../yumcache $(ROOTFS).tmp/tmp/install-laptop
	find $(ROOTFS).tmp/tmp/install-laptop -name "*.dep" | xargs rm -fr
	sudo ./chroot.sh $(ROOTFS).tmp sh -c "cd /tmp/install-laptop/install-laptop && make install_here"
	sudo rm -fr $(ROOTFS).tmp/tmp/* $(ROOTFS).tmp/var/tmp/*
	echo "Done"
	sudo mv $(ROOTFS).tmp $(ROOTFS)
