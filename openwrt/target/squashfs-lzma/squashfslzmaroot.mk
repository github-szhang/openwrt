#############################################################
#
# squashfs target 
# 
#############################################################

SQUASHFSLZMA_DIR=$(BUILD_DIR)/squashfs2.1-r2
SQUASHFSLZMA_SOURCE=squashfs2.1-r2.tar.gz
SQUASHFSLZMA_SITE=http://mesh.dl.sourceforge.net/sourceforge/squashfs/

$(DL_DIR)/$(SQUASHFSLZMA_SOURCE):
	$(SCRIPT_DIR)/download.pl $(DL_DIR) $(SQUASHFSLZMA_SOURCE) x $(SQUASHFSLZMA_SITE)

$(SQUASHFSLZMA_DIR)/.unpacked: $(DL_DIR)/$(SQUASHFSLZMA_SOURCE) 
	zcat $(DL_DIR)/$(SQUASHFSLZMA_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	patch -d $(SQUASHFSLZMA_DIR) -p1 < squashfs2.0-tools-lzma.patch
	touch $(SQUASHFSLZMA_DIR)/.unpacked

$(SQUASHFSLZMA_DIR)/squashfs-tools/mksquashfs: $(SQUASHFSLZMA_DIR)/.unpacked
	$(MAKE) -C $(SQUASHFSLZMA_DIR)/squashfs-tools mksquashfs-lzma LZMAPATH=$(BUILD_DIR)/lzma

squashfslzma: $(SQUASHFSLZMA_DIR)/squashfs-tools/mksquashfs
	
squashfslzma-source: $(DL_DIR)/$(SQUASHFSLZMA_SOURCE)

squashfslzma-clean:
	-$(MAKE) -C $(SQUASHFSLZMA_DIR)/squashfs-tools clean

squashfslzma-dirclean:
	rm -rf $(SQUASHFSLZMA_DIR)


#############################################################
#
# Build the squashfs root filesystem image
#
#############################################################

squashfslzmaroot-source: squashfslzma-source

squashfslzmaroot-dirclean:
	rm -rf $(SQUASHFSLZMA_DIR)
