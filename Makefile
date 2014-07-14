ROOTFS = build/root

all: $(ROOTFS)

submit: $(ROOTFS)
	sudo -E solvent submitproduct rootfs $<

approve: $(ROOTFS)
	sudo -E solvent approve --product=rootfs

clean:
	sudo rm -fr build

$(ROOTFS): Makefile solvent.manifest
	echo "Bringing source"
	-sudo mv $(ROOTFS)/ $(ROOTFS).tmp/
	-mkdir $(@D)
	sudo solvent bring --repositoryBasename=rootfs-build-nostrato --product=rootfs --destination=$(ROOTFS).tmp
	echo "Installing strato packages"
	mkdir $(ROOTFS).tmp/tmp/install-laptop
	cp -a ../inaugurator ../install-laptop ../osmosis ../rackattack-api ../rackattack-virtual ../solvent ../upseto ../yumcache $(ROOTFS).tmp/tmp/install-laptop
	find $(ROOTFS).tmp/tmp/install-laptop -name "*.dep" | xargs rm -fr
	sudo chroot $(ROOTFS).tmp sh -c "cd /tmp/install-laptop/install-laptop && make install_here"
	rm -fr $(ROOTFS).tmp/tmp/install_laptop
	echo "Done"
	sudo mv $(ROOTFS).tmp $(ROOTFS)
