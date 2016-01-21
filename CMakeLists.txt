cmake_minimum_required(VERSION 2.8)

# Project Config
project(aroma_recovery)

# global configs
include_directories(
    ${PROJECT_SOURCE_DIR}/include
    ${PROJECT_SOURCE_DIR}/include/arch/linux-arm
    ${PROJECT_SOURCE_DIR}/android/system/core/include
    ${PROJECT_SOURCE_DIR}/android/system/core/logwrapper/include
    ${PROJECT_SOURCE_DIR}/android/system/core/libsparse/include
    ${PROJECT_SOURCE_DIR}/android/system/core/base/include
    ${CMAKE_CURRENT_SOURCE_DIR}/../libaroma/include
    ${CMAKE_CURRENT_BINARY_DIR}/androidmk/include-target
)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -include AndroidConfig.h -D__USE_BSD=1")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -include AndroidConfig.h -D__USE_BSD=1 -std=gnu++11")

# recovery
file(GLOB AR_SRCS src/*.c)
add_executable(recovery ${AR_SRCS})
target_link_libraries(recovery)

# cflags
set_target_properties(recovery PROPERTIES COMPILE_FLAGS "-Wall -Wextra -Wshadow -Werror")

function(compile_androidmk path)
    get_filename_component(cmakegensubdir ${path} DIRECTORY)
    set(cmakegendir ${CMAKE_CURRENT_BINARY_DIR}/androidmk/${cmakegensubdir})
    file(MAKE_DIRECTORY ${cmakegendir})
    file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/androidmk/include-host)
    file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/androidmk/include-target)
    execute_process(
        COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/buildtools/cmakegen/gen_cmake_from_androidmk.sh
            ${CMAKE_CURRENT_SOURCE_DIR}/${path}
            ${cmakegendir}/CMakeLists.txt
            ${CMAKE_CURRENT_BINARY_DIR}/androidmk
            ${CMAKE_CURRENT_SOURCE_DIR}/android
        RESULT_VARIABLE cmd_res
        ERROR_VARIABLE  cmd_err
        OUTPUT_VARIABLE cmd_out
    )
    if(NOT "${cmd_res}" STREQUAL "0")
      message(FATAL_ERROR "Can't parse ${cmd_res}:\n${cmd_err}")
    endif()

    add_subdirectory(${cmakegendir})
endfunction()

# libs
compile_androidmk(android/system/core/liblog/Android.mk)
compile_androidmk(android/system/core/libcutils/Android.mk)
compile_androidmk(android/system/core/fs_mgr/Android.mk)
compile_androidmk(android/system/core/logwrapper/Android.mk)
compile_androidmk(android/system/core/libsparse/Android.mk)
compile_androidmk(android/external/e2fsprogs/Android.mk)
compile_androidmk(android/system/extras/squashfs_utils/Android.mk)
compile_androidmk(android/external/libselinux/Android.mk)
compile_androidmk(android/external/pcre/Android.mk)
compile_androidmk(android/system/extras/ext4_utils/Android.mk)
compile_androidmk(android/system/core/libmincrypt/Android.mk)
compile_androidmk(android/external/zlib/Android.mk)
compile_androidmk(android/external/lzma/xz-embedded/Android.mk)
compile_androidmk(android/external/safe-iop/Android.mk)
compile_androidmk(android/system/core/base/Android.mk)
#compile_androidmk(android/system/core/adb/Android.mk)

compile_androidmk(libs/minzip/Android.mk)
compile_androidmk(libs/mtdutils/Android.mk)
