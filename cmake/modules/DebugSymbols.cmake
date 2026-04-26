# DebugSymbols.cmake
# Separate debug symbols from binaries for ALL build types.
#
# After every add_library / add_executable call, invoke:
#   extract_debug_symbols(<target>)
#
# What each platform does:
#   MSVC  — /Zi writes a PDB alongside each .obj; /DEBUG collects them into a
#            final PDB stored in build/symbols/.  extract_debug_symbols() is a
#            no-op because the toolchain handles everything automatically.
#   Apple — dsymutil reads the DWARF N_OSO debug map and produces a .dSYM
#            bundle in build/symbols/; strip -S then removes DWARF from the
#            binary while preserving LC_UUID so debuggers can find the bundle.
#   Unix  — objcopy extracts DWARF into a .dbg sidecar in build/symbols/,
#            strips the binary, and embeds a GNU debuglink pointing at the
#            sidecar so gdb/lldb can load it automatically.

if(MSVC)
    add_compile_options(/Zi)
    add_link_options(/DEBUG /OPT:REF /OPT:ICF)
    set(CMAKE_COMPILE_PDB_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/symbols")
    set(CMAKE_PDB_OUTPUT_DIRECTORY         "${CMAKE_BINARY_DIR}/symbols")

    function(extract_debug_symbols target_name)
        # PDB files are produced globally by /Zi + /DEBUG; nothing to do per target.
    endfunction()

elseif(APPLE)
    add_compile_options(-g)

    find_program(DSYMUTIL  dsymutil REQUIRED)
    find_program(STRIP_CMD strip    REQUIRED)

    function(extract_debug_symbols target_name)
        set(_sym_dir "${CMAKE_BINARY_DIR}/symbols")
        add_custom_command(TARGET ${target_name} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E make_directory "${_sym_dir}"
            # Build a .dSYM bundle by following the N_OSO debug map in the binary
            # to locate the object files that hold the actual DWARF sections.
            COMMAND "${DSYMUTIL}" "$<TARGET_FILE:${target_name}>"
                    -o "${_sym_dir}/$<TARGET_FILE_NAME:${target_name}>.dSYM"
            # Remove DWARF and N_OSO entries from the binary.
            # LC_UUID is intentionally kept so debuggers can match the binary
            # to its .dSYM bundle by UUID.
            COMMAND "${STRIP_CMD}" -S "$<TARGET_FILE:${target_name}>"
            COMMENT "Extracting debug symbols for ${target_name} → symbols/"
        )
    endfunction()

    # When building with the Xcode generator, also configure the native
    # dSYM output so Xcode's own tooling stays consistent.
    set(CMAKE_XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT "dwarf-with-dsym")
    set(CMAKE_XCODE_ATTRIBUTE_DWARF_DSYM_FOLDER_PATH "${CMAKE_BINARY_DIR}/symbols")

elseif(UNIX)
    add_compile_options(-g -gdwarf-4)

    function(extract_debug_symbols target_name)
        set(_sym_dir  "${CMAKE_BINARY_DIR}/symbols")
        set(_dbg_file "${_sym_dir}/$<TARGET_FILE_NAME:${target_name}>.dbg")
        add_custom_command(TARGET ${target_name} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E make_directory "${_sym_dir}"
            # Copy only the debug sections into a sidecar file.
            COMMAND ${CMAKE_OBJCOPY} --only-keep-debug
                    "$<TARGET_FILE:${target_name}>" "${_dbg_file}"
            # Strip those debug sections from the binary.
            COMMAND ${CMAKE_OBJCOPY} --strip-debug
                    "$<TARGET_FILE:${target_name}>"
            # Embed a GNU debuglink so gdb/lldb finds the sidecar automatically.
            COMMAND ${CMAKE_OBJCOPY}
                    --add-gnu-debuglink="${_dbg_file}"
                    "$<TARGET_FILE:${target_name}>"
            COMMENT "Extracting debug symbols for ${target_name} → symbols/"
        )
    endfunction()

endif()

message(STATUS "Debug symbols configuration enabled (separate, build/symbols/)")
