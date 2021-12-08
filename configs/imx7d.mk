# SPDX-License-Identifier: Apache-2.0

SOC        := imx7d
KERNEL_ITB := $(SOC)-moxa-uc-8200

include configs/common.mk

UC8200_DTB := $(SOC)-moxa-uc-8210 $(SOC)-moxa-uc-8220

KERNEL_DTBS := $(UC8200_DTB)
