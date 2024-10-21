TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e
SYSROOT = $(THEOS)/sdks/iPhoneOS14.5.sdk
DEBUG = 1
FINALPACKAGE = 0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CarFlex

CarFlex_FILES = CarFlex.xm
CarFlex_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 CarPlay"
