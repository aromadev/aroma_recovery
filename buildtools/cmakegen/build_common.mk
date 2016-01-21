$(shell echo -e "\n# $(LOCAL_MODULE)" >> $(CMAKELISTSTXT))

###########################################################
## Copy headers to the install tree
###########################################################
ifneq ($(strip $(LOCAL_IS_HOST_MODULE)),)
  my_prefix := HOST_
else
  my_prefix := TARGET_
endif

# Create a rule to copy each header, and make the
# all_copied_headers phony target depend on each
# destination header.  copy-one-header defines the
# actual rule.
#
$(foreach header,$(LOCAL_COPY_HEADERS), \
  $(eval _chFrom := $(LOCAL_PATH)/$(header)) \
  $(eval _chTo := \
      $(if $(LOCAL_COPY_HEADERS_TO),\
        $($(my_prefix)OUT_HEADERS)/$(LOCAL_COPY_HEADERS_TO)/$(notdir $(header)),\
        $($(my_prefix)OUT_HEADERS)/$(notdir $(header)))) \
  $(eval $(shell mkdir -p $(dir $(_chTo)))) \
  $(eval $(shell cp -f $(_chFrom) $(_chTo))) \
  $(eval all_copied_headers: $(_chTo)) \
 )
_chFrom :=
_chTo :=

# remove architectur suffix
# TODO: use detected architecture and remove others
LOCAL_SRC_FILES := $(addprefix $(LOCAL_PATH)/,$(foreach file,$(LOCAL_SRC_FILES),$(file:%.arm=%)))

# add empty.c for alias targets to make cmake happy
ifeq ($(LOCAL_SRC_FILES),)
EMPTY_C := $(dir $(CMAKELISTSTXT))/empty.c
$(shell echo "" > $(EMPTY_C))
LOCAL_SRC_FILES += $(EMPTY_C)
endif

# use WHOLE_STATIC libs as normal static libs
LOCAL_STATIC_LIBRARIES += $(LOCAL_WHOLE_STATIC_LIBRARIES)

# use SYSTEM_SHARED libs as normal shared libs
ifneq ($(LOCAL_SYSTEM_SHARED_LIBRARIES),none)
LOCAL_SHARED_LIBRARIES += $(LOCAL_SYSTEM_SHARED_LIBRARIES)
endif

# use SYSTEM_STATIC libs as normal static libs
ifneq ($(LOCAL_SYSTEM_STATIC_LIBRARIES),none)
LOCAL_STATIC_LIBRARIES += $(LOCAL_SYSTEM_STATIC_LIBRARIES)
endif

# remove 'lib' prefixes
LOCAL_STATIC_LIBRARIES := $(strip $(foreach lib,$(LOCAL_STATIC_LIBRARIES),$(lib:lib%=%)))
LOCAL_SHARED_LIBRARIES := $(strip $(foreach lib,$(LOCAL_SHARED_LIBRARIES),$(lib:lib%=%)))

# convert relative include directories to absolute ones
LOCAL_C_INCLUDES := $(foreach inc,$(LOCAL_C_INCLUDES),\
  $(eval firstchar := $$$(inc)) \
  $(eval firstchar := $(inc:$(firstchar)=)) \
  $(eval res := \
    $(if $(filter /,$(firstchar)),\
      $(inc),\
      $(GLOBAL_ANDROID_SOURCE_DIR)/$(inc)) \
  ) \
  $(res) \
 )
firstchar :=
res :=

# add source directory to include path
LOCAL_C_INCLUDES += $(LOCAL_PATH)

LOCAL_TOOLCHAIN_LIBS := c m

ifneq ($(LOCAL_FORCE_STATIC_EXECUTABLE),)
LOCAL_CFLAGS += -static -Wl,-static
LOCAL_CPPFLAGS += -static -Wl,-static
LOCAL_LDFLAGS += -static
endif

LOCAL_CFLAGS := $(subst $\",\\\",$(LOCAL_CFLAGS))
