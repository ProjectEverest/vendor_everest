# Copyright (C) 2017 Unlegacy-Android
# Copyright (C) 2017,2020 The LineageOS Project
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

# -----------------------------------------------------------------
# EverestOS OTA update package

EVEREST_TARGET_PACKAGE := $(PRODUCT_OUT)/Everest-$(EVEREST_VERSION).zip

SHA256 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/sha256sum

CL_PRP="\033[35m"
CL_RED="\033[31m"
CL_GRN="\033[32m"

.PHONY: bacon
bacon: $(DEFAULT_GOAL) $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) ln -f $(INTERNAL_OTA_PACKAGE_TARGET) $(EVEREST_TARGET_PACKAGE)
	$(hide) $(SHA256) $(EVEREST_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(EVEREST_TARGET_PACKAGE).sha256sum
	$(hide) ./vendor/everest/tools/generate_json_build_info.sh $(EVEREST_TARGET_PACKAGE)
	echo -e ${CL_BLD}${CL_RED}"===============================-Package complete-==============================="${CL_RED}
	echo -e ${CL_BLD}${CL_GRN}"Zip: "${CL_RED} $(EVEREST_TARGET_PACKAGE)${CL_RST}
	echo -e ${CL_BLD}${CL_GRN}"SHA256: "${CL_RED}" `cat $(EVEREST_TARGET_PACKAGE).sha256sum | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_GRN}"Size:"${CL_RED}" `du -sh $(EVEREST_TARGET_PACKAGE) | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_GRN}"ID:"${CL_RED}" `md5sum $(EVEREST_TARGET_PACKAGE) | cut -d ' ' -f 1`"${CL_RST}
	echo -e ${CL_BLD}${CL_GRN}"Path:"${CL_RED}" $(EVEREST_TARGET_PACKAGE)"${CL_RST}
	echo -e ${CL_BLD}${CL_RED}"================================================================================"${CL_RED}
