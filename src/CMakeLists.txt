# Source directory

# Core library
add_subdirectory(core)

# Utilities library
add_subdirectory(utils)

# Create an interface library that links all components
add_library(ape-template INTERFACE)
target_link_libraries(ape-template INTERFACE
    ape_template::core
    ape_template::utils
)

# Add alias for consistent naming
add_library(ape_template::ape-template ALIAS ape-template)

# Installation
if(APE_TEMPLATE_INSTALL)
    install(TARGETS ape-template
        EXPORT ape-templateTargets
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    )

    install(EXPORT ape-templateTargets
        FILE ape-templateTargets.cmake
        NAMESPACE ape_template::
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/ape-template
    )
endif()

