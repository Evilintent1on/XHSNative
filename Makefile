#
#  XHSNative
#
#  Copyright (c) 2026 huami. All rights reserved.
#  Channel: @huamidev
#  Created on: 2026/11/24
#

TARGET = iphone:clang:latest:15.0
ARCHS = arm64
THEOS_PACKAGE_SCHEME = rootless

export DEBUG = 0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = XHSNative
RELEASE_VERSION := $(shell awk -F'"' '/define XHSNativeVersion / {sub(/[^0-9.].*/, "", $$2); print $$2}' XHSNativeConfig.h)

XHSNative_FILES = XHSNative.xm XHSNativeHelper.m XHSNativeConfig.m XHSNativeSave.m
XHSNative_CFLAGS = -fobjc-arc -w
XHSNative_STRIP_FLAGS = -x
XHSNative_FRAMEWORKS = UIKit Photos
XHSNative_LDFLAGS = -Wl,-install_name,@rpath/XHSNative.dylib
XHSNative_LOGOSFLAGS = -c generator=internal

include $(THEOS_MAKE_PATH)/tweak.mk

# 产物放到 packages 目录
after-all::
	@mkdir -p packages
	@cp $(THEOS_OBJ_DIR)/XHSNative.dylib packages/XHSNative-$(RELEASE_VERSION).dylib
	@echo -e "\033[32m==>\033[0m packages/XHSNative-$(RELEASE_VERSION).dylib"

# 打包时把 control 里的版本号同步成 Config.h 里的版本，免得两处对不上
before-package::
	@sed -i '' 's/^Version:.*/Version: $(RELEASE_VERSION)/' $(THEOS_STAGING_DIR)/DEBIAN/control

clean::
	@rm -rf .theos packages
