# SPDX-License-Identifier: Apache-2.0

LOADADDR  = 0x80080000
MAKEFLAGS += LOADADDR=$(LOADADDR)

SOC        := ls102xa

include configs/common.mk

UC8410A_DTB := ls1021a-moxa-uc-8410a moxa-uc8410a
UC8540_DTB  := ls1021a-moxa-uc-8540
UC8580_DTB  := moxa-uc8580
DA662C_DTB  := ls102xa-moxa-da-662c

KERNEL_DTBS := $(UC8410A_DTB) \
               $(UC8540_DTB) \
               $(UC8580_DTB) \
               $(DA662C_DTB)
