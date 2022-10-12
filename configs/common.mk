# SPDX-License-Identifier: Apache-2.0

ARCH ?= arm
MAKEFLAGS += ARCH=$(ARCH)

ifneq (,$(DEB_HOST_GNU_TYPE))
CROSS_COMPILE := $(DEB_HOST_GNU_TYPE)-
else
CROSS_COMPILE ?= arm-linux-gnueabihf-
endif
MAKEFLAGS += CROSS_COMPILE=$(CROSS_COMPILE)

CC ?= $(CROSS_COMPILE)gcc
MAKEFLAGS += CC=$(CC)

MAKEFLAGS += LOCALVERSION=

KERNEL_DEFCONFIG := $(SOC)_defconfig
KERNEL_NAME := 4.4.0-cip-rt-moxa-$(SOC)

OUTPUT_DIR := output
MODULES_OUTPUT_DIR := $(OUTPUT_DIR)/modules
HEADERS_OUTPUT_DIR := $(OUTPUT_DIR)/headers/usr/src/linux-headers-$(KERNEL_NAME)
ITBS_OUTPUT_DIR    := $(OUTPUT_DIR)/itbs

ifneq (,$(DEB_HOST_GNU_TYPE))
SCRIPTS_OUTPUT_DIR :=  $(OUTPUT_DIR)/kbuild/$(DEB_HOST_GNU_TYPE)/scripts
else
SCRIPTS_OUTPUT_DIR :=  $(OUTPUT_DIR)/kbuild/$(CROSS_COMPILE:-=)/scripts
endif

SCRIPTS_FILES_MAKEFILE := \
	Makefile.asm-generic \
	Makefile.build \
	Makefile.clean \
	Makefile.dtbinst \
	Makefile.extrawarn \
	Makefile.headersinst \
	Makefile.help \
	Makefile.host \
	Makefile.kasan \
	Makefile.lib \
	Makefile.modbuiltin \
	Makefile.modinst \
	Makefile.modpost \
	Makefile.modsign \
	Makefile.ubsan

SCRIPTS_FILES_PL := \
	checkincludes.pl \
	checkstack.pl \
	checkversion.pl \
	namespace.pl \
	recordmcount.pl

SCRIPTS_FILES_SH := \
	depmod.sh \
	gcc-goto.sh \
	gcc-version.sh \
	gcc-x86_32-has-stack-protector.sh \
	gcc-x86_64-has-stack-protector.sh \
	gen_initramfs_list.sh \
	headers_install.sh \
	ld-version.sh \
	mkuboot.sh

SCRIPTS_FILES := \
	$(SCRIPTS_FILES_MAKEFILE) \
	$(SCRIPTS_FILES_PL) \
	$(SCRIPTS_FILES_SH) \
	Kbuild.include \
	Lindent \
	kernel-doc \
	makelst \
	mksysmap \
	mkversion \
	module-common.lds \
	patch-kernel \
	setlocalversion \
	ver_linux

SCRIPTS_FILES_DST := $(addprefix $(SCRIPTS_OUTPUT_DIR)/,$(SCRIPTS_FILES))