# ThirdParty.cmake
# Third-party dependency management

# ============================================================================
# ape_suppress_3rdparty_warnings(<target> [<target2> ...])
#
# Silences compiler and clang-tidy diagnostics for third-party targets without
# touching the project's own warning settings (ape_template::warnings).
#
# Three suppression layers are applied:
#   1. SYSTEM ON  (CMake 3.25+) — marks the target's include directories as
#      "system" headers so project code that #includes them does not produce
#      warnings (equivalent to -isystem / /external:I).
#   2. CXX_CLANG_TIDY "" — clears the global CMAKE_CXX_CLANG_TIDY value for
#      this target so clang-tidy does not run on third-party source files.
#   3. Warning-flag stripping / silencing — behaviour differs by compiler:
#
#      GCC / Clang: -w is appended as a PRIVATE (or INTERFACE) compile option.
#        This silently overrides any warning flags and produces no diagnostics.
#
#      MSVC: we cannot use /w universally because some libraries (e.g. Google
#        Benchmark) modify CMAKE_CXX_FLAGS *inside their own subdirectory* with
#        `set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4")`.  That /W4 is baked
#        into the compile command at generate time and cannot be stripped via
#        target properties.  Appending /w after it triggers D9025 ("overriding
#        '/W4' with '/w'").  Instead we:
#          a) Strip warning flags from the deprecated COMPILE_FLAGS string
#             property (used by googletest via set_target_properties COMPILE_FLAGS).
#          b) Strip warning flags from the COMPILE_OPTIONS list property.
#          c) Do NOT append /w — libraries that bake /W4 into CMAKE_CXX_FLAGS
#             compile at that level, which is fine for well-maintained projects.
#             If a library produces MSVC warnings this way, apply a patch via
#             PATCH_COMMAND in FetchContent_Declare to remove the offending line.
# ============================================================================
function(ape_suppress_3rdparty_warnings)
    foreach(_target IN LISTS ARGN)
        if(NOT TARGET ${_target})
            message(WARNING "ape_suppress_3rdparty_warnings: '${_target}' is not a target — skipped")
            continue()
        endif()

        # Layer 1: system headers — suppresses warnings when project code
        # includes this library's headers.
        set_target_properties(${_target} PROPERTIES SYSTEM ON)

        # Layer 2: disable clang-tidy — CMAKE_CXX_CLANG_TIDY is global and
        # would otherwise be inherited by every FetchContent target.
        set_target_properties(${_target} PROPERTIES CXX_CLANG_TIDY "")

        get_target_property(_type ${_target} TYPE)

        # Layer 3a (MSVC only): strip warning-level flags from the deprecated
        # COMPILE_FLAGS string property (googletest uses this).
        if(MSVC AND NOT _type STREQUAL "INTERFACE_LIBRARY")
            get_target_property(_cflags ${_target} COMPILE_FLAGS)
            if(_cflags)
                # Prepend a space so the regex reliably matches flags at position 0.
                string(PREPEND _cflags " ")
                string(REGEX REPLACE " [-/]W[0-4x]" " " _cflags "${_cflags}")
                string(REGEX REPLACE " [-/]WX"       " " _cflags "${_cflags}")
                string(REGEX REPLACE " [-/]Wall"      " " _cflags "${_cflags}")
                string(STRIP "${_cflags}" _cflags)
                set_target_properties(${_target} PROPERTIES COMPILE_FLAGS "${_cflags}")
            endif()
        endif()

        # Layer 3b (MSVC only): strip warning-level flags from COMPILE_OPTIONS
        # (or INTERFACE_COMPILE_OPTIONS for header-only targets).
        if(MSVC)
            if(_type STREQUAL "INTERFACE_LIBRARY")
                set(_opts_prop INTERFACE_COMPILE_OPTIONS)
            else()
                set(_opts_prop COMPILE_OPTIONS)
            endif()
            get_target_property(_copts ${_target} ${_opts_prop})
            if(_copts)
                list(FILTER _copts EXCLUDE REGEX "^[-/]W[0-4x]$|^[-/]WX$|^[-/]Wall$")
                set_target_properties(${_target} PROPERTIES ${_opts_prop} "${_copts}")
            endif()
        endif()

        # Layer 3c (GCC / Clang): append -w to silence all warnings.
        # Skipped on MSVC — see the explanation in the header comment above.
        if(NOT MSVC)
            if(_type STREQUAL "INTERFACE_LIBRARY")
                target_compile_options(${_target} INTERFACE -w)
            else()
                target_compile_options(${_target} PRIVATE -w)
            endif()
        endif()

    endforeach()
endfunction()

# Option to choose package manager
set(APE_TEMPLATE_PACKAGE_MANAGER "conan" CACHE STRING "Package manager to use (conan|vcpkg|none)")
set_property(CACHE APE_TEMPLATE_PACKAGE_MANAGER PROPERTY STRINGS conan vcpkg none)

# Patch directory
set(APE_TEMPLATE_PATCHES_DIR "${CMAKE_SOURCE_DIR}/patches")

# Function to apply patches
function(apply_patch library_name patch_file)
    if(EXISTS "${APE_TEMPLATE_PATCHES_DIR}/${library_name}/${patch_file}")
        message(STATUS "Applying patch ${patch_file} to ${library_name}")
        execute_process(
            COMMAND git apply "${APE_TEMPLATE_PATCHES_DIR}/${library_name}/${patch_file}"
            WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/_deps/${library_name}-src"
            RESULT_VARIABLE PATCH_RESULT
        )
        if(NOT PATCH_RESULT EQUAL 0)
            message(WARNING "Failed to apply patch ${patch_file} to ${library_name}")
        endif()
    endif()
endfunction()

if(APE_TEMPLATE_PACKAGE_MANAGER STREQUAL "conan")
    # Conan setup
    if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
        message(STATUS "Downloading conan.cmake")
        file(DOWNLOAD
            "https://raw.githubusercontent.com/conan-io/cmake-conan/0.18.1/conan.cmake"
            "${CMAKE_BINARY_DIR}/conan.cmake"
            TLS_VERIFY ON
        )
    endif()

    include(${CMAKE_BINARY_DIR}/conan.cmake)

    # Conan configuration will be added here
    message(STATUS "Using Conan for dependency management")

elseif(APE_TEMPLATE_PACKAGE_MANAGER STREQUAL "vcpkg")
    # vcpkg setup
    if(DEFINED ENV{VCPKG_ROOT})
        set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake" CACHE STRING "Vcpkg toolchain file")
        message(STATUS "Using vcpkg for dependency management")
    else()
        message(WARNING "VCPKG_ROOT not set. Please set environment variable or use another package manager.")
    endif()

else()
    message(STATUS "Using CMake FetchContent for dependency management")
    include(FetchContent)
endif()

# Common dependencies
# Uncomment and configure as needed

# Example: Boost
# find_package(Boost 1.80 REQUIRED COMPONENTS system filesystem)

# Example: SQLite
# find_package(SQLite3 REQUIRED)

# Example: zlib
# find_package(ZLIB REQUIRED)

# Add more dependencies as needed

