# Core library

set(CORE_HEADERS
    ${CMAKE_SOURCE_DIR}/include/ape_template/core/version.hpp
)

set(CORE_SOURCES
    version.cpp
)

# Create core library
add_library(ape_template_core ${CORE_SOURCES} ${CORE_HEADERS})
add_library(ape_template::core ALIAS ape_template_core)

# Set target properties
set_target_properties(ape_template_core PROPERTIES
    OUTPUT_NAME "ape_template_core"
    VERSION ${PROJECT_VERSION}
    SOVERSION ${PROJECT_VERSION_MAJOR}
    CXX_STANDARD ${CMAKE_CXX_STANDARD}
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
)

# Include directories
target_include_directories(ape_template_core
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}
)

# Link warnings
target_link_libraries(ape_template_core PRIVATE ape_template_warnings)

# Extract debug symbols on Unix-like systems
if(UNIX AND NOT APPLE AND COMMAND extract_debug_symbols)
    extract_debug_symbols(ape_template_core)
endif()

# Installation
if(APE_TEMPLATE_INSTALL)
    install(TARGETS ape_template_core
        EXPORT ape-templateTargets
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    )
endif()

