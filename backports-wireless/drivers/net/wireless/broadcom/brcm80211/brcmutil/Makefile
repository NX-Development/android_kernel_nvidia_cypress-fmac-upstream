# SPDX-License-Identifier: ISC
#
# Makefile fragment for Broadcom 802.11n Networking Device Driver Utilities
#
# Copyright (c) 2011 Broadcom Corporation
#
ccflags-y :=			    \
	-I$(backport_srctree)/drivers/net/wireless/broadcom/brcm80211/brcmutil \
	-I$(backport_srctree)/drivers/net/wireless/broadcom/brcm80211/include

obj-$(CPTCFG_BRCMUTIL)	+= brcmutil.o
brcmutil-objs	= utils.o d11.o
