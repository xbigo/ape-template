# ThirdParty.cmake
# Third-party dependency management

# Option to choose package manager
set(APE2_PACKAGE_MANAGER "conan" CACHE STRING "Package manager to use (conan|vcpkg|none)")
set_property(CACHE APE2_PACKAGE_MANAGER PROPERTY STRINGS conan vcpkg none)

# Patch directory
set(APE2_PATCHES_DIR "${CMAKE_SOURCE_DIR}/patches")

# Function to apply patches
function(apply_patch library_name patch_file)
    if(EXISTS "${APE2_PATCHES_DIR}/${library_name}/${patch_file}")
        message(STATUS "Applying patch ${patch_file} to ${library_name}")
        execute_process(
            COMMAND git apply "${APE2_PATCHES_DIR}/${library_name}/${patch_file}"
            WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/_deps/${library_name}-src"
            RESULT_VARIABLE PATCH_RESULT
        )
        if(NOT PATCH_RESULT EQUAL 0)
            message(WARNING "Failed to apply patch ${patch_file} to ${library_name}")
        endif()
    endif()
endfunction()

if(APE2_PACKAGE_MANAGER STREQUAL "conan")
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

elseif(APE2_PACKAGE_MANAGER STREQUAL "vcpkg")
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

