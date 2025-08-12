# CMakeLists.txt for GPUPixel Objective-C Wrapper
cmake_minimum_required(VERSION 3.16)

project(GPUPixelObjCWrapper
    VERSION 1.0.0
    DESCRIPTION "Objective-C wrapper for GPUPixel library"
    LANGUAGES C CXX OBJC OBJCXX
)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set Objective-C++ standard
set(CMAKE_OBJCXX_STANDARD 17)
set(CMAKE_OBJCXX_STANDARD_REQUIRED ON)

# Platform detection
if(APPLE)
    if(IOS)
        set(PLATFORM_NAME "iOS")
        set(CMAKE_OSX_DEPLOYMENT_TARGET "12.0")
    else()
        set(PLATFORM_NAME "macOS")
        set(CMAKE_OSX_DEPLOYMENT_TARGET "10.15")
    endif()
    
    # Enable ARC for Objective-C code
    set(CMAKE_OBJCXX_FLAGS "${CMAKE_OBJCXX_FLAGS} -fobjc-arc")
    set(CMAKE_OBJC_FLAGS "${CMAKE_OBJC_FLAGS} -fobjc-arc")
else()
    message(FATAL_ERROR "GPUPixel Objective-C wrapper currently supports macOS and iOS only")
endif()

# Find required packages
find_package(PkgConfig REQUIRED)

# Include directories
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/GPUPixel
    ${CMAKE_CURRENT_SOURCE_DIR}/GPUPixel/Core
    ${CMAKE_CURRENT_SOURCE_DIR}/GPUPixel/Filter
    ${CMAKE_CURRENT_SOURCE_DIR}/GPUPixel/Source
    ${CMAKE_CURRENT_SOURCE_DIR}/GPUPixel/Sink
    ${CMAKE_CURRENT_SOURCE_DIR}/GPUPixel/FaceDetector
    ${CMAKE_CURRENT_SOURCE_DIR}/GPUPixel/Utils
    ${CMAKE_SOURCE_DIR}/include
    ${CMAKE_SOURCE_DIR}/include/gpupixel
)

# Collect source files
file(GLOB_RECURSE OBJC_WRAPPER_HEADERS
    "GPUPixel/**/*.h"
)

file(GLOB_RECURSE OBJC_WRAPPER_SOURCES
    "GPUPixel/**/*.mm"
    "GPUPixel/**/*.m"
)

# Group source files for IDEs
source_group("Header Files" FILES ${OBJC_WRAPPER_HEADERS})
source_group("Source Files" FILES ${OBJC_WRAPPER_SOURCES})

# Create the wrapper library
add_library(GPUPixelObjCWrapper STATIC
    ${OBJC_WRAPPER_HEADERS}
    ${OBJC_WRAPPER_SOURCES}
)

# Link against the main GPUPixel library
target_link_libraries(GPUPixelObjCWrapper
    PRIVATE
        gpupixel  # Main C++ library
)

# Platform-specific frameworks
if(APPLE)
    if(IOS)
        target_link_libraries(GPUPixelObjCWrapper
            PUBLIC
                "-framework Foundation"
                "-framework UIKit" 
                "-framework QuartzCore"
                "-framework Metal"
                "-framework MetalKit"
                "-framework OpenGLES"
                "-framework AVFoundation"
        )
    else()
        target_link_libraries(GPUPixelObjCWrapper
            PUBLIC
                "-framework Foundation"
                "-framework AppKit"
                "-framework QuartzCore" 
                "-framework Metal"
                "-framework MetalKit"
                "-framework OpenGL"
                "-framework AVFoundation"
        )
    endif()
endif()

# Compiler definitions
target_compile_definitions(GPUPixelObjCWrapper
    PRIVATE
        $<$<PLATFORM_ID:Darwin>:GPUPIXEL_MAC>
        $<$<BOOL:${IOS}>:GPUPIXEL_IOS>
)

# Compiler flags
target_compile_options(GPUPixelObjCWrapper
    PRIVATE
        $<$<COMPILE_LANGUAGE:OBJCXX>:-fobjc-arc>
        $<$<COMPILE_LANGUAGE:OBJC>:-fobjc-arc>
        $<$<COMPILE_LANGUAGE:CXX>:-Wall>
        $<$<COMPILE_LANGUAGE:CXX>:-Wextra>
        $<$<CONFIG:Debug>:-DDEBUG=1>
        $<$<CONFIG:Release>:-DNDEBUG=1>
)

# Export include directories
target_include_directories(GPUPixelObjCWrapper
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/GPUPixel>
        $<INSTALL_INTERFACE:include>
)

# Installation rules
install(TARGETS GPUPixelObjCWrapper
    EXPORT GPUPixelObjCWrapperTargets
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include
)

install(DIRECTORY GPUPixel/
    DESTINATION include/GPUPixel
    FILES_MATCHING PATTERN "*.h"
)

install(FILES "GPUPixel-Bridging-Header.h"
    DESTINATION include
)

# Generate and install CMake config files
include(CMakePackageConfigHelpers)

write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/GPUPixelObjCWrapperConfigVersion.cmake"
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)

export(EXPORT GPUPixelObjCWrapperTargets
    FILE "${CMAKE_CURRENT_BINARY_DIR}/GPUPixelObjCWrapperTargets.cmake"
)

configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/GPUPixelObjCWrapperConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/GPUPixelObjCWrapperConfig.cmake"
    @ONLY
)

install(EXPORT GPUPixelObjCWrapperTargets
    FILE GPUPixelObjCWrapperTargets.cmake
    DESTINATION lib/cmake/GPUPixelObjCWrapper
)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/GPUPixelObjCWrapperConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/GPUPixelObjCWrapperConfigVersion.cmake"
    DESTINATION lib/cmake/GPUPixelObjCWrapper
)

# Optional: Build examples
option(BUILD_OBJC_EXAMPLES "Build Objective-C examples" ON)

if(BUILD_OBJC_EXAMPLES)
    add_subdirectory(examples)
endif()

# Optional: Build tests
option(BUILD_OBJC_TESTS "Build Objective-C tests" OFF)

if(BUILD_OBJC_TESTS)
    add_subdirectory(tests)
endif()

# Print configuration summary
message(STATUS "=== GPUPixel Objective-C Wrapper Configuration ===")
message(STATUS "Platform: ${PLATFORM_NAME}")
message(STATUS "C++ Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "Install Prefix: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "Build Examples: ${BUILD_OBJC_EXAMPLES}")
message(STATUS "Build Tests: ${BUILD_OBJC_TESTS}")
message(STATUS "=======================================================")