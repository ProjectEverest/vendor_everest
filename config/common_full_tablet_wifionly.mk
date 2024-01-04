$(call inherit-product, $(SRC_TARGET_DIR)/product/window_extensions.mk)

# Inherit full common Everest stuff
$(call inherit-product, vendor/everest/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include Everest LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/everest/overlay/dictionaries
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/everest/overlay/dictionaries

$(call inherit-product, vendor/everest/config/wifionly.mk)
