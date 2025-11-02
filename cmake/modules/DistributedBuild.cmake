# DistributedBuild.cmake
# Enable distributed compilation

if(APE2_ENABLE_DISTRIBUTED_BUILD)
    if(MSVC)
        # Find IncrediBuild for MSVC
        find_program(INCREDIBUILD_EXE NAMES BuildConsole)
        if(INCREDIBUILD_EXE)
            message(STATUS "IncrediBuild found: ${INCREDIBUILD_EXE}")
            set(CMAKE_VS_GLOBALS "UseMultiToolTask=true")
        else()
            message(WARNING "IncrediBuild not found. Distributed build disabled for MSVC.")
        endif()

    elseif(UNIX)
        # Find distcc for Unix-like systems
        find_program(DISTCC_EXE NAMES distcc)
        if(DISTCC_EXE)
            message(STATUS "distcc found: ${DISTCC_EXE}")
            set(CMAKE_C_COMPILER_LAUNCHER "${DISTCC_EXE}")
            set(CMAKE_CXX_COMPILER_LAUNCHER "${DISTCC_EXE}")
        else()
            # Try ccache as alternative
            find_program(CCACHE_EXE NAMES ccache)
            if(CCACHE_EXE)
                message(STATUS "ccache found: ${CCACHE_EXE}")
                set(CMAKE_C_COMPILER_LAUNCHER "${CCACHE_EXE}")
                set(CMAKE_CXX_COMPILER_LAUNCHER "${CCACHE_EXE}")
            else()
                message(WARNING "Neither distcc nor ccache found. Distributed build disabled.")
            endif()
        endif()
    endif()
endif()

