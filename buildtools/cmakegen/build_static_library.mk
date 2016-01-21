include $(SCRIPTDIR)/build_common.mk

#LOCAL_MODULE := $(LOCAL_MODULE:lib%=%)
LOCAL_MODULE_LIBNAME := $(LOCAL_MODULE:lib%=%)
LOCAL_MODULE := $(LOCAL_MODULE_LIBNAME)

$(shell echo add_library\($(LOCAL_MODULE) STATIC $(LOCAL_SRC_FILES)\) >> $(CMAKELISTSTXT))

ifneq ($(LOCAL_CFLAGS),)
$(shell echo set_target_properties\($(LOCAL_MODULE) PROPERTIES COMPILE_FLAGS \"$(LOCAL_CFLAGS)\"\) >> $(CMAKELISTSTXT))
endif

ifneq ($(LOCAL_LDFLAGS),)
$(shell echo set_target_properties\($(LOCAL_MODULE) PROPERTIES LINK_FLAGS \"$(LOCAL_LDFLAGS)\"\) >> $(CMAKELISTSTXT))
endif

ifneq ($(LOCAL_C_INCLUDES),)
$(shell echo target_include_directories\($(LOCAL_MODULE) PUBLIC $(LOCAL_C_INCLUDES)\) >> $(CMAKELISTSTXT))
endif

ifneq ($(LOCAL_STATIC_LIBRARIES),)
$(shell echo target_link_libraries\($(LOCAL_MODULE) $(foreach lib,$(LOCAL_STATIC_LIBRARIES),$(lib:lib%=%))\) >> $(CMAKELISTSTXT))
ifneq ($(filter-out c m,$(LOCAL_STATIC_LIBRARIES)),)
$(shell echo add_dependencies\($(LOCAL_MODULE) $(filter-out c m,$(LOCAL_STATIC_LIBRARIES))\) >> $(CMAKELISTSTXT))
endif
endif

