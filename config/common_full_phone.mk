# Inherit full common Lineage stuff
$(call inherit-product, vendor/lineage/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include Lineage LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/lineage/overlay/dictionaries
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/lineage/overlay/dictionaries

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode?=true

$(call inherit-product, vendor/lineage/config/telephony.mk)

# Vanilla and GAPPS
WITH_GAPPS ?= true
ifeq ($(WITH_GAPPS), true)
$(call inherit-product-if-exists, vendor/gms/products/gms.mk)
else
include vendor/lineage/config/vanilla.mk
endif
