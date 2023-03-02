# Copyright (C) 2024 EverestOS
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Versioning System
EVEREST_CODENAME := Gokyo
EVEREST_NUM_VER := 1.2

TARGET_PRODUCT_SHORT := $(subst everest_,,$(EVEREST_BUILD_TYPE))

EVEREST_BUILD_TYPE ?= UNOFFICIAL

# Only include Updater for official  build
ifeq ($(filter-out OFFICIAL,$(EVEREST_BUILD_TYPE)),)
    PRODUCT_PACKAGES += \
        Updater

PRODUCT_COPY_FILES += \
    vendor/everest/prebuilt/common/etc/init/init.everest-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.everest-updater.rc
endif

# Sign builds if building an official build
ifeq ($(filter-out OFFICIAL,$(EVEREST_BUILD_TYPE)),)
    PRODUCT_DEFAULT_DEV_CERTIFICATE := $(KEYS_LOCATION)
endif

ifeq ($(WITH_GAPPS),true)
EVEREST_EDITION := GAPPS
else
EVEREST_EDITION := VANILLA
endif

# OFFICIAL DEVICES CHECK
OFFICIAL_MAINTAINERS := $(shell cat everest-maintainers/everest.maintainers)
OFFICIAL_DEVICES := $(shell cat everest-maintainers/everest.devices)

ifeq ($(findstring $(EVEREST_BUILD), $(OFFICIAL_DEVICES)),)
  # Device not listed as official
  EVEREST_BUILD_TYPE := UNOFFICIAL
else
  # Check if builder is an official maintainer
  ifeq ($(findstring $(EVEREST_MAINTAINER), $(OFFICIAL_MAINTAINERS)),)
    # Builder not an official maintainer, warn and set unofficial
    $(warning **********************************************************************)
    $(warning *   There is already an official maintainer for $(EVEREST_BUILD)    *)
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
  ifeq ($(findstring $(EVEREST_BUILD), $(OFFICIAL_DEVICES)),)
    # Shouldn't reach here, error for unexpected situation
    $(error **********************************************************)
    $(error *     A violation has been detected, aborting build      *)
    $(error **********************************************************)
  endif
endif

# Set all versions
BUILD_DATE := $(shell date -u +%Y%m%d)
BUILD_TIME := $(shell date -u +%H%M)
EVEREST_BUILD_VERSION := $(EVEREST_NUM_VER)-$(EVEREST_CODENAME)
EVEREST_VERSION := $(EVEREST_BUILD_VERSION)-$(EVEREST_BUILD)-$(EVEREST_BUILD_TYPE)-$(EVEREST_EDITION)-$(BUILD_TIME)-$(BUILD_DATE)
ROM_FINGERPRINT := everest/$(PLATFORM_VERSION)/$(TARGET_PRODUCT_SHORT)/$(BUILD_TIME)
EVEREST_DISPLAY_VERSION := $(EVEREST_VERSION)
RELEASE_TYPE := $(EVEREST_BUILD_TYPE)

# EverestOS System Version
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.everest.base.codename=$(EVEREST_CODENAME) \
    ro.everest.base.version=$(EVEREST_NUM_VER) \
    ro.everest.build.version=$(EVEREST_BUILD_VERSION) \
    ro.everest.build.date=$(BUILD_DATE) \
    ro.everest.buildtype=$(EVEREST_BUILD_TYPE) \
    ro.everest.display.version=$(EVEREST_DISPLAY_VERSION) \
    ro.everest.fingerprint=$(ROM_FINGERPRINT) \
    ro.everest.version=$(EVEREST_VERSION) \
    ro.modversion=$(EVEREST_VERSION) \
    ro.everestos.maintainer=$(EVEREST_MAINTAINER) \
    ro.everest.edition=$(EVEREST_EDITION) \
    ro.everest.device=$(EVEREST_BUILD)

# Signing
ifeq (user,$(TARGET_BUILD_VARIANT))
ifneq (,$(wildcard .android-certs/releasekey.pk8))
PRODUCT_DEFAULT_DEV_CERTIFICATE := .android-certs/releasekey
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.oem_unlock_supported=1
endif
ifneq (,$(wildcard .android-certs/verity.pk8))
PRODUCT_VERITY_SIGNING_KEY := .android-certs/verity
endif
ifneq (,$(wildcard .android-certs/otakey.x509.pem))
PRODUCT_OTA_PUBLIC_KEYS := .android-certs/otakey.x509.pem
endif
endif
