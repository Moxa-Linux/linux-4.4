# SPDX-License-Identifier: Apache-2.0

LOADADDR  = 0x80080000
MAKEFLAGS += LOADADDR=$(LOADADDR)

SOC        := am335x
KERNEL_ITB := $(SOC)-moxa-uc-2100 \
	      $(SOC)-moxa-uc-3100 \
	      $(SOC)-moxa-uc-5100 \
	      $(SOC)-moxa-uc-8100a-me

include configs/common.mk

UC2100_DTB	:= $(SOC)-moxa-uc-2101 \
		   $(SOC)-moxa-uc-2102 \
		   $(SOC)-moxa-uc-2104 \
		   $(SOC)-moxa-uc-2111 \
		   $(SOC)-moxa-uc-2112 \
		   $(SOC)-moxa-uc-2114 \
		   $(SOC)-moxa-uc-2116
UC3100_DTB	:= $(SOC)-moxa-uc-3101 \
		   $(SOC)-moxa-uc-3111 \
		   $(SOC)-moxa-uc-3121
UC5100_DTB	:= $(SOC)-moxa-uc-5101 \
		   $(SOC)-moxa-uc-5102 \
		   $(SOC)-moxa-uc-5111 \
		   $(SOC)-moxa-uc-5112
UC8100_DTB	:= $(SOC)-moxa-uc-8100 \
		   $(SOC)-moxa-uc-8100-v2.1 \
		   moxa-uc8100
UC8100_ME_DTB	:= $(SOC)-moxa-uc-8100-me
UC8100A_ME_DTB	:= $(SOC)-moxa-uc-8100a-me

KERNEL_DTBS 	:= $(UC2100_DTB) \
		   $(UC3100_DTB) \
		   $(UC5100_DTB) \
		   $(UC8100_DTB) \
		   $(UC8100_ME_DTB) \
		   $(UC8100A_ME_DTB)
