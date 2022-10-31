LOCAL_PATH := $(call my-dir)

#----------------------------------------------------------------------
# Compile (L)ittle (K)ernel bootloader and the nandwrite utility
#----------------------------------------------------------------------
ifneq ($(strip $(TARGET_NO_BOOTLOADER)),true)

# Compile
include bootable/bootloader/edk2/AndroidBoot.mk

$(INSTALLED_BOOTLOADER_MODULE): $(TARGET_EMMC_BOOTLOADER) | $(ACP)
	$(transform-prebuilt-to-target)
$(BUILT_TARGET_FILES_PACKAGE): $(INSTALLED_BOOTLOADER_MODULE)

droidcore: $(INSTALLED_BOOTLOADER_MODULE)
endif

# Create firmware folder for graphics
$(shell mkdir -p $(TARGET_OUT_VENDOR)/firmware/)


#----------------------------------------------------------------------
# Compile Linux Kernel
#----------------------------------------------------------------------
include device/qcom/kernelscripts/kernel_definitions.mk

#----------------------------------------------------------------------
# Copy additional target-specific files
#----------------------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE       := vold.fstab
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := init.target.rc
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR_ETC)/init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := init.qti.cam.sh
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := init.qti.cam.sh
LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR)/bin
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := gpio-keys.kl
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_OUT_KEYLAYOUT)
include $(BUILD_PREBUILT)

ifeq ($(strip $(BOARD_DYNAMIC_PARTITION_ENABLE)),true)
  include $(CLEAR_VARS)
  LOCAL_MODULE       := fstab.default
  LOCAL_MODULE_TAGS  := optional
  LOCAL_MODULE_CLASS := ETC
  ifeq ($(ENABLE_AB), true)
    LOCAL_SRC_FILES := default/fstab_AB_dynamic_partition_variant.qti
  else
    LOCAL_SRC_FILES := default/fstab_non_AB_dynamic_partition_variant.qti
  endif #ENABLE_AB
  LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR_ETC)
  include $(BUILD_PREBUILT)

  include $(CLEAR_VARS)
  LOCAL_MODULE       := fstab.emmc
  LOCAL_MODULE_TAGS  := optional
  LOCAL_MODULE_CLASS := ETC
  ifeq ($(ENABLE_AB), true)
    LOCAL_SRC_FILES := emmc/fstab_AB_dynamic_partition_variant.qti
  else
    LOCAL_SRC_FILES := emmc/fstab_non_AB_dynamic_partition_variant.qti
  endif #ENABLE_AB
  LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR_ETC)
  include $(BUILD_PREBUILT)
else
  include $(CLEAR_VARS)
  LOCAL_MODULE       := fstab.qcom
  LOCAL_MODULE_TAGS  := optional
  LOCAL_MODULE_CLASS := ETC
  LOCAL_SRC_FILES    := $(LOCAL_MODULE)
  LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR_ETC)
  ifeq ($(ENABLE_VENDOR_IMAGE), true)
    LOCAL_POST_INSTALL_CMD := echo $(VENDOR_FSTAB_ENTRY) >> $(LOCAL_MODULE_PATH)/$(LOCAL_MODULE)
  endif
  include $(BUILD_PREBUILT)
endif #BOARD_DYNAMIC_PARTITION_ENABLE

#----------------------------------------------------------------------
# Radio image
#----------------------------------------------------------------------
ifeq ($(ADD_RADIO_FILES), true)
radio_dir := $(LOCAL_PATH)/radio
RADIO_FILES := $(shell cd $(radio_dir) ; ls)
$(foreach f, $(RADIO_FILES), \
	$(call add-radio-file,radio/$(f)))
endif

#----------------------------------------------------------------------
# extra images
#----------------------------------------------------------------------
include vendor/qcom/opensource/core-utils/build/AndroidBoardCommon.mk

#----------------------------------------------------------------------
# wlan specific
#----------------------------------------------------------------------
ifeq ($(strip $(BOARD_HAS_QCOM_WLAN)),true)
include device/qcom/wlan/$(MSMSTEPPE)_au/AndroidBoardWlan.mk
endif
#----------------------------------------------------------------------
# override default make with prebuilt make path (if any)
#----------------------------------------------------------------------
ifneq (, $(wildcard $(shell pwd)/prebuilts/build-tools/linux-x86/bin/make))
    MAKE := $(shell pwd)/prebuilts/build-tools/linux-x86/bin/$(MAKE)
endif
