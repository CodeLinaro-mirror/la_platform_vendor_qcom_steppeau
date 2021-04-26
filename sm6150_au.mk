ENABLE_AB ?= true
# Enable AVB 2.0
BOARD_AVB_ENABLE := true
TARGET_BOARD_AUTO := true
TARGET_USES_AOSP := true
TARGET_USES_AOSP_FOR_AUDIO := false
TARGET_USES_QCOM_BSP := false
TARGET_NO_TELEPHONY := true
TARGET_NO_QC_PARSER := true
TARGET_NO_QTI_MPGEN := true
TARGET_USES_QTIC := false
TARGET_USES_QTIC_EXTENSION := false
ENABLE_HYP := false
BOARD_HAS_QCOM_WLAN := true
TARGET_NO_QTI_WFD := true
BOARD_HAVE_QCOM_FM := false
TARGET_DISABLE_PERF_OPTIMIATIONS := true
BOARD_VENDOR_QCOM_LOC_PDK_FEATURE_SET := false
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true
TARGET_USES_AOSP_FOR_WLAN := false
ENABLE_CAR_POWER_MANAGER := true
ENABLE_MODEM_DATA := true
TARGET_USES_GAS := true
TARGET_FWK_SUPPORTS_AV_VALUEADDS := true
TARGET_LINUX_BOOT_CPU_SELECTION := true
export TARGET_LINUX_BOOT_CPU_ID := 7

BOARD_USES_EARLY_SERVICESIMAGE := true

# Dynamic-partition enabled by default
BOARD_DYNAMIC_PARTITION_ENABLE := true
ifeq ($(strip $(BOARD_DYNAMIC_PARTITION_ENABLE)),true)
  PRODUCT_USE_DYNAMIC_PARTITIONS := true
  BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := true
  PRODUCT_BUILD_SUPER_PARTITION := true
  PRODUCT_BUILD_RAMDISK_IMAGE := true
  PRODUCT_PACKAGES += fastbootd

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

  ifeq ($(ENABLE_AB), true)
    PRODUCT_COPY_FILES += $(LOCAL_PATH)/fstab_AB_dynamic_partition_variant.qti:$(TARGET_COPY_OUT_RAMDISK)/fstab.qcom
  else
    PRODUCT_COPY_FILES += $(LOCAL_PATH)/fstab_non_AB_dynamic_partition_variant.qti:$(TARGET_COPY_OUT_RAMDISK)/fstab.qcom
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

TARGET_KERNEL_VERSION := 4.14

#Enable llvm support for kernel
KERNEL_LLVM_SUPPORT := true

PRODUCT_SHIPPING_API_LEVEL := 29

#Enable sd-llvm suppport for kernel
KERNEL_SD_LLVM_SUPPORT := false

# default is nosdcard, S/W button enabled in resource
PRODUCT_CHARACTERISTICS := nosdcard

BOARD_FRP_PARTITION_NAME := frp

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android

-include $(QCPATH)/common/config/qtic-config.mk

$(warning ****** MSMSTEPPE code name is: $(MSMSTEPPE))
# Video seccomp policy files
#PRODUCT_COPY_FILES += \
#    device/qcom/$(MSMSTEPPE)/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
#    device/qcom/$(MSMSTEPPE)/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

PRODUCT_BOOT_JARS += tcmiface
PRODUCT_BOOT_JARS += telephony-ext
PRODUCT_PACKAGES += telephony-ext



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

#Audio sample file for early services
PRODUCT_COPY_FILES += device/qcom/$(MSMSTEPPE)_au/bike_bell.wav:$(TARGET_COPY_OUT_VENDOR)/etc/bike_bell.wav

PRODUCT_COPY_FILES += hardware/qcom/media/conf_files/msmnile/system_properties.xml:$(TARGET_COPY_OUT_VENDOR)/etc/system_properties.xml

PRODUCT_PACKAGES += android.hardware.media.omx@1.0-impl

# Audio configuration file
-include $(TOPDIR)vendor/qcom/opensource/audio-hal/primary-hal/configs/msmsteppe_au/msmsteppe_au.mk

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
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-service \
    android.hardware.boot@1.0-impl-wrapper.recovery

PRODUCT_HOST_PACKAGES += \
	brillo_update_payload

#Boot control HAL test app
PRODUCT_PACKAGES_DEBUG += bootctl

PRODUCT_STATIC_BOOT_CONTROL_HAL := \
    bootctrl.$(MSMSTEPPE) \
    librecovery_updater_msm \
    libz \
    libcutils

endif

#Healthd packages
PRODUCT_PACKAGES += \
    libhealthd.msm

# MTMD enablement
PRODUCT_COPY_FILES += \
    device/qcom/sm6150_au/input-port-associations.xml:$(TARGET_COPY_OUT_VENDOR)/etc/input-port-associations.xml


DEVICE_MANIFEST_FILE := device/qcom/sm6150_au/manifest.xml
DEVICE_MATRIX_FILE   := device/qcom/common/compatibility_matrix.xml
DEVICE_FRAMEWORK_MANIFEST_FILE := device/qcom/sm6150_au/framework_manifest.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := vendor/qcom/opensource/core-utils/vendor_framework_compatibility_matrix.xml


#ANT+ stack
PRODUCT_PACKAGES += \
    AntHalService \
    libantradio \
    antradio_app \
    libvolumelistener

# Display/Graphics
PRODUCT_PACKAGES += \
    android.hardware.configstore@1.2-service \
    android.hardware.broadcastradio@1.0-impl

# FBE support
PRODUCT_COPY_FILES += \
    device/qcom/$(MSMSTEPPE)_au/init.qti.qseecomd.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qti.qseecomd.sh

# MSM IRQ Balancer configuration file
PRODUCT_COPY_FILES += device/qcom/$(MSMSTEPPE)/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf



# Context hub HAL
PRODUCT_PACKAGES += \
    android.hardware.contexthub@1.0-impl.generic \
    android.hardware.contexthub@1.0-service

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

# OEM unlock feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.carrierlock.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.carrierlock.xml

# USB default HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

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

KMGK_USE_QTI_SERVICE := true

#Enable KEYMASTER 4.0
ENABLE_KM_4_0 := true

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
TARGET_WLAN_CHIP := qca6174 qca6390 qcn7605
include device/qcom/wlan/$(PRODUCT_NAME)/wlan.mk

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
#Thermal
PRODUCT_PACKAGES += android.hardware.thermal@1.0-impl \
                    android.hardware.thermal@1.0-service

#add for camera
ENABLE_V4L2_CAMERA := true
ifeq ($(ENABLE_V4L2_CAMERA), true)
PRODUCT_PACKAGES += v4l2loopback.ko

# Camera configuration file. Shared by passthrough/binderized camera HAL
PRODUCT_PACKAGES += camera.device@1.0-impl
PRODUCT_PACKAGES += camera.device@3.2-impl
PRODUCT_PACKAGES += camera.device@3.3-impl
PRODUCT_PACKAGES += camera.device@3.4-impl
PRODUCT_PACKAGES += camera.device@3.4-external-impl
PRODUCT_PACKAGES += camera.device@3.5-impl
PRODUCT_PACKAGES += camera.device@3.5-external-impl
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-external
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-legacy
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-impl
# Enable binderized camera HAL
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-service

USE_CAMERA_V4L2_AUTO_HAL := true
PRODUCT_PROPERTY_OVERRIDES += ro.hardware.camera=v4l2
PRODUCT_PACKAGES += camera.v4l2
PRODUCT_PACKAGES += ais_v4l2loopback_config.xml
PRODUCT_PACKAGES += ais_v4l2_proxy
endif

TARGET_MOUNT_POINTS_SYMLINKS := false

#To fix CtsPermission2TestCases
PRODUCT_PROPERTY_OVERRIDES += ro.control_privapp_permissions=enforce

###################################################################################
# This is the End of target.mk file.
# Now, Pickup other split product.mk files:
###################################################################################
# TODO: Relocate the system product.mk files pickup into qssi lunch, once it is up.
$(call inherit-product-if-exists, vendor/qcom/defs/product-defs/system/*.mk)
$(call inherit-product-if-exists, vendor/qcom/defs/product-defs/vendor/*.mk)
###################################################################################
