#!/bin/bash
# OrangeFox build variables
# FOX_VERSION is intentionally absent (obsolete; terminates the build per the OrangeFox wiki).
export TARGET_ARCH="arm64-v8a"
export OF_MAINTAINER="UNSET"           # set your name before releasing
export FOX_BUILD_DEVICE="instantnoodle"
export ALLOW_MISSING_DEPENDENCIES=true
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
# Device-name checks in flashable zips (ro.product.device on the stock OnePlus 8 is OnePlus8)
export TARGET_DEVICE_ALT="instantnoodle, instantnoodlep, OnePlus8, OnePlus 8, OnePlus8Pro, OnePlus8PRO, OnePlus 8 Pro"
export FOX_TARGET_DEVICES="instantnoodle, instantnoodlep, OnePlus8, OnePlus 8, OnePlus8Pro, OnePlus8PRO, OnePlus 8 Pro"
export BUILD_USERNAME="nobody"
export BUILD_HOSTNAME="android-build"

# A/B + virtual A/B with a dedicated recovery partition (verified: recovery_a/b exist, no vendor_boot)
export FOX_AB_DEVICE=1
export FOX_VIRTUAL_AB_DEVICE=1
export OF_AB_DEVICE_WITH_RECOVERY_PARTITION=1

# Magisk boot tooling
export OF_USE_MAGISKBOOT=1
export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES=1

# Screen: tuned for the OnePlus 8 (1080x2400); the 8 Pro panel is different and not tuned
export OF_SCREEN_H=2400
export OF_STATUS_H=120
export OF_STATUS_INDENT_LEFT=48
export OF_STATUS_INDENT_RIGHT=48
export OF_ALLOW_DISABLE_NAVBAR=0
export OF_CLOCK_POS=0

# Decryption / OTA behaviour (stock keymaster is 4.0)
export OF_DEFAULT_KEYMASTER_VERSION=4.0
export OF_FBE_METADATA_MOUNT_IGNORE=1
export OF_NO_TREBLE_COMPATIBILITY_CHECK=1
export OF_USE_LEGACY_BATTERY_SERVICES=1
export OF_RUN_POST_FORMAT_PROCESS=1
export OF_SUPPORT_ALL_PAYLOAD_OTA_UPDATES=1
export OF_SUPPORT_ALL_BLOCK_OTA_UPDATES=0
export OF_FIX_OTA_UPDATE_MANUAL_FLASH_ERROR=1
export OF_DISABLE_MIUI_OTA_BY_DEFAULT=1
export OF_QUICK_BACKUP_LIST="/boot;/data;/super;"

# Tooling / size
export FOX_DELETE_AROMAFM=1
export FOX_USE_ZIP_BINARY=1
export FOX_USE_TAR_BINARY=1
export FOX_USE_BUSYBOX_BINARY=1
export FOX_USE_BASH_SHELL=1
export FOX_USE_NANO_EDITOR=1
export OF_USE_LZMA_COMPRESSION=1
export OF_DONT_KEEP_LOG_HISTORY=1
export OF_NO_SPLASH_CHANGE=1
export FOX_INSTALLER_DISABLE_AUTOREBOOT=1
