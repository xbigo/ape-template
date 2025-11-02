# Utils library

set(UTILS_HEADERS
    ${CMAKE_SOURCE_DIR}/include/ape_template/utils/string_utils.hpp
)

set(UTILS_SOURCES
    string_utils.cpp
)

# Create utils library
add_library(ape_template_utils ${UTILS_SOURCES} ${UTILS_HEADERS})
add_library(ape_template::utils ALIAS ape_template_utils)

# Set target properties
set_target_properties(ape_template_utils PROPERTIES
    OUTPUT_NAME "ape_template_utils"
    VERSION ${PROJECT_VERSION}
    SOVERSION ${PROJECT_VERSION_MAJOR}
    CXX_STANDARD ${CMAKE_CXX_STANDARD}
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
)

# Include directories
target_include_directories(ape_template_utils
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}
)

# Link dependencies
target_link_libraries(ape_template_utils
    PUBLIC
        ape_template::core
    PRIVATE
        ape_template_warnings
)

# Extract debug symbols on Unix-like systems
if(UNIX AND NOT APPLE AND COMMAND extract_debug_symbols)
    extract_debug_symbols(ape_template_utils)
endif()

# Installation
if(APE_TEMPLATE_INSTALL)
    install(TARGETS ape_template_utils
        EXPORT ape-templateTargets
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    )
endif()

