# Documentation generation with Doxygen

find_package(Doxygen)

if(DOXYGEN_FOUND)
    # Configure Doxyfile
    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in
        ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
        @ONLY
    )

    # Add doc target
    add_custom_target(doc
        COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Generating API documentation with Doxygen"
        VERBATIM
    )

    # Add all target that includes documentation
    add_custom_target(doc_all
        DEPENDS doc
        COMMENT "Building everything including documentation"
    )

    message(STATUS "Doxygen found: ${DOXYGEN_EXECUTABLE}")
    message(STATUS "Documentation target 'doc' available")
else()
    message(STATUS "Doxygen not found, documentation target unavailable")
endif()

