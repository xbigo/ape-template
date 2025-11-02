cmake_minimum_required(VERSION 3.28)

# Project definition
project(ape-template
    VERSION 0.1.0
    DESCRIPTION "A comprehensive C++ project template with modern tooling"
    LANGUAGES CXX
)

# Add custom CMake modules path
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")

# ============================================================================
# Compiler Version Requirements
# ============================================================================

# Minimum compiler versions with full C++23 and modules support
set(APE_TEMPLATE_MIN_CLANG_VERSION 19.1)
set(APE_TEMPLATE_MIN_GCC_VERSION 15.2)
set(APE_TEMPLATE_MIN_MSVC_VERSION 19.42)

# Check compiler version
if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS ${APE_TEMPLATE_MIN_CLANG_VERSION})
        message(FATAL_ERROR "Clang ${APE_TEMPLATE_MIN_CLANG_VERSION}+ required, but found ${CMAKE_CXX_COMPILER_VERSION}")
    endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS ${APE_TEMPLATE_MIN_GCC_VERSION})
        message(FATAL_ERROR "GCC ${APE_TEMPLATE_MIN_GCC_VERSION}+ required, but found ${CMAKE_CXX_COMPILER_VERSION}")
    endif()
elseif(MSVC)
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS ${APE_TEMPLATE_MIN_MSVC_VERSION})
        message(FATAL_ERROR "MSVC ${APE_TEMPLATE_MIN_MSVC_VERSION}+ required, but found ${CMAKE_CXX_COMPILER_VERSION}")
    endif()
endif()

# ============================================================================
# Project Options
# ============================================================================

option(APE_TEMPLATE_BUILD_TESTS "Build tests" ON)
option(APE_TEMPLATE_BUILD_UNIT_TESTS "Build unit tests" ON)
option(APE_TEMPLATE_BUILD_REGRESSION_TESTS "Build regression tests" ON)
option(APE_TEMPLATE_BUILD_FUZZ_TESTS "Build fuzz tests" OFF)
option(APE_TEMPLATE_BUILD_BENCHMARKS "Build benchmark tests" ON)
option(APE_TEMPLATE_BUILD_DOCS "Build documentation with Doxygen" OFF)
option(APE_TEMPLATE_ENABLE_COVERAGE "Enable code coverage" OFF)
option(APE_TEMPLATE_ENABLE_SANITIZERS "Enable sanitizers" OFF)
option(APE_TEMPLATE_SANITIZER_TYPE "Type of sanitizer (address|memory|thread|undefined)" "address")
option(APE_TEMPLATE_STRIP_SYMBOLS "Strip symbols from shared libraries" OFF)
option(APE_TEMPLATE_ENABLE_DISTRIBUTED_BUILD "Enable distributed compilation" OFF)
option(APE_TEMPLATE_ENABLE_CLANG_TIDY "Enable clang-tidy" ON)
option(APE_TEMPLATE_USE_MODULES "Enable C++20/23 modules" ON)
option(APE_TEMPLATE_INSTALL "Enable local install target" ON)

# ============================================================================
# C++ Standard and Compiler Requirements
# ============================================================================

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Export compile commands for clang-tidy and other tools
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Separate debug symbols for all build types
if(NOT CMAKE_BUILD_TYPE MATCHES "Debug|Release|RelWithDebInfo|MinSizeRel|FastDebug|SlowRelease")
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Build type" FORCE)
endif()

# ============================================================================
# Custom Build Types
# ============================================================================

# FastDebug: Debug with O1 optimization
set(CMAKE_CXX_FLAGS_FASTDEBUG "${CMAKE_CXX_FLAGS_DEBUG}")
set(CMAKE_C_FLAGS_FASTDEBUG "${CMAKE_C_FLAGS_DEBUG}")
if(MSVC)
    string(REGEX REPLACE "/Od" "/O1" CMAKE_CXX_FLAGS_FASTDEBUG "${CMAKE_CXX_FLAGS_FASTDEBUG}")
    string(REGEX REPLACE "/Od" "/O1" CMAKE_C_FLAGS_FASTDEBUG "${CMAKE_C_FLAGS_FASTDEBUG}")
else()
    string(REGEX REPLACE "-O0" "-O1" CMAKE_CXX_FLAGS_FASTDEBUG "${CMAKE_CXX_FLAGS_FASTDEBUG}")
    string(REGEX REPLACE "-O0" "-O1" CMAKE_C_FLAGS_FASTDEBUG "${CMAKE_C_FLAGS_FASTDEBUG}")
endif()

# SlowRelease: Release with O0 (no optimization)
set(CMAKE_CXX_FLAGS_SLOWRELEASE "${CMAKE_CXX_FLAGS_RELEASE}")
set(CMAKE_C_FLAGS_SLOWRELEASE "${CMAKE_C_FLAGS_RELEASE}")
if(MSVC)
    string(REGEX REPLACE "/O2" "/Od" CMAKE_CXX_FLAGS_SLOWRELEASE "${CMAKE_CXX_FLAGS_SLOWRELEASE}")
    string(REGEX REPLACE "/O2" "/Od" CMAKE_C_FLAGS_SLOWRELEASE "${CMAKE_C_FLAGS_SLOWRELEASE}")
else()
    string(REGEX REPLACE "-O[0-3s]" "-O0" CMAKE_CXX_FLAGS_SLOWRELEASE "${CMAKE_CXX_FLAGS_SLOWRELEASE}")
    string(REGEX REPLACE "-O[0-3s]" "-O0" CMAKE_C_FLAGS_SLOWRELEASE "${CMAKE_C_FLAGS_SLOWRELEASE}")
endif()

# ============================================================================
# Compiler-Specific Settings
# ============================================================================

include(cmake/modules/CompilerWarnings.cmake)
include(cmake/modules/DebugSymbols.cmake)
include(cmake/modules/Sanitizers.cmake)

# Enable C++ modules if supported
if(APE_TEMPLATE_USE_MODULES)
    include(cmake/modules/CppModules.cmake)
endif()

# ============================================================================
# Third-Party Dependencies
# ============================================================================

include(cmake/modules/ThirdParty.cmake)

# ============================================================================
# Clang-Tidy Integration
# ============================================================================

if(APE_TEMPLATE_ENABLE_CLANG_TIDY)
    find_program(CLANG_TIDY_EXE NAMES "clang-tidy")
    if(CLANG_TIDY_EXE)
        set(CMAKE_CXX_CLANG_TIDY "${CLANG_TIDY_EXE}")
        message(STATUS "clang-tidy found: ${CLANG_TIDY_EXE}")
    else()
        message(WARNING "clang-tidy not found")
    endif()
endif()

# ============================================================================
# Distributed Compilation Support
# ============================================================================

if(APE_TEMPLATE_ENABLE_DISTRIBUTED_BUILD)
    include(cmake/modules/DistributedBuild.cmake)
endif()

# ============================================================================
# Project Subdirectories
# ============================================================================

# Main library
add_subdirectory(src)

# Tests
if(APE_TEMPLATE_BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()

# Documentation
if(APE_TEMPLATE_BUILD_DOCS)
    add_subdirectory(docs)
endif()

# ============================================================================
# Installation
# ============================================================================

if(APE_TEMPLATE_INSTALL)
    include(GNUInstallDirs)
    include(CMakePackageConfigHelpers)

    # Install headers
    install(DIRECTORY include/ape_template
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp"
    )

    # Generate and install CMake config files
    write_basic_package_version_file(
        "${CMAKE_CURRENT_BINARY_DIR}/ape-templateConfigVersion.cmake"
        VERSION ${PROJECT_VERSION}
        COMPATIBILITY SameMajorVersion
    )

    configure_package_config_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake/ape-templateConfig.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/ape-templateConfig.cmake"
        INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/ape-template
    )

    install(FILES
        "${CMAKE_CURRENT_BINARY_DIR}/ape-templateConfig.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/ape-templateConfigVersion.cmake"
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/ape-template
    )
endif()

# ============================================================================
# Project Summary
# ============================================================================

message(STATUS "")
message(STATUS "========================================")
message(STATUS "  ape-template ${PROJECT_VERSION}")
message(STATUS "========================================")
message(STATUS "  Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "  C++ Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "  Compiler: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "  System: ${CMAKE_SYSTEM_NAME} ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "")
message(STATUS "  Build tests: ${APE_TEMPLATE_BUILD_TESTS}")
message(STATUS "  Build documentation: ${APE_TEMPLATE_BUILD_DOCS}")
message(STATUS "  Enable coverage: ${APE_TEMPLATE_ENABLE_COVERAGE}")
message(STATUS "  Enable sanitizers: ${APE_TEMPLATE_ENABLE_SANITIZERS}")
if(APE_TEMPLATE_ENABLE_SANITIZERS)
    message(STATUS "  Sanitizer type: ${APE_TEMPLATE_SANITIZER_TYPE}")
endif()
message(STATUS "  Enable clang-tidy: ${APE_TEMPLATE_ENABLE_CLANG_TIDY}")
message(STATUS "  Use C++ modules: ${APE_TEMPLATE_USE_MODULES}")
message(STATUS "  Strip symbols: ${APE_TEMPLATE_STRIP_SYMBOLS}")
message(STATUS "  Distributed build: ${APE_TEMPLATE_ENABLE_DISTRIBUTED_BUILD}")
message(STATUS "========================================")
message(STATUS "")

