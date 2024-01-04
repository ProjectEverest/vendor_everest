# GMS
ifeq ($(WITH_GMS),true)
WITH_GMS_COMMS_SUITE := true
endif

# Sensitive Phone Numbers list
PRODUCT_COPY_FILES += \
    vendor/everest/prebuilt/common/etc/sensitive_pn.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sensitive_pn.xml

# World APN list
PRODUCT_PACKAGES += \
    apns-conf.xml

# Telephony packages
PRODUCT_PACKAGES += \
    messaging \
    Stk
