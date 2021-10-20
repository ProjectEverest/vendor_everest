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

CL_CYN="\033[36m"
CL_PRP="\033[35m"

.PHONY: everest
everest: $(DEFAULT_GOAL) $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) mv -f $(INTERNAL_OTA_PACKAGE_TARGET) $(LINEAGE_TARGET_PACKAGE)
	$(hide) $(SHA256) $(LINEAGE_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(LINEAGE_TARGET_PACKAGE).sha256sum
	$(hide) rm -rf $(call intermediates-dir-for,PACKAGING,target_files)
	$(hide) ./vendor/lineage/build/tasks/ascii_output.sh
	$(hide) ./vendor/lineage/tools/generate_json_build_info.sh $(LINEAGE_TARGET_PACKAGE)
	echo -e ${CL_BLD}${CL_CYN}"===============================-Package complete-==============================="${CL_CYN}
	echo -e ${CL_BLD}${CL_CYN}"Datetime :"${CL_PRP}" `cat $(PRODUCT_OUT)/system/build.prop | grep ro.build.date.utc | cut -d'=' -f2 | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_CYN}"Size:"${CL_PRP}" `du -sh $(LINEAGE_TARGET_PACKAGE) | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_CYN}"Filehash: "${CL_PRP}" `md5sum $(LINEAGE_TARGET_PACKAGE) | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_CYN}"Filename: "${CL_PRP} $(LINEAGE_TARGET_PACKAGE)${CL_RST}
	echo -e ${CL_BLD}${CL_CYN}"ID: "${CL_PRP}" `cat $(LINEAGE_TARGET_PACKAGE).sha256sum | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_CYN}"================================================================================"${CL_CYN}
