# Everest Version
EVEREST_BUILD_TYPE ?= UNOFFICIAL

# Only include Updater for official  build
ifeq ($(filter-out OFFICIAL,$(EVEREST_BUILD_TYPE)),)
    PRODUCT_PACKAGES += \
        Updater

PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/etc/init/init.lineage-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.lineage-updater.rc
endif

# OFFICIAL DEVICES CHECK
OFFICIAL_MAINTAINERS := $(shell cat everest-maintainers/everest.maintainers)
OFFICIAL_DEVICES := $(shell cat everest-maintainers/everest.devices)

ifeq ($(findstring $(LINEAGE_BUILD), $(OFFICIAL_DEVICES)),)
  # Device not listed as official
  EVEREST_BUILD_TYPE := UNOFFICIAL
else
  # Check if builder is an official maintainer
  ifeq ($(findstring $(EVEREST_MAINTAINER), $(OFFICIAL_MAINTAINERS)),)
    # Builder not an official maintainer, warn and set unofficial
    $(warning **********************************************************************)
    $(warning *   There is already an official maintainer for $(LINEAGE_BUILD)    *)
    $(warning *              Setting build type to UNOFFICIAL                      *)
    $(warning **********************************************************************)
    EVEREST_BUILD_TYPE := UNOFFICIAL
  else
    # Official maintainer building official device
    EVEREST_BUILD_TYPE := OFFICIAL
  endif
endif

# Enforce official build for official maintainers on official devices
ifeq ($(EVEREST_BUILD_TYPE), OFFICIAL)
  ifeq ($(findstring $(LINEAGE_BUILD), $(OFFICIAL_DEVICES)),)
    # Shouldn't reach here, error for unexpected situation
    $(error **********************************************************)
    $(error *     A violation has been detected, aborting build      *)
    $(error **********************************************************)
  endif
endif

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED ?= $(TARGET_SUPPORTS_64_BIT_APPS)

ifeq ($(TARGET_FACE_UNLOCK_SUPPORTED),true)
PRODUCT_PACKAGES += \
    ParanoidSense

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.face.sense_service=true

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
endif

# Cloned app exemption
PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/etc/sysconfig/preinstalled-packages-platform-everest-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/preinstalled-packages-platform-everest-product.xml
