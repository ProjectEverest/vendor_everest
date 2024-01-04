# Inherit common mobile Everest stuff
$(call inherit-product, vendor/everest/config/common.mk)

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

ifneq ($(WITH_EVEREST_CHARGER),false)
PRODUCT_PACKAGES += \
    everest_charger_animation \
    everest_charger_animation_vendor
endif

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# SystemUI plugins
PRODUCT_PACKAGES += \
    QuickAccessWallet
