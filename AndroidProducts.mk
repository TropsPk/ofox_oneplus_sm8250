# Product makefile list for device/oneplus/instantnoodle (unified OnePlus 8 / 8 Pro).
# Unlike the reference trees, ONE product file serves both devices; the variant
# is selected at runtime (see recovery/root/system/bin/runatboot.sh).
PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/ofox_instantnoodle.mk

COMMON_LUNCH_CHOICES := \
    ofox_instantnoodle-eng \
    ofox_instantnoodle-userdebug
