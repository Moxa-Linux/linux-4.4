# SPDX-License-Identifier: Apache-2.0

default: build_itb build_modules build_headers build_kbuild

# Prepare kernel information
prepare:
	@$(MAKE) M=scripts clean
	@$(MAKE) $(KERNEL_DEFCONFIG)
	@$(MAKE) $@
	@$(MAKE) M=scripts

# Build uImage, zImage, device-trees, itbs

build_zImage: prepare
	@$(MAKE) -j $(shell nproc) zImage

ifneq (,$(LOADADDR))
build_uImage: prepare
	@$(MAKE) -j $(shell nproc) uImage
else
build_uImage: ;
endif

build_dtb: prepare
ifneq (,$(KERNEL_DTBS))
	@$(foreach var,$(KERNEL_DTBS),$(MAKE) $(var).dtb;)
else
	@$(MAKE) dtbs
endif

build_itb: prepare build_dtb build_zImage build_uImage
ifneq (,$(KERNEL_ITB))
	@mkdir -p $(ITBS_OUTPUT_DIR)
	@$(foreach var,$(KERNEL_ITB),./its/$(var);)
	@$(foreach var,$(KERNEL_ITB),cp -a its/$(var).itb $(ITBS_OUTPUT_DIR)/$(var).itb;)
endif

# Strip & install kernel modules
build_modules: prepare
	@mkdir -p $(MODULES_OUTPUT_DIR)
	@$(MAKE) -j $(shell nproc) modules
	@$(MAKE) modules_install \
		INSTALL_MOD_STRIP=1 \
		INSTALL_MOD_PATH=$(MODULES_OUTPUT_DIR)
	@find $(MODULES_OUTPUT_DIR) -type l -exec rm -f {} +

# Copy files needed to kernel header package directory
# TODO
# Turn into Makefile style
build_headers:
	@( \
		echo ".config"; \
		echo "Makefile"; \
		echo "Module.symvers"; \
		echo "arch/arm/Makefile"; \
		echo "arch/arm/kernel/module.lds"; \
		echo "include/config/auto.conf"; \
		echo "include/config/kernel.release"; \
		find arch/arm/ include/ -name "*.h" -o -name "Kbuild" -o -name "*.S"; \
	) | cpio -dump $(HEADERS_OUTPUT_DIR)

# Create kbuild tools
build_kbuild: zconf $(SCRIPTS_FILES_DST)
ifeq ($(DEB_HOST_ARCH), armhf)
	@$(MAKE) M=scripts/kconfig clean
	@$(MAKE) CC=$(CROSS_COMPILE)gcc HOSTCC=$(CROSS_COMPILE)gcc $(KERNEL_DEFCONFIG)
	@$(MAKE) CC=$(CROSS_COMPILE)gcc HOSTCC=$(CROSS_COMPILE)gcc prepare
	@$(MAKE) CC=$(CROSS_COMPILE)gcc HOSTCC=$(CROSS_COMPILE)gcc M=scripts
	$(eval CFLAGS += -Wall)
	$(eval CPPFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64)
endif
	@install -D scripts/basic/bin2c $(SCRIPTS_OUTPUT_DIR)/basic/bin2c
	@install -D scripts/basic/fixdep $(SCRIPTS_OUTPUT_DIR)/basic/fixdep
	@install -D scripts/conmakehash $(SCRIPTS_OUTPUT_DIR)/conmakehash
	@install -D scripts/kallsyms $(SCRIPTS_OUTPUT_DIR)/kallsyms
	@install -D scripts/kconfig/conf $(SCRIPTS_OUTPUT_DIR)/kconfig/conf
	@install -D scripts/mod/modpost $(SCRIPTS_OUTPUT_DIR)/mod/modpost
	@$(CROSS_COMPILE)gcc $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) \
		-o $(SCRIPTS_OUTPUT_DIR)/recordmcount \
		scripts/recordmcount.c
	@$(CROSS_COMPILE)gcc $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) \
		-o $(SCRIPTS_OUTPUT_DIR)/unifdef \
		scripts/unifdef.c

$(SCRIPTS_FILES_DST): $(SCRIPTS_OUTPUT_DIR)/%:scripts/%
	@install -D $< $@

zconf:
	@bison -oscripts/kconfig/zconf.tab.c -t -l scripts/kconfig/zconf.y
	@flex -oscripts/kconfig/zconf.lex.c -L scripts/kconfig/zconf.l

clean:
	@rm -rf $(OUTPUT_DIR)
	@$(MAKE) clean

menuconfig: prepare
	@$(MAKE) $@
	@$(MAKE) savedefconfig
	@cp defconfig arch/$(ARCH)/configs/$(KERNEL_DEFCONFIG)
%:
	@$(MAKE) $(MAKECMDGOALS)

.PHONY: build_itb build_modules build_headers build_kbuild
