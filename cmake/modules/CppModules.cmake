# CppModules.cmake
# Enable C++20/23 modules support

# Minimum compiler versions with full C++ modules support
set(APE2_MIN_CLANG_VERSION 19.1)
set(APE2_MIN_GCC_VERSION 15.2)
set(APE2_MIN_MSVC_VERSION 19.42)

# Check if the compiler supports C++ modules
if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL ${APE2_MIN_CLANG_VERSION})
        set(CMAKE_EXPERIMENTAL_CXX_MODULE_CMAKE_API "2182bf5c-ef0d-489a-91da-49dbc3090d2a")
        set(CMAKE_EXPERIMENTAL_CXX_MODULE_DYNDEP 1)
        message(STATUS "C++ modules support enabled (Clang ${CMAKE_CXX_COMPILER_VERSION})")
    else()
        message(FATAL_ERROR "Clang version ${CMAKE_CXX_COMPILER_VERSION} does not fully support C++ modules. Version ${APE2_MIN_CLANG_VERSION}+ required.")
    endif()

elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL ${APE2_MIN_GCC_VERSION})
        set(CMAKE_EXPERIMENTAL_CXX_MODULE_CMAKE_API "2182bf5c-ef0d-489a-91da-49dbc3090d2a")
        set(CMAKE_EXPERIMENTAL_CXX_MODULE_DYNDEP 1)
        message(STATUS "C++ modules support enabled (GCC ${CMAKE_CXX_COMPILER_VERSION})")
    else()
        message(FATAL_ERROR "GCC version ${CMAKE_CXX_COMPILER_VERSION} does not fully support C++ modules. Version ${APE2_MIN_GCC_VERSION}+ required.")
    endif()

elseif(MSVC)
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL ${APE2_MIN_MSVC_VERSION})
        set(CMAKE_EXPERIMENTAL_CXX_MODULE_CMAKE_API "2182bf5c-ef0d-489a-91da-49dbc3090d2a")
        set(CMAKE_EXPERIMENTAL_CXX_MODULE_DYNDEP 1)
        add_compile_options(/experimental:module /ifcOutput ${CMAKE_BINARY_DIR}/ifc)
        message(STATUS "C++ modules support enabled (MSVC ${CMAKE_CXX_COMPILER_VERSION})")
    else()
        message(FATAL_ERROR "MSVC version ${CMAKE_CXX_COMPILER_VERSION} does not fully support C++ modules. Version ${APE2_MIN_MSVC_VERSION}+ required.")
    endif()
else()
    message(WARNING "C++ modules support unknown for compiler: ${CMAKE_CXX_COMPILER_ID}")
endif()

