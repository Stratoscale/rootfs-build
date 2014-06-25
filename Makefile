ROOTFS = build/root

all: $(ROOTFS)

submit: $(ROOTFS)
	sudo solvent submitproduct rootfs $<

clean:
	sudo rm -fr build

$(ROOTFS):
	echo "Bringing source"
	-sudo mv $(ROOTFS)/ $(ROOTFS).tmp/
	-mkdir $(@D)
	sudo solvent bring --repositoryBasename=rootfs-build-nostrato --product=rootfs --destination=$(ROOTFS).tmp
	echo "Installing strato packages"
	cp -a ../upseto ../solvent ../osmosis $(ROOTFS).tmp/tmp
	sudo chroot $(ROOTFS).tmp sh -c "cd /tmp/osmosis; DONT_START_SERVICE=yes make install"
	sudo chroot $(ROOTFS).tmp sh -c "cd /tmp/upseto; make install"
	sudo chroot $(ROOTFS).tmp sh -c "cd /tmp/solvent; make install"
	rm -fr $(ROOTFS).tmp/tmp/upseto
	rm -fr $(ROOTFS).tmp/tmp/solvent
	rm -fr $(ROOTFS).tmp/tmp/osmosis
	echo "Done"
	sudo mv $(ROOTFS).tmp $(ROOTFS)
