MSMSTEPPE = sm6150
TARGET_BOARD_PLATFORM := $(MSMSTEPPE)
TARGET_BOOTLOADER_BOARD_NAME := $(MSMSTEPPE)
TARGET_BOARD_TYPE := auto
TARGET_BOARD_SUFFIX := _au
DEVICE_SUPPORTS_64_BIT_APPS_ONLY := true
# Skip VINTF checks for kernel configs since we do not have kernel source
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

ALLOW_MISSING_DEPENDENCIES := true

ENABLE_AB ?= true
# Enable virtual-ab by default
ifeq ($(ENABLE_AB), true)
   ENABLE_VIRTUAL_AB := true
endif
ifeq ($(ENABLE_VIRTUAL_AB), true)
  # Enable virtual A/B compression
  $(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)
  $(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)
  PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := gz
  PRODUCT_VENDOR_PROPERTIES += ro.virtual_ab.compression.threads=true
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
ENABLE_AIDL_VHAL := true
TARGET_CONSOLE_ENABLED ?= true

SYSTEMEXT_SEPARATE_PARTITION_ENABLE = true
TARGET_USES_QSSI := true
PRODUCT_ENFORCE_VINTF_MANIFEST := false

TARGET_NO_QTI_WFD := true
BOARD_HAVE_QCOM_FM := false
BOARD_VENDOR_QCOM_LOC_PDK_FEATURE_SET := false
TARGET_ENABLE_QC_AV_ENHANCEMENTS := false
TARGET_FWK_SUPPORTS_AV_VALUEADDS := false
TARGET_USES_AOSP_FOR_WLAN := true
BOARD_HAS_QCOM_WLAN := true
ENABLE_CAR_POWER_MANAGER := true

#Enable Userspace Restart
$(call inherit-product, $(SRC_TARGET_DIR)/product/userspace_reboot.mk)

TARGET_USES_RRO := true

# Dynamic-partition enabled by default
#BOARD_DYNAMIC_PARTITION_ENABLE := true
#ifeq ($(strip $(BOARD_DYNAMIC_PARTITION_ENABLE)),true)
  PRODUCT_USE_DYNAMIC_PARTITIONS := true
  PRODUCT_PACKAGES += fastbootd
  # Add default implementation of fastboot AIDL.
  PRODUCT_PACKAGES += android.hardware.fastboot-service.example_recovery
  TARGET_HIBERNATION_SECURE_ENABLE := true
# Mismatch in the uses-library tags between build system and the manifest leads
# to soong APK manifest_check tool errors. Enable the flag to fix this.
  RELAX_USES_LIBRARY_CHECK := true

  BOARD_AVB_VBMETA_SYSTEM := system
  BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
  BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
  BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
  BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

# Using sha256 for dm-verity partitions.
# system, system_ext and vendor.
  BOARD_AVB_SYSTEM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
  BOARD_AVB_SYSTEM_EXT_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
  BOARD_AVB_VENDOR_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
  BOARD_AVB_SYSTEM_DLKM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
  BOARD_AVB_VENDOR_DLKM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256

  ifeq ($(ENABLE_AB), true)
    PRODUCT_COPY_FILES += $(LOCAL_PATH)/default/fstab_AB_dynamic_partition_variant.qti:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.default
    PRODUCT_COPY_FILES += $(LOCAL_PATH)/emmc/fstab_AB_dynamic_partition_variant.qti:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.emmc
  else
    PRODUCT_COPY_FILES += $(LOCAL_PATH)/default/fstab_non_AB_dynamic_partition_variant.qti:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.default
    PRODUCT_COPY_FILES += $(LOCAL_PATH)/emmc/fstab_non_AB_dynamic_partition_variant.qti:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.emmc
  endif

  PRODUCT_BUILD_SYSTEM_IMAGE := false
  PRODUCT_BUILD_SYSTEM_EXT_IMAGE := false
  PRODUCT_BUILD_SYSTEM_OTHER_IMAGE := false
  PRODUCT_BUILD_VENDOR_IMAGE := true
  PRODUCT_BUILD_ODM_IMAGE := false
  PRODUCT_BUILD_PRODUCT_IMAGE := false
  PRODUCT_BUILD_PRODUCT_SERVICES_IMAGE := false
  PRODUCT_BUILD_CACHE_IMAGE := false
  PRODUCT_BUILD_RAMDISK_IMAGE := true
  PRODUCT_BUILD_USERDATA_IMAGE := true
  PRODUCT_BUILD_VENDOR_BOOT_IMAGE := true
  PRODUCT_BUILD_VENDOR_DLKM_IMAGE := true
  PRODUCT_BUILD_SYSTEM_DLKM_IMAGE := true
#endif #BOARD_DYNAMIC_PARTITION_ENABLE

###########
#QMAA flags starts
###########
#QMAA global flag for modular architecture
#true means QMAA is enabled for system
#false means QMAA is disabled for system

TARGET_USES_QMAA := true

#QMAA flag which is set to incorporate any generic dependencies
#required for the boot to UI flow in a QMAA enabled target.
#Set to false when all target level depenencies are met with
#actual full blown implementations.
TARGET_USES_QMAA_RECOMMENDED_BOOT_CONFIG := true

#QMAA tech team flag to override global QMAA per tech team
#true means overriding global QMAA for this tech area
#false means using global, no override
TARGET_USES_QMAA_OVERRIDE_ANDROID_CORE := true
TARGET_USES_QMAA_OVERRIDE_ANDROID_RECOVERY := true
TARGET_USES_QMAA_OVERRIDE_AUDIO   := true
TARGET_USES_QMAA_OVERRIDE_BIOMETRICS := true
TARGET_USES_QMAA_OVERRIDE_BLUETOOTH   := true
TARGET_USES_QMAA_OVERRIDE_CAMERA  := true
TARGET_USES_QMAA_OVERRIDE_CVP  := false
TARGET_USES_QMAA_OVERRIDE_DATA_NET := false
TARGET_USES_QMAA_OVERRIDE_DATA := false
TARGET_USES_QMAA_OVERRIDE_DIAG := false
TARGET_USES_QMAA_OVERRIDE_DISPLAY := true
TARGET_USES_QMAA_OVERRIDE_DPM  := false
TARGET_USES_QMAA_OVERRIDE_DRM  := true
TARGET_USES_QMAA_OVERRIDE_EID := false
TARGET_USES_QMAA_OVERRIDE_FASTCV  := true
TARGET_USES_QMAA_OVERRIDE_FASTRPC := true
TARGET_USES_QMAA_OVERRIDE_FM  := true
TARGET_USES_QMAA_OVERRIDE_FTM := false
TARGET_USES_QMAA_OVERRIDE_GFX := true
TARGET_USES_QMAA_OVERRIDE_GPS := true
TARGET_USES_QMAA_OVERRIDE_GP := false
TARGET_USES_QMAA_OVERRIDE_GPT := false
TARGET_USES_QMAA_OVERRIDE_KERNEL_TESTS_INTERNAL := false
TARGET_USES_QMAA_OVERRIDE_KMGK := true
TARGET_USES_QMAA_OVERRIDE_MSMIRQBALANCE := true
TARGET_USES_QMAA_OVERRIDE_OPENVX  := true
TARGET_USES_QMAA_OVERRIDE_PERF := true
TARGET_USES_QMAA_OVERRIDE_REMOTE_EFS := false
TARGET_USES_QMAA_OVERRIDE_RPMB := true
TARGET_USES_QMAA_OVERRIDE_SCVE  := false
TARGET_USES_QMAA_OVERRIDE_SECUREMSM_TESTS := false
TARGET_USES_QMAA_OVERRIDE_SENSORS := true
TARGET_USES_QMAA_OVERRIDE_SMCINVOKE := false
TARGET_USES_QMAA_OVERRIDE_SOTER := false
TARGET_USES_QMAA_OVERRIDE_SPCOM_UTEST := false
TARGET_USES_QMAA_OVERRIDE_SYNX := false
TARGET_USES_QMAA_OVERRIDE_TFTP := false
TARGET_USES_QMAA_OVERRIDE_USB := true
TARGET_USES_QMAA_OVERRIDE_VIBRATOR := false
TARGET_USES_QMAA_OVERRIDE_VIDEO   := true
TARGET_USES_QMAA_OVERRIDE_VPP := false
TARGET_USES_QMAA_OVERRIDE_WFD     := true
TARGET_USES_QMAA_OVERRIDE_WLAN    := true

TARGET_ENABLE_QSEECOM := false
#Full QMAA HAL List
QMAA_HAL_LIST := audio video camera display sensors gps

ifeq ($(TARGET_USES_QMAA), true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.confqmaa=true
endif

###########
#QMAA flags ends

TARGET_SKIP_OTA_PACKAGE := true

ifneq ("$(wildcard device/qcom/$(TARGET_BOARD_PLATFORM)-kernel/vendor_dlkm/system_dlkm.modules.blocklist)", "")
  PRODUCT_COPY_FILES += device/qcom/$(TARGET_BOARD_PLATFORM)-kernel/vendor_dlkm/system_dlkm.modules.blocklist:$(TARGET_COPY_OUT_VENDOR_DLKM)/lib/modules/system_dlkm.modules.blocklist
endif

TARGET_DEFINES_DALVIK_HEAP := true
$(call inherit-product, device/qcom/common/common64.mk)
#Inherit all except heap growth limit from phone-xhdpi-2048-dalvik-heap.mk
PRODUCT_VENDOR_PROPERTIES  += \
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
PRODUCT_MANUFACTURER := qti

PRODUCT_VENDOR_PROPERTIES += \
    ro.soc.manufacturer=$(PRODUCT_MANUFACTURER) \
    ro.soc.model=$(PRODUCT_DEVICE)

#Initial bringup flags

#Default vendor image configuration
ifeq ($(ENABLE_VENDOR_IMAGE),)
ENABLE_VENDOR_IMAGE := false
endif

TARGET_KERNEL_VERSION := 6.1

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
TARGET_HAS_DIAG_ROUTER := true

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
#PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml

# Copy the testscripts from the qssi folder as it was moved to QSSI folder.
#PRODUCT_COPY_FILES += \
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
PRODUCT_PACKAGES += android.hardware.media.omx@1.0-impl
#Copy supported features list
ifeq ($(TARGET_USES_GAS),true)
PRODUCT_COPY_FILES += device/qcom/sm6150_au/sm6150_au_features.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sm6150_au_features.xml
endif

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

# Bluetooth DLKM
BT_DLKM := btpower.ko
PRODUCT_PACKAGES += $(BT_DLKM)

PCIE_DLKM := pci-msm-drv.ko
PRODUCT_PACKAGES += $(PCIE_DLKM)

# HS-I2S test app
PRODUCT_PACKAGES += hsi2s_test

PRODUCT_PACKAGES += fs_config_files

ifeq ($(ENABLE_AB), true)
#A/B related packages
PRODUCT_PACKAGES += update_engine \
    update_engine_client \
    update_verifier \
    android.hardware.boot-service.qti.recovery \
    android.hardware.boot-service.qti

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
    device/qcom/$(MSMSTEPPE)_au/input-port-associations.xml:$(TARGET_COPY_OUT_VENDOR)/etc/input-port-associations.xml \
    device/qcom/$(MSMSTEPPE)_au/display_settings.xml:$(TARGET_COPY_OUT_VENDOR)/etc/display_settings.xml


DEVICE_MANIFEST_FILE := device/qcom/$(MSMSTEPPE)_au/manifest.xml
DEVICE_MATRIX_FILE   := device/qcom/common/compatibility_matrix.xml
DEVICE_FRAMEWORK_MANIFEST_FILE := device/qcom/msmnile_au/framework_manifest.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := vendor/qcom/opensource/core-utils/vendor_framework_compatibility_matrix.xml

# Enable Scoped Storage related
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

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
PRODUCT_COPY_FILES += device/qcom/$(MSMSTEPPE)_au/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf





# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

# OEM unlock feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.carrierlock.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.carrierlock.xml

# Pro Audio feature
PRODUCT_COPY_FILES += \
   frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml

PRODUCT_PACKAGES += \
       openavb_harness \
       gptp \
       mrpd

# Kernel modules install path
KERNEL_MODULES_INSTALL := dlkm
ifeq ($(KERNEL_MODULES_OUT),)
KERNEL_MODULES_OUT := out/target/product/$(MSMSTEPPE)_au/$(KERNEL_MODULES_INSTALL)/lib/modules
endif
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

DEVICE_PACKAGE_OVERLAYS += device/qcom/sm6150_au/overlay

# Enable flag to support slow devices
TARGET_PRESIL_SLOW_BOARD := true

ENABLE_VENDOR_RIL_SERVICE := true

#----------------------------------------------------------------------
# wlan specific
#----------------------------------------------------------------------
# Multiple chips
ifeq ($(strip $(BOARD_HAS_QCOM_WLAN)),true)
TARGET_WLAN_CHIP := qcn7605
include device/qcom/wlan/$(MSMSTEPPE)_au/wlan.mk
endif

PRODUCT_VENDOR_PROPERTIES += rild.libpath=/vendor/lib64/libril-qc-hal-qmi.so \
                            persist.rild.nitz_plmn=
                            persist.rild.nitz_long_ons_0=
                            persist.rild.nitz_long_ons_1=
                            persist.rild.nitz_long_ons_2=
                            persist.rild.nitz_long_ons_3=
                            persist.rild.nitz_short_ons_0=
                            persist.rild.nitz_short_ons_1=
                            persist.rild.nitz_short_ons_2=
                            persist.rild.nitz_short_ons_3=
                            ril.subscription.types=NV,RUIM \
                            DEVICE_PROVISIONED=1 \
                            dalvik.vm.heapsize=36m \
                            dev.pm.dyn_samplingrate=1

PRODUCT_VENDOR_PROPERTIES += qcom.hw.aac.encoder=true

# Cne module properties
PRODUCT_VENDOR_PROPERTIES += persist.vendor.cne.feature=1

# system properties for MM modules
PRODUCT_VENDOR_PROPERTIES += media.stagefright.enable-player=true \
                              media.stagefright.enable-http=true \
                              media.stagefright.enable-aac=true \
                              media.stagefright.enable-qcp=true \
                              media.stagefright.enable-fma2dp=true \
                              media.stagefright.enable-scan=true \
                              mmp.enable.3g2=true \
                              media.aac_51_output_enabled=true \
                              mm.enable.smoothstreaming=true \
                              persist.mm.enable.prefetch=true

# system props for the data modules
PRODUCT_VENDOR_PROPERTIES += ro.vendor.use_data_netmgrd=true \
                              persist.vendor.data.mode=concurrent

# system props for time-services
PRODUCT_VENDOR_PROPERTIES += persist.timed.enable=true

# system prop for opengles version
#
# 196608 is decimal for 0x30000 to report version 3
# 196609 is decimal for 0x30001 to report version 3.1
#  196610 is decimal for 0x30002 to report version 3.2
PRODUCT_VENDOR_PROPERTIES += ro.opengles.version=196610

# system property for maximum number of HFP client connections
PRODUCT_VENDOR_PROPERTIES += bt.max.hfpclient.connections=1

# Simulate sdcard on /data/media
PRODUCT_VENDOR_PROPERTIES += persist.fuse_sdcard=true

# System prop for Bluetooth SOC type
PRODUCT_VENDOR_PROPERTIES += vendor.qcom.bluetooth.soc=rome

# System prop for wipower support
PRODUCT_VENDOR_PROPERTIES += ro.bluetooth.emb_wp_mode=false \
                              ro.bluetooth.wipower=false \
                              persist.vendor.service.bt.a2dp.sink=true \
                              persist.vendor.btstack.enable.splita2dp=false \
                              persist.vendor.service.bdroid.sibs=false

# System prop for setting sensor hal
PRODUCT_VENDOR_PROPERTIES += ro.hardware.sensors=msmnile.asm_auto \
                              ro.hardware.type=automotive

# Snapdragon value add features
PRODUCT_VENDOR_PROPERTIES += ro.qc.sdk.audio.ssr=false

# Fluencetype can be "fluence" or "fluencepro" or "none"
PRODUCT_VENDOR_PROPERTIES += ro.qc.sdk.audio.fluencetype=none \
                              persist.audio.fluence.voicecall=true \
                              persist.audio.fluence.voicerec=false \
                              persist.audio.fluence.speaker=true

# System prop for RmNet Data
PRODUCT_VENDOR_PROPERTIES += persist.rmnet.data.enable=true \
                              persist.data.wda.enable=true \
                              persist.data.df.dl_mode=5 \
                              persist.data.df.ul_mode=5 \
                              persist.data.df.agg.dl_pkt=10 \
                              persist.data.df.agg.dl_size=4096 \
                              persist.data.df.mux_count=8 \
                              persist.data.df.iwlan_mux=9 \
                              persist.data.df.dev_name=rmnet_usb0

# property to enable user to access Google WFD settings
PRODUCT_VENDOR_PROPERTIES += persist.debug.wfd.enable=1

# property to choose between virtual/external wfd display
PRODUCT_VENDOR_PROPERTIES += persist.sys.wfd.virtual=0

# Enable tunnel encoding for amrwb
PRODUCT_VENDOR_PROPERTIES += tunnel.audio.encode = true

# Buffer size in kbytes for compress offload playback
PRODUCT_VENDOR_PROPERTIES += audio.offload.buffer.size.kb=32

# Enable offload audio video playback by default
PRODUCT_VENDOR_PROPERTIES += av.offload.enable=true

# Enable voice path for PCM VoIP by default
PRODUCT_VENDOR_PROPERTIES += use.voice.path.for.pcm.voip=true

# System prop for NFC DT
PRODUCT_VENDOR_PROPERTIES += ro.nfc.port=I2C

# Enable dsp gapless mode by default
PRODUCT_VENDOR_PROPERTIES += audio.offload.gapless.enabled=true

# initialize QCA1530 detection
PRODUCT_VENDOR_PROPERTIES += sys.qca1530=detect

# Enable stm events
PRODUCT_VENDOR_PROPERTIES += persist.debug.coresight.config=stm-events

# Hwui properties
PRODUCT_VENDOR_PROPERTIES += ro.hwui.texture_cache_size=72 \
                              ro.hwui.layer_cache_size=48 \
                              ro.hwui.r_buffer_cache_size=8 \
                              ro.hwui.path_cache_size=32 \
                              ro.hwui.gradient_cache_size=1 \
                              ro.hwui.drop_shadow_cache_size=6 \
                              ro.hwui.texture_cache_flushrate=0.4 \
                              ro.hwui.text_small_cache_width=1024 \
                              ro.hwui.text_small_cache_height=1024 \
                              ro.hwui.text_large_cache_width=2048 \
                              ro.hwui.text_large_cache_height=1024 \
                              config.disable_rtt=true

# Bringup properties
PRODUCT_VENDOR_PROPERTIES += persist.sys.force_sw_gles=1 \
                              persist.vendor.radio.atfwd.start=true \
                              ro.kernel.qemu.gles=0 \
                              qemu.hw.mainkeys=0

# Increase cached app limit
PRODUCT_VENDOR_PROPERTIES += ro.vendor.qti.sys.fw.bg_apps_limit=60

# Enable ZRAM
PRODUCT_VENDOR_PROPERTIES += ro.vendor.qti.config.zram=true

# IOP properties
PRODUCT_VENDOR_PROPERTIES += vendor.iop.enable_uxe=1 \
                              vendor.perf.iop_v3.enable=true

# Property to enable perf boosts from System Server
PRODUCT_VENDOR_PROPERTIES += vendor.perf.gestureflingboost.enable=true

# Enable ULMK properties
PRODUCT_VENDOR_PROPERTIES += ro.lmk.kill_heaviest_task=true \
                              ro.lmk.kill_timeout_ms=15 \
                              ro.lmk.use_minfree_levels=true \
                              ro.lmk.enhance_batch_kill=true \
                              ro.lmk.enable_adaptive_lmk=true \
                              ro.lmk.vmpressure_file_min=80640

# Property to enable scroll pre-obtain view
PRODUCT_VENDOR_PROPERTIES += ro.vendor.scroll.preobtain.enable=true

# Expose aux camera for below packages
PRODUCT_VENDOR_PROPERTIES += vendor.camera.aux.packagelist=org.codeaurora.snapcam

# Display mirroring
PRODUCT_VENDOR_PROPERTIES += vendor.display.builtin_mirroring=true

# Display hwcId allocation
PRODUCT_VENDOR_PROPERTIES += vendor.display.builtin_baseid_and_size=5,3 \
                              vendor.display.pluggable_baseid_and_size=1,4 \
                              vendor.display.virtual_baseid_and_size=8,1

# Gralloc use dmabuf
PRODUCT_VENDOR_PROPERTIES += vendor.gralloc.use_dma_buf_heaps=1

# Disable boot animation
PRODUCT_VENDOR_PROPERTIES += debug.sf.nobootanimation=1

# Enable car power manager for LPM(LowPowerMode)
PRODUCT_VENDOR_PROPERTIES += persist.vendor.car.lpm=true

# Set BT AVRCP prop to false
PRODUCT_VENDOR_PROPERTIES += persist.bluetooth.enablenewavrcp=false

# Disable Telephony
PRODUCT_VENDOR_PROPERTIES += ro.radio.noril=true

# Default wifi country code
PRODUCT_VENDOR_PROPERTIES += ro.boot.wificountrycode=us

#for Emac
PRODUCT_PACKAGES += emac_perf_settings.sh

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


PRODUCT_PACKAGES += android.hardware.dumpstate-service.example \
                    android.hardware.thermal@2.0-service.mock \

PRODUCT_PACKAGES += android.hardware.health-service.qti \
                    android.hardware.health-service.qti_recovery \

#sysprofiler
PRODUCT_PACKAGES += libsysprofiler \
                    sysprofiler_app \
                    sysprofiler_interface
#add vndservicemanager for surfaceflinger crash
PRODUCT_PACKAGES += vndservicemanager
TARGET_MOUNT_POINTS_SYMLINKS := false

PRODUCT_PACKAGES += qcar-gsi.avbpubkey
SHIPPING_API_LEVEL := 34
PRODUCT_SHIPPING_API_LEVEL := 34

PRODUCT_PACKAGES += android.hardware.neuralnetworks@1.0.vendor \
                    android.hardware.neuralnetworks@1.1.vendor \
                    android.hardware.neuralnetworks@1.2.vendor \
                    android.hardware.neuralnetworks@1.3.vendor

# privapp-permissions whitelisting (To Fix CTS :privappPermissionsMustBeEnforced)
PRODUCT_VENDOR_PROPERTIES += ro.control_privapp_permissions=enforce

###################################################################################
# This is the End of target.mk file.
# Now, Pickup other split product.mk files:
###################################################################################
# TODO: Relocate the system product.mk files pickup into qssi lunch, once it is up.
$(call inherit-product-if-exists, vendor/qcom/defs/product-defs/system/*.mk)
$(call inherit-product-if-exists, vendor/qcom/defs/product-defs/vendor/*.mk)
###################################################################################
