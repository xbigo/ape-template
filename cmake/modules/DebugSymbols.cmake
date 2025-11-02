# DebugSymbols.cmake
# Configure separate debug symbols for all build types

if(MSVC)
    # For MSVC, always generate PDB files
    add_compile_options(/Zi)
    add_link_options(/DEBUG /OPT:REF /OPT:ICF)

    # Set PDB output directory
    set(CMAKE_COMPILE_PDB_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/symbols")
    set(CMAKE_PDB_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/symbols")

elseif(APPLE)
    # For Apple platforms, generate dSYM bundles
    add_compile_options(-g)

    if(CMAKE_BUILD_TYPE MATCHES "Release|RelWithDebInfo|MinSizeRel|SlowRelease")
        # Strip symbols from binaries but keep dSYM
        add_link_options(-Wl,-S)
    endif()

    # Create dSYM bundles
    set(CMAKE_XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT "dwarf-with-dsym")
    set(CMAKE_XCODE_ATTRIBUTE_DWARF_DSYM_FOLDER_PATH "${CMAKE_BINARY_DIR}/symbols")

elseif(UNIX)
    # For Linux and other Unix-like systems
    add_compile_options(-g -gdwarf-4)

    # Function to extract debug symbols
    function(extract_debug_symbols target_name)
        if(APE2_STRIP_SYMBOLS)
            add_custom_command(TARGET ${target_name} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_BINARY_DIR}/symbols"
                COMMAND ${CMAKE_OBJCOPY} --only-keep-debug
                    "$<TARGET_FILE:${target_name}>"
                    "${CMAKE_BINARY_DIR}/symbols/$<TARGET_FILE_NAME:${target_name}>.dbg"
                COMMAND ${CMAKE_OBJCOPY} --strip-debug
                    "$<TARGET_FILE:${target_name}>"
                COMMAND ${CMAKE_OBJCOPY}
                    --add-gnu-debuglink="${CMAKE_BINARY_DIR}/symbols/$<TARGET_FILE_NAME:${target_name}>.dbg"
                    "$<TARGET_FILE:${target_name}>"
                COMMENT "Extracting debug symbols for ${target_name}"
            )
        else()
            # Just copy debug symbols without stripping
            add_custom_command(TARGET ${target_name} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_BINARY_DIR}/symbols"
                COMMAND ${CMAKE_OBJCOPY} --only-keep-debug
                    "$<TARGET_FILE:${target_name}>"
                    "${CMAKE_BINARY_DIR}/symbols/$<TARGET_FILE_NAME:${target_name}>.dbg"
                COMMENT "Copying debug symbols for ${target_name}"
            )
        endif()
    endfunction()
endif()

message(STATUS "Debug symbols configuration enabled")

