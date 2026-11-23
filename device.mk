# Shared device makefile for OnePlus 8 / 8 Pro (recovery)

LOCAL_PATH := device/oneplus/instantnoodle

$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Stock: ro.product.first_api_level=29, ro.vndk.version=30
PRODUCT_SHIPPING_API_LEVEL := 29
PRODUCT_TARGET_VNDK_VERSION := 30
PRODUCT_PLATFORM := kona

# --- A/B, virtual A/B, dynamic partitions ----------------------------------------
# Stock: ro.build.ab_update, ro.virtual_ab.enabled and ro.boot.dynamic_partitions are true
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier \
    checkpoint_gc

# Boot HAL: 1.2 impl + recovery wrapper (stock vintf declares 1.1)
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl \
    android.hardware.boot@1.2-service \
    android.hardware.boot@1.2-impl-wrapper.recovery \
    android.hardware.boot@1.2-impl-wrapper \
    android.hardware.boot@1.2-impl.recovery \
    bootctrl.$(PRODUCT_PLATFORM) \
    bootctrl.$(PRODUCT_PLATFORM).recovery

PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.1-impl-mock \
    android.hardware.fastboot@1.1-impl-mock.recovery \
    fastbootd \
    resetprop

# Decryption modules
PRODUCT_PACKAGES_ENG += \
    qcom_decrypt \
    qcom_decrypt_fbe \
    tzdata_twrp

PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)
# Display libs for minui on QTI; only wired in when the namespace exists in the manifest
ifneq ($(wildcard vendor/qcom/opensource/commonsys-intf/display),)
PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/commonsys-intf/display
RECOVERY_LIBRARY_SOURCE_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/libion.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config@1.0.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config@2.0.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/libdisplayconfig.qti.so
endif
