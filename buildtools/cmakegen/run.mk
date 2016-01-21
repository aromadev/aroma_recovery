CLEAR_VARS := $(SCRIPTDIR)/clear_vars.mk
BUILD_STATIC_LIBRARY := $(SCRIPTDIR)/build_static_library.mk
BUILD_SHARED_LIBRARY := $(SCRIPTDIR)/build_shared_library.mk
BUILD_EXECUTABLE := $(SCRIPTDIR)/build_executable.mk
HOST_OS := linux
HOST_OUT_HEADERS := $(GLOBAL_ANDROIDMK_DIR)/include-host
TARGET_OUT_HEADERS := $(GLOBAL_ANDROIDMK_DIR)/include-target
TARGET_USES_LOGD := false

# Figure out where we are.
define my-dir
$(strip \
  $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST))))) \
 )
endef

###########################################################
## Retrieve a list of all makefiles immediately below some directory
###########################################################

define all-makefiles-under
$(wildcard $(1)/*/Android.mk)
endef

###########################################################
## Retrieve a list of all makefiles immediately below your directory
## Must be called before including any other makefile!!
###########################################################

define all-subdir-makefiles
$(call all-makefiles-under,$(call my-dir))
endef


.PHONY: all
all:
	@true

$(shell rm -f $(CMAKELISTSTXT))
$(shell touch $(CMAKELISTSTXT))
include $(ANDROIDMK)

