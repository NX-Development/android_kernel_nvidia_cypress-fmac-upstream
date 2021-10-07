LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_PREBUILT_KERNEL),)
CYPRESS-FMAC-UPSTREAM_PATH := kernel/nvidia/cypress-fmac-upstream

include $(CLEAR_VARS)

LOCAL_MODULE        := cypress-fmac-upstream
LOCAL_MODULE_SUFFIX := .ko
LOCAL_MODULE_CLASS  := ETC
LOCAL_MODULE_PATH   := $(TARGET_OUT_VENDOR)/lib/modules/cypress-fmac-upstream

_fmac_upstream_intermediates := $(call intermediates-dir-for,$(LOCAL_MODULE_CLASS),$(LOCAL_MODULE))
_fmac_upstream_ko := $(_fmac_upstream_intermediates)/$(LOCAL_MODULE)$(LOCAL_MODULE_SUFFIX)
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
KERNEL_OUT_RELATIVE := ../../KERNEL_OBJ

$(_fmac_upstream_ko): $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/$(BOARD_KERNEL_IMAGE_NAME)
	@mkdir -p $(dir $@)
	@mkdir -p $(KERNEL_MODULES_OUT)/lib/modules/cypress-fmac-upstream
	@cp -R $(CYPRESS-FMAC-UPSTREAM_PATH)/backports-wireless/* $(_fmac_upstream_intermediates)/
	$(hide) +$(PATH_OVERRIDE) $(KERNEL_MAKE_CMD) $(KERNEL_MAKE_FLAGS) -C $(_fmac_upstream_intermediates) ARCH=arm64 $(KERNEL_CROSS_COMPILE) $(KERNEL_CC) $(KERNEL_LD) KLIB=$(KERNEL_MODULES_OUT)/lib/modules KLIB_BUILD=$(KERNEL_OUT_RELATIVE) defconfig-brcmfmac
	$(hide) +$(PATH_OVERRIDE) $(KERNEL_MAKE_CMD) $(KERNEL_MAKE_FLAGS) -C $(_fmac_upstream_intermediates) ARCH=arm64 $(KERNEL_CROSS_COMPILE) $(KERNEL_CC) $(KERNEL_LD) KLIB=$(KERNEL_MODULES_OUT)/lib/modules KLIB_BUILD=$(KERNEL_OUT_RELATIVE) modules
	modules=$$(find $(_fmac_upstream_intermediates) -type f -name '*.ko'); \
	for f in $$modules; do \
		$(KERNEL_TOOLCHAIN_PATH)strip --strip-unneeded $$f; \
		cp $$f $(KERNEL_MODULES_OUT)/lib/modules/cypress-fmac-upstream; \
	done;
	touch $(_fmac_upstream_intermediates)/cypress-fmac-upstream.ko

include $(BUILD_SYSTEM)/base_rules.mk
endif
