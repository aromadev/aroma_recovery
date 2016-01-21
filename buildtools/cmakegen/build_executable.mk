include $(SCRIPTDIR)/build_common.mk

LOCAL_MODULE_BINARY := $(LOCAL_MODULE)
LOCAL_MODULE := $(LOCAL_MODULE)_executable

$(shell echo add_executable\($(LOCAL_MODULE) $(LOCAL_SRC_FILES)\) >> $(CMAKELISTSTXT))
$(shell echo set_target_properties\($(LOCAL_MODULE) PROPERTIES OUTPUT_NAME $(LOCAL_MODULE_BINARY)\) >> $(CMAKELISTSTXT))

ifneq ($(LOCAL_CFLAGS),)
$(shell echo set_target_properties\($(LOCAL_MODULE) PROPERTIES COMPILE_FLAGS \"$(LOCAL_CFLAGS)\"\) >> $(CMAKELISTSTXT))
endif

#ifneq ($(LOCAL_CPPFLAGS),)
#$(shell echo set_target_properties\($(LOCAL_MODULE) PROPERTIES COMPILE_FLAGS \"$(LOCAL_CPPFLAGS)\"\) >> $(CMAKELISTSTXT))
#endif

ifneq ($(LOCAL_LDFLAGS),)
$(shell echo set_target_properties\($(LOCAL_MODULE) PROPERTIES LINK_FLAGS \"$(LOCAL_LDFLAGS)\"\) >> $(CMAKELISTSTXT))
endif

ifneq ($(LOCAL_C_INCLUDES),)
$(shell echo target_include_directories\($(LOCAL_MODULE) PUBLIC $(LOCAL_C_INCLUDES)\) >> $(CMAKELISTSTXT))
endif

LOCAL_SHARED_LIBS_WITHOUT_TOOLCHAIN := $(filter-out $(LOCAL_TOOLCHAIN_LIBS),$(LOCAL_SHARED_LIBRARIES))
LOCAL_SHARED_LIBS_WITHOUT_TOOLCHAIN := $(foreach lib,$(LOCAL_SHARED_LIBS_WITHOUT_TOOLCHAIN),$(lib:%=%_shared))
LOCAL_SHARED_LIBS_TOOLCHAIN := $(filter $(LOCAL_TOOLCHAIN_LIBS),$(LOCAL_SHARED_LIBRARIES))
LOCAL_ALL_LIBS := $(strip $(LOCAL_STATIC_LIBRARIES) $(LOCAL_SHARED_LIBS_WITHOUT_TOOLCHAIN) $(LOCAL_SHARED_LIBS_TOOLCHAIN))
ifneq ($(LOCAL_ALL_LIBS),)
$(shell echo target_link_libraries\($(LOCAL_MODULE) $(LOCAL_ALL_LIBS)\) >> $(CMAKELISTSTXT))
endif

ifneq ($(filter-out $(LOCAL_TOOLCHAIN_LIBS),$(LOCAL_ALL_LIBS)),)
$(shell echo add_dependencies\($(LOCAL_MODULE) $(filter-out $(LOCAL_TOOLCHAIN_LIBS),$(LOCAL_ALL_LIBS))\) >> $(CMAKELISTSTXT))
endif
