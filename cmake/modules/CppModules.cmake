# CppModules.cmake
#
# Sets up CMake's C++ named-module infrastructure (dependency scanning / dyndep).
# This is distinct from 'import std;' support, which is handled by ImportStd.cmake.
#
# In CMake 3.30+ named modules are stable; the experimental UUID is not needed.
# In CMake 3.28-3.29 the experimental API must be unlocked with the UUID below.
#
# GCC note: dyndep injects flags (-fmodule-mapper, -fdeps-format=p1689r5,
# -fmodules-ts) into every compile command.  clang-tidy's Clang front-end does
# not recognise these flags and exits with a hard driver error ("unknown argument")
# — there is no -W flag that can suppress driver errors, so the only fix is to
# not enable dyndep when clang-tidy is active.  Consequence: CMake cannot track
# inter-module build ordering automatically for GCC+clang-tidy builds.  This is
# harmless unless the project defines `export module` interface units.
# → To use C++ module interface units with GCC, disable clang-tidy:
#     APE_TEMPLATE_ENABLE_CLANG_TIDY=OFF  (see presets: linux-gcc-*-import-std)

cmake_minimum_required(VERSION 3.30)

# Minimum compiler versions with full C++ modules support
set(APE_TEMPLATE_MIN_CLANG_VERSION 19.1)
set(APE_TEMPLATE_MIN_GCC_VERSION 15.2)
set(APE_TEMPLATE_MIN_MSVC_VERSION 19.42)

# ─── CMake 3.30+: modules are stable; no UUID or dyndep flag needed ──────────
if(CMAKE_VERSION VERSION_GREATER_EQUAL "3.30")
    message(STATUS "C++ modules: stable API (CMake ${CMAKE_VERSION}), dyndep managed automatically")
    return()
endif()

# ─── CMake 3.28 / 3.29: experimental module API ──────────────────────────────
if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL ${APE_TEMPLATE_MIN_CLANG_VERSION})
        set(CMAKE_EXPERIMENTAL_CXX_MODULE_CMAKE_API "2182bf5c-ef0d-489a-91da-49dbc3090d2a")
        set(CMAKE_EXPERIMENTAL_CXX_MODULE_DYNDEP 1)
        message(STATUS "C++ modules support enabled (Clang ${CMAKE_CXX_COMPILER_VERSION})")
    else()
        message(FATAL_ERROR
            "Clang ${CMAKE_CXX_COMPILER_VERSION} does not fully support C++ modules. "
            "Version ${APE_TEMPLATE_MIN_CLANG_VERSION}+ required.")
    endif()

elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL ${APE_TEMPLATE_MIN_GCC_VERSION})
        if(APE_TEMPLATE_ENABLE_CLANG_TIDY)
            # Dyndep disabled: see module-level comment above for explanation.
            message(STATUS
                "C++ modules enabled (GCC ${CMAKE_CXX_COMPILER_VERSION}), "
                "dyndep scanning disabled for clang-tidy compatibility. "
                "Set APE_TEMPLATE_ENABLE_CLANG_TIDY=OFF to enable full module dyndep.")
        else()
            set(CMAKE_EXPERIMENTAL_CXX_MODULE_CMAKE_API "2182bf5c-ef0d-489a-91da-49dbc3090d2a")
            set(CMAKE_EXPERIMENTAL_CXX_MODULE_DYNDEP 1)
            message(STATUS "C++ modules support enabled (GCC ${CMAKE_CXX_COMPILER_VERSION})")
        endif()
    else()
        message(FATAL_ERROR
            "GCC ${CMAKE_CXX_COMPILER_VERSION} does not fully support C++ modules. "
            "Version ${APE_TEMPLATE_MIN_GCC_VERSION}+ required.")
    endif()

elseif(MSVC)
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL ${APE_TEMPLATE_MIN_MSVC_VERSION})
        set(CMAKE_EXPERIMENTAL_CXX_MODULE_CMAKE_API "2182bf5c-ef0d-489a-91da-49dbc3090d2a")
        set(CMAKE_EXPERIMENTAL_CXX_MODULE_DYNDEP 1)
        add_compile_options(/experimental:module /ifcOutput ${CMAKE_BINARY_DIR}/ifc)
        message(STATUS "C++ modules support enabled (MSVC ${CMAKE_CXX_COMPILER_VERSION})")
    else()
        message(FATAL_ERROR
            "MSVC ${CMAKE_CXX_COMPILER_VERSION} does not fully support C++ modules. "
            "Version ${APE_TEMPLATE_MIN_MSVC_VERSION}+ required.")
    endif()

else()
    message(WARNING "C++ modules support unknown for compiler: ${CMAKE_CXX_COMPILER_ID}")
endif()
