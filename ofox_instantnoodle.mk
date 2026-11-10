# One product for OnePlus 8 (instantnoodle) and 8 Pro (instantnoodlep); device and model follow the OnePlus 8.
PRODUCT_RELEASE_NAME := instantnoodle
$(call inherit-product, vendor/twrp/config/common.mk)

PRODUCT_DEVICE := instantnoodle
PRODUCT_NAME := ofox_$(PRODUCT_DEVICE)
PRODUCT_BRAND := OnePlus
PRODUCT_MODEL := IN2015
PRODUCT_MANUFACTURER := OnePlus

$(call inherit-product, device/oneplus/$(PRODUCT_DEVICE)/device.mk)
