MSMSTEPPE = sm6150
TARGET_BOARD_PLATFORM := $(MSMSTEPPE)
TARGET_BOOTLOADER_BOARD_NAME := $(MSMSTEPPE)
TARGET_BOARD_TYPE := auto
TARGET_BOARD_SUFFIX := _au
PRODUCT_MANUFACTURER := QTI
PRODUCT_DEVICE := sm6150_au

PRODUCT_VENDOR_PROPERTIES += \
    ro.soc.manufacturer=$(PRODUCT_MANUFACTURER) \
    ro.soc.model=$(PRODUCT_DEVICE)

ALLOW_MISSING_DEPENDENCIES := true
ENABLE_AB ?= true
# Enable virtual-ab by default
ifeq ($(ENABLE_AB), true)
  ENABLE_VIRTUAL_AB ?= true
endif
ifeq ($(ENABLE_VIRTUAL_AB), true)
  $(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
endif

# Enable AVB 2.0
BOARD_AVB_ENABLE := true
BOARD_USES_QCNE := false
TARGET_BOARD_AUTO := true
TARGET_USES_AOSP := true
TARGET_USES_QCOM_BSP := false
TARGET_NO_TELEPHONY := true
TARGET_USES_QTIC := false
TARGET_USES_QTIC_EXTENSION := false
ENABLE_HYP := false
BOARD_HAS_QCOM_WLAN := true
TARGET_NO_QTI_WFD := true
BOARD_HAVE_QCOM_FM := false
TARGET_LINUX_BOOT_CPU_SELECTION := true
TARGET_LINUX_BOOT_CPU_ID := 7
BOARD_VENDOR_QCOM_LOC_PDK_FEATURE_SET := false
TARGET_ENABLE_QC_AV_ENHANCEMENTS := false
TARGET_FWK_SUPPORTS_AV_VALUEADDS := true
TARGET_USES_AOSP_FOR_WLAN := true
ENABLE_CAR_POWER_MANAGER := true
#TARGET_USES_GAS := true


# Dynamic-partition enabled by default
BOARD_DYNAMIC_PARTITION_ENABLE := true
ifeq ($(strip $(BOARD_DYNAMIC_PARTITION_ENABLE)),true)
  PRODUCT_USE_DYNAMIC_PARTITIONS := true
  BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := true
  PRODUCT_BUILD_SUPER_PARTITION := true
  PRODUCT_PACKAGES += fastbootd
  TARGET_HIBERNATION_SECURE_ENABLE := true
  # Enable System_ext
  PRODUCT_BUILD_SYSTEM_EXT_IMAGE := true
# Mismatch in the uses-library tags between build system and the manifest leads
# to soong APK manifest_check tool errors. Enable the flag to fix this.
  RELAX_USES_LIBRARY_CHECK := true

  BOARD_AVB_VBMETA_SYSTEM := system
  BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
  BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
  BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
  BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

  PRODUCT_BUILD_SYSTEM_OTHER_IMAGE := false
  PRODUCT_BUILD_PRODUCT_IMAGE := false
  PRODUCT_BUILD_PRODUCT_SERVICES_IMAGE := false
  PRODUCT_BUILD_CACHE_IMAGE := false
  PRODUCT_BUILD_RAMDISK_IMAGE := true
  PRODUCT_BUILD_USERDATA_IMAGE := true
# Enable boot-debug.img
  PRODUCT_BUILD_DEBUG_BOOT_IMAGE := true

  ifeq ($(ENABLE_AB), true)
    PRODUCT_COPY_FILES += $(LOCAL_PATH)/default/fstab_AB_dynamic_partition_variant.qti:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.default
    PRODUCT_COPY_FILES += $(LOCAL_PATH)/emmc/fstab_AB_dynamic_partition_variant.qti:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.emmc
  else
    PRODUCT_COPY_FILES += $(LOCAL_PATH)/default/fstab_non_AB_dynamic_partition_variant.qti:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.default
    PRODUCT_COPY_FILES += $(LOCAL_PATH)/emmc/fstab_non_AB_dynamic_partition_variant.qti:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.emmc
  endif
endif #BOARD_DYNAMIC_PARTITION_ENABLE

TARGET_DEFINES_DALVIK_HEAP := true
$(call inherit-product, device/qcom/common/common64.mk)
#Inherit all except heap growth limit from phone-xhdpi-2048-dalvik-heap.mk
PRODUCT_PROPERTY_OVERRIDES  += \
	dalvik.vm.heapstartsize=8m \
	dalvik.vm.heapsize=512m \
	dalvik.vm.heaptargetutilization=0.75 \
	dalvik.vm.heapminfree=512k \
	dalvik.vm.heapmaxfree=8m
$(call inherit-product, packages/services/Car/car_product/build/car.mk)

MSMSTEPPE = sm6150
PRODUCT_NAME := $(MSMSTEPPE)_au
PRODUCT_DEVICE := $(MSMSTEPPE)_au
PRODUCT_BRAND := qti
PRODUCT_MODEL := $(MSMSTEPPE)_au for arm64

#Initial bringup flags

#Default vendor image configuration
ifeq ($(ENABLE_VENDOR_IMAGE),)
ENABLE_VENDOR_IMAGE := false
endif

TARGET_KERNEL_VERSION := 5.4
TARGET_HAS_GENERIC_KERNEL_HEADERS := true

#Enable llvm support for kernel
KERNEL_LLVM_SUPPORT := true

#Enable sd-llvm suppport for kernel
KERNEL_SD_LLVM_SUPPORT := false

# default is nosdcard, S/W button enabled in resource
PRODUCT_CHARACTERISTICS := nosdcard

BOARD_FRP_PARTITION_NAME := frp

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android

# diag-router
ifneq ($(TARGET_BUILD_VARIANT),user)
TARGET_HAS_DIAG_ROUTER := true
endif


# Memtrack HAL deprecated. Replaced with AIDL for target-level 6.
ENABLE_MEMTRACK_AIDL_HAL := true

-include $(QCPATH)/common/config/qtic-config.mk

$(warning ****** MSMSTEPPE code name is: $(MSMSTEPPE))
# Video seccomp policy files
#PRODUCT_COPY_FILES += \
#    device/qcom/$(MSMSTEPPE)/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
#    device/qcom/$(MSMSTEPPE)/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

PRODUCT_BOOT_JARS += tcmiface

ifneq ($(TARGET_NO_TELEPHONY), true)
PRODUCT_BOOT_JARS += telephony-ext
PRODUCT_PACKAGES += telephony-ext
endif



TARGET_DISABLE_DASH := true
TARGET_DISABLE_QTI_VPP := false

ifneq ($(TARGET_DISABLE_DASH), true)
    PRODUCT_BOOT_JARS += qcmediaplayer
endif

ifeq ($(TARGET_NO_QTI_WFD),)
    PRODUCT_BOOT_JARS += WfdCommon
endif

# Ethernet configuration file
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml

# Copy the testscripts from the qssi folder as it was moved to QSSI folder.
PRODUCT_COPY_FILES += \
    device/qcom/qssi/init.qcom.testscripts.sh:system/etc/init.qcom.testscripts.sh

# Video codec configuration files
ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS), true)
PRODUCT_COPY_FILES += device/qcom/$(MSMSTEPPE)/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_vendor.xml

PRODUCT_COPY_FILES += device/qcom/$(MSMSTEPPE)/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml
PRODUCT_COPY_FILES += device/qcom/$(MSMSTEPPE)/media_codecs_vendor.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_vendor.xml
PRODUCT_COPY_FILES += device/qcom/$(MSMSTEPPE)/media_codecs_vendor_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_vendor_audio.xml

PRODUCT_COPY_FILES += device/qcom/$(MSMSTEPPE)/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml
endif #TARGET_ENABLE_QC_AV_ENHANCEMENTS

#PRODUCT_COPY_FILES += hardware/qcom/media/conf_files/msmnile/system_properties.xml:$(TARGET_COPY_OUT_VENDOR)/etc/system_properties.xml

#Hibernation Script
PRODUCT_COPY_FILES += device/qcom/$(MSMSTEPPE)_au/hiber.sh:$(TARGET_COPY_OUT_VENDOR)/bin/hiber.sh

PRODUCT_COPY_FILES += hardware/interfaces/security/keymint/aidl/default/android.hardware.hardware_keystore.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.hardware_keystore.xml
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml
PRODUCT_PACKAGES += android.hardware.media.omx@1.0-impl

#Audio DLKM
AUDIO_DLKM := audio_apr.ko
AUDIO_DLKM += audio_snd_event.ko
AUDIO_DLKM += audio_q6_notifier.ko
AUDIO_DLKM += audio_adsp_loader.ko
AUDIO_DLKM += audio_q6.ko
AUDIO_DLKM += audio_platform.ko
AUDIO_DLKM += audio_hdmi.ko
AUDIO_DLKM += audio_stub.ko
AUDIO_DLKM += audio_native.ko
AUDIO_DLKM += audio_machine_talos.ko
PRODUCT_PACKAGES += $(AUDIO_DLKM)

PCIE_DLKM := pci_msm_drv
PRODUCT_PACKAGES += $(PCIE_DLKM)

CNSS_DLKM := cnss2
PRODUCT_PACKAGES += $(CNSS_DLKM)

# HS-I2S DLKM
PRODUCT_PACKAGES += hsi2s.ko
# HS-I2S test app
PRODUCT_PACKAGES += hsi2s_test

PRODUCT_PACKAGES += fs_config_files

ifeq ($(ENABLE_AB), true)
#A/B related packages
PRODUCT_PACKAGES += update_engine \
    update_engine_client \
    update_verifier \
    bootctrl.$(MSMSTEPPE) \
    android.hardware.boot@1.2-impl-qti \
    android.hardware.boot@1.2-impl-qti.recovery \
    android.hardware.boot@1.2-service

PRODUCT_PACKAGES += \
    update_engine_sideload

PRODUCT_HOST_PACKAGES += \
	brillo_update_payload

#Boot control HAL test app
PRODUCT_PACKAGES_DEBUG += bootctl
endif

#Healthd packages
PRODUCT_PACKAGES += \
    libhealthd.msm

# MTMD enablement
PRODUCT_COPY_FILES += \
    device/qcom/sm6150_au/input-port-associations.xml:$(TARGET_COPY_OUT_VENDOR)/etc/input-port-associations.xml \
    device/qcom/sm6150_au/display_settings.xml:$(TARGET_COPY_OUT_VENDOR)/etc/display_settings.xml


DEVICE_MANIFEST_FILE := device/qcom/sm6150_au/manifest.xml
DEVICE_MATRIX_FILE   := device/qcom/common/compatibility_matrix.xml
DEVICE_FRAMEWORK_MANIFEST_FILE := device/qcom/msmnile_au/framework_manifest.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := vendor/qcom/opensource/core-utils/vendor_framework_compatibility_matrix.xml

# Enable Scoped Storage related
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

PRODUCT_LOCALES := \
en_US

#ANT+ stack
#PRODUCT_PACKAGES += \
#    AntHalService \
#    libantradio \
#    antradio_app \
#    libvolumelistener

# Automotive display service
PRODUCT_PACKAGES += android.frameworks.automotive.display@1.0-service

PRODUCT_ENFORCE_RRO_TARGETS := framework-res

# FBE support
PRODUCT_COPY_FILES += \
    device/qcom/$(MSMSTEPPE)_au/init.qti.qseecomd.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qti.qseecomd.sh

# HS-I2S support
PRODUCT_COPY_FILES += \
    device/qcom/$(MSMSTEPPE)_au/hsi2s_early_boot.sh:$(TARGET_COPY_OUT_VENDOR)/bin/hsi2s_early_boot.sh

# MSM IRQ Balancer configuration file
PRODUCT_COPY_FILES += device/qcom/$(MSMSTEPPE)/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf





# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

# OEM unlock feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.carrierlock.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.carrierlock.xml


PRODUCT_PACKAGES += \
       openavb_harness \
       gptp \
       mrpd

# Kernel modules install path
KERNEL_MODULES_INSTALL := dlkm
KERNEL_MODULES_OUT := out/target/product/sm6150_au/$(KERNEL_MODULES_INSTALL)/lib/modules

#FEATURE_OPENGLES_EXTENSION_PACK support string config file
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml

#Exclude vibrator from InputManager
#PRODUCT_COPY_FILES += \
#    device/qcom/$(MSMSTEPPE)/excluded-input-devices.xml:system/etc/excluded-input-devices.xml

#Enable full treble flag
PRODUCT_FULL_TREBLE_OVERRIDE := true
PRODUCT_VENDOR_MOVE_ENABLED := true
PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE := true

#Enable vndk-sp Libraries
PRODUCT_PACKAGES += vndk_package

DEVICE_PACKAGE_OVERLAYS += device/qcom/msmnile_au/overlay

# Enable flag to support slow devices
TARGET_PRESIL_SLOW_BOARD := true

ENABLE_VENDOR_RIL_SERVICE := true

#----------------------------------------------------------------------
# wlan specific
#----------------------------------------------------------------------
# Multiple chips
ifeq ($(strip $(BOARD_HAS_QCOM_WLAN)),true)
TARGET_WLAN_CHIP := qca6174 qca6390 qcn7605
include device/qcom/wlan/sm6150_au/wlan.mk
endif

#for Emac
PRODUCT_PACKAGES += emac_rps_settings.sh

# CAN utils
PRODUCT_PACKAGES += candump \
                    cansend \
                    bcmserver \
                    can-calc-bit-timing \
                    canbusload \
                    canfdtest \
                    cangen \
                    cangw \
                    canlogserver \
                    canplayer \
                    cansniffer \
                    isotpdump \
                    isotprecv \
                    isotpsend \
                    isotpserver \
                    isotptun \
                    log2asc \
                    log2long \
                    slcan_attach \
                    slcand \
                    slcanpty

# Vehicle Networks
PRODUCT_PACKAGES += canflasher \
                    mpc5746c_firmware_A.bin \
                    mpc5746c_firmware_B.bin \
                    vendor.qti.hardware.automotive.vehicle@1.0-service \
                    android.hardware.automotive.vehicle@2.0-manager-lib-shared

PRODUCT_PACKAGES += android.hardware.dumpstate@1.1-service.example

PRODUCT_PACKAGES += android.hardware.health@2.1-service \
                    android.hardware.health@2.1-impl \

#sysprofiler
PRODUCT_PACKAGES += libsysprofiler \
                    sysprofiler_app \
                    sysprofiler_interface
#add vndservicemanager for surfaceflinger crash
PRODUCT_PACKAGES += vndservicemanager
TARGET_MOUNT_POINTS_SYMLINKS := false

#add libnbaio for avenhancement
PRODUCT_PACKAGES += libnbaio

PRODUCT_PACKAGES += qcar-gsi.avbpubkey
SHIPPING_API_LEVEL := 32
PRODUCT_SHIPPING_API_LEVEL := 32

PRODUCT_PACKAGES += android.hardware.neuralnetworks@1.0.vendor \
                    android.hardware.neuralnetworks@1.1.vendor \
                    android.hardware.neuralnetworks@1.2.vendor \
                    android.hardware.neuralnetworks@1.3.vendor

###################################################################################
# This is the End of target.mk file.
# Now, Pickup other split product.mk files:
###################################################################################
# TODO: Relocate the system product.mk files pickup into qssi lunch, once it is up.
$(call inherit-product-if-exists, vendor/qcom/defs/product-defs/system/*.mk)
$(call inherit-product-if-exists, vendor/qcom/defs/product-defs/vendor/*.mk)
###################################################################################
