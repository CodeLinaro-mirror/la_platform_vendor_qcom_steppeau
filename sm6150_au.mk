# Enable AVB 2.0
BOARD_AVB_ENABLE := true
TARGET_BOARD_AUTO := true
TARGET_USES_AOSP := true
TARGET_USES_AOSP_FOR_AUDIO := false
TARGET_USES_QCOM_BSP := false
TARGET_NO_TELEPHONY := true
TARGET_NO_QTI_MPGEN := false
TARGET_USES_QTIC := false
TARGET_USES_QTIC_EXTENSION := false
ENABLE_HYP := false
ENABLE_CAR_POWER_MANAGER := true
BOARD_HAS_QCOM_WLAN := true

#target name, shall be used in all makefiles
MSMSTEPPE = sm6150

$(call inherit-product, device/qcom/common/common64.mk)
$(call inherit-product, packages/services/Car/car_product/build/car.mk)

PRODUCT_NAME := $(MSMSTEPPE)_au
PRODUCT_DEVICE := $(MSMSTEPPE)_au
PRODUCT_BRAND := Android
PRODUCT_MODEL := $(MSMSTEPPE)_au for arm64


# Default A/B configuration.
ENABLE_AB ?= true

# RRO configuration
#TARGET_USES_RRO := true

TARGET_KERNEL_VERSION := 4.14
# default is nosdcard, S/W button enabled in resource
PRODUCT_CHARACTERISTICS := nosdcard

BOARD_FRP_PARTITION_NAME := frp

# WLAN chipset
WLAN_CHIPSET := qca_cld3

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android

-include $(QCPATH)/common/config/qtic-config.mk

$(warning ****** MSMSTEPPE code name is: $(MSMSTEPPE))
# Video seccomp policy files
PRODUCT_COPY_FILES += \
    device/qcom/$(MSMSTEPPE)/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/qcom/$(MSMSTEPPE)/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

PRODUCT_BOOT_JARS += tcmiface
PRODUCT_BOOT_JARS += telephony-ext
PRODUCT_PACKAGES += telephony-ext

TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

TARGET_DISABLE_DASH := true
TARGET_DISABLE_QTI_VPP := true

ifneq ($(TARGET_DISABLE_DASH), true)
    PRODUCT_BOOT_JARS += qcmediaplayer
endif

ifeq ($(TARGET_NO_QTI_WFD),)
    PRODUCT_BOOT_JARS += WfdCommon
endif

# Video platform properties file
PRODUCT_COPY_FILES += hardware/qcom/media/conf_files/msmsteppe/system_properties.xml:$(TARGET_COPY_OUT_VENDOR)/etc/system_properties.xml

# Video codec configuration files
ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS), true)
PRODUCT_COPY_FILES += device/qcom/$(MSMSTEPPE)_au/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_vendor.xml

PRODUCT_COPY_FILES += device/qcom/$(MSMSTEPPE)_au/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml
PRODUCT_COPY_FILES += device/qcom/$(MSMSTEPPE)_au/media_codecs_vendor.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_vendor.xml
PRODUCT_COPY_FILES += device/qcom/$(MSMSTEPPE)_au/media_codecs_vendor_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_vendor_audio.xml

PRODUCT_COPY_FILES += device/qcom/$(MSMSTEPPE)_au/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml
endif #TARGET_ENABLE_QC_AV_ENHANCEMENTS

PRODUCT_PACKAGES += android.hardware.media.omx@1.0-impl

# Audio configuration file
-include $(TOPDIR)hardware/qcom/audio/configs/msmsteppe_au/msmsteppe_au.mk
#Audio DLKM
AUDIO_DLKM := audio_apr.ko
AUDIO_DLKM := audio_snd_event.ko
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

PRODUCT_PACKAGES += fs_config_files

ifeq ($(ENABLE_AB), true)
#A/B related packages
PRODUCT_PACKAGES += update_engine \
    update_engine_client \
    update_verifier \
    bootctrl.$(MSMSTEPPE) \
    brillo_update_payload \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-service

#Boot control HAL test app
PRODUCT_PACKAGES_DEBUG += bootctl
endif

#Healthd packages
PRODUCT_PACKAGES += \
    android.hardware.health@1.0-impl \
    android.hardware.health@1.0-convert \
    android.hardware.health@1.0-service \
    libhealthd.msm

# Fingerprint feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:system/etc/permissions/android.hardware.fingerprint.xml \

# Adding vendor manifest
PRODUCT_COPY_FILES += \
    device/qcom/$(MSMSTEPPE)_au/manifest.xml:$(TARGET_COPY_OUT_VENDOR)/manifest.xml

#ANT+ stack
PRODUCT_PACKAGES += \
    AntHalService \
    libantradio \
    antradio_app \
    libvolumelistener

# Display/Graphics
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service \
    android.hardware.configstore@1.0-service \
    android.hardware.broadcastradio@1.0-impl

# FBE support
PRODUCT_COPY_FILES += \
    device/qcom/$(MSMSTEPPE)/init.qti.qseecomd.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qti.qseecomd.sh

# MSM IRQ Balancer configuration file
PRODUCT_COPY_FILES += device/qcom/$(MSMSTEPPE)/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf

# Powerhint configuration file
PRODUCT_COPY_FILES += device/qcom/$(MSMSTEPPE)/powerhint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.xml

# Camera configuration file. Shared by passthrough/binderized camera HAL
#PRODUCT_PACKAGES += camera.device@3.2-impl
#PRODUCT_PACKAGES += camera.device@1.0-impl
#PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-impl
# Enable binderized camera HAL
#PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-service

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:system/etc/permissions/android.software.midi.xml

#for wlan
# Multiple chips
TARGET_WLAN_CHIP := qca6174 qca6390 qcn7605
include device/qcom/wlan/$(PRODUCT_NAME)/wlan.mk

#for Emac
PRODUCT_PACKAGES += \
    emac_perf_settings.sh

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


PRODUCT_PACKAGES += \
    openavb_harness \
    gptp \
    mrpd

# Kernel modules install path
KERNEL_MODULES_INSTALL := dlkm
KERNEL_MODULES_OUT := out/target/product/$(PRODUCT_NAME)/$(KERNEL_MODULES_INSTALL)/lib/modules

#Disabling Vulkan version 1.1
TARGET_SUPPORT_VULKAN_VERSION_1_1 := false

#FEATURE_OPENGLES_EXTENSION_PACK support string config file
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:system/etc/permissions/android.hardware.opengles.aep.xml

#Enable full treble flag
PRODUCT_FULL_TREBLE_OVERRIDE := true
PRODUCT_VENDOR_MOVE_ENABLED := true

#Enable QTI KEYMASTER and GATEKEEPER HIDLs
KMGK_USE_QTI_SERVICE := true

#Enable KEYMASTER 4.0
ENABLE_KM_4_0 := true

ifneq ($(strip $(TARGET_USES_RRO)),true)
DEVICE_PACKAGE_OVERLAYS += device/qcom/sm6150_au/overlay
endif

# Enable flag to support slow devices
TARGET_PRESIL_SLOW_BOARD := true

# dm-verity definitions
ifneq ($(BOARD_AVB_ENABLE), true)
 PRODUCT_SUPPORTS_VERITY := true
endif

# Enable vndk-sp Librarie
PRODUCT_PACKAGES += vndk_package

PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE:=true

ENABLE_VENDOR_RIL_SERVICE := true
