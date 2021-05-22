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

LINEAGE_TARGET_PACKAGE := $(PRODUCT_OUT)/$(LINEAGE_VERSION).zip

SHA256 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/sha256sum

CL_PRP="\033[35m"
CL_RED="\033[31m"
CL_GRN="\033[32m"

.PHONY: everest
everest: $(DEFAULT_GOAL) $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) mv -f $(INTERNAL_OTA_PACKAGE_TARGET) $(LINEAGE_TARGET_PACKAGE)
	$(hide) $(SHA256) $(LINEAGE_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(LINEAGE_TARGET_PACKAGE).sha256sum
	$(hide) rm -rf $(call intermediates-dir-for,PACKAGING,target_files)
	$(hide) ./vendor/lineage/build/tasks/ascii_output.sh
	$(hide) ./vendor/lineage/tools/generate_json_build_info.sh $(LINEAGE_TARGET_PACKAGE)
	echo -e ${CL_BLD}${CL_RED}"===============================-Package complete-==============================="${CL_RED}
	echo -e ${CL_BLD}${CL_GRN}"Zip: "${CL_RED} $(LINEAGE_TARGET_PACKAGE)${CL_RST}
	echo -e ${CL_BLD}${CL_GRN}"SHA256: "${CL_RED}" `cat $(LINEAGE_TARGET_PACKAGE).sha256sum | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_GRN}"Size:"${CL_RED}" `du -sh $(LINEAGE_TARGET_PACKAGE) | awk '{print $$1}' `"${CL_RST}
        echo -e ${CL_BLD}${CL_GRN}"ID:"${CL_RED}" `md5sum $(LINEAGE_TARGET_PACKAGE) | cut -d ' ' -f 1`"${CL_RST}
	echo -e ${CL_BLD}${CL_GRN}"Path:"${CL_RED}" `wc -c $(LINEAGE_TARGET_PACKAGE) | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_RED}"================================================================================"${CL_RED}
