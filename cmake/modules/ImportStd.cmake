# ImportStd.cmake
#
# Provides configure_import_std(<target>) which enables 'import std;'
# (C++23 standard library named module) on supported targets.
#
# Prerequisites
#   CMake 3.30+           — CXX_MODULE_STD target property (stable API)
#   APE_TEMPLATE_IMPORT_STD=ON  — opt-in; off by default
#
# Platform support matrix
#
#   Compiler                      Status      Notes
#   ──────────────────────────    ─────────   ──────────────────────────────────
#   MSVC 19.35+ (VS 2022 17.5+)  Full        std.ixx ships with VS; CMake 3.30
#                                             finds and compiles it automatically
#   Clang 18+   + libc++          Full        Switches the whole project to libc++
#               (Linux / BSD)                 (libstdc++ and libc++ are ABI-
#                                             incompatible; mixing is not safe).
#                                             Requires: apt install libc++-18-dev
#                                             clang-tidy disabled (see note below)
#   GCC 15.2+   (clang-tidy OFF)  Experimental  Needs dyndep; CppModules.cmake
#                                             enables it when tidy is off.
#   GCC 15.2+   (clang-tidy ON)   Unsupported   dyndep/tidy conflict; choose one.
#   Apple Clang (any)             Unsupported   Not supported in Xcode ≤ 16.
#   Android NDK / Emscripten      Unsupported   —
#
# Clang + clang-tidy note (CMake 4.3+)
#   When CXX_MODULE_STD is set on any target, CMake creates an internal target
#   __cmake_cxx23 to compile the std module.  On CMake 4.3.1+ when the libc++
#   module package is not installed, CMake falls back to GCC's bits/std.cc as
#   the module source.  If clang-tidy runs on that file while -stdlib=libc++ is
#   in scope, it produces a hard driver error:
#     fatal error: 'bits/stdc++.h' file not found
#   because bits/stdc++.h is a libstdc++ header absent from libc++'s paths.
#   The linux-clang-*-import-std presets therefore set APE_TEMPLATE_ENABLE_CLANG_TIDY=OFF.
#   A deferred cmake_language(DEFER ...) call below provides a belt-and-suspenders
#   guard by explicitly clearing CXX_CLANG_TIDY on __cmake_cxx23 if it exists.
#
# Usage in src/CMakeLists.txt
#   configure_import_std(<target>)   # no-op when unsupported

cmake_minimum_required(VERSION 3.30)

# ─── MSVC ─────────────────────────────────────────────────────────────────────
if(MSVC)
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "19.35")
        message(STATUS
            "import std: MSVC ${CMAKE_CXX_COMPILER_VERSION} < 19.35 — "
            "requires Visual Studio 2022 17.5+")
        function(configure_import_std target)
        endfunction()
        return()
    endif()

    message(STATUS "import std: enabled — MSVC ${CMAKE_CXX_COMPILER_VERSION}")
    function(configure_import_std target)
        # CMake 3.30 locates std.ixx from the VS installation and compiles it
        # as a module dependency of this target automatically.
        set_property(TARGET ${target} PROPERTY CXX_MODULE_STD 1)
    endfunction()

# ─── Clang on Linux / non-Apple ───────────────────────────────────────────────
elseif(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang" AND NOT APPLE)
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "18")
        message(STATUS
            "import std: Clang ${CMAKE_CXX_COMPILER_VERSION} < 18 — not supported")
        function(configure_import_std target)
        endfunction()
        return()
    endif()

    message(STATUS
        "import std: enabled — Clang ${CMAKE_CXX_COMPILER_VERSION} + libc++ "
        "(install libc++ module support: "
        "sudo apt install libc++-${CMAKE_CXX_COMPILER_VERSION_MAJOR}-dev libc++abi-${CMAKE_CXX_COMPILER_VERSION_MAJOR}-dev)")

    # libstdc++ and libc++ are ABI-incompatible on Linux.  Mixing object files
    # from both runtimes in the same binary causes undefined behaviour at link
    # time.  Switch the ENTIRE project to libc++ so every translation unit,
    # including GoogleTest and benchmark, uses the same runtime.
    add_compile_options(-stdlib=libc++)
    add_link_options(-stdlib=libc++)

    # Belt-and-suspenders guard: see "Clang + clang-tidy note" in the file header.
    # If __cmake_cxx23 exists when the top-level CMakeLists.txt finishes, clear its
    # CXX_CLANG_TIDY property so clang-tidy does not run on the fallback std.cc.
    function(_ape_template_disable_tidy_on_cmake_cxx23)
        if(TARGET __cmake_cxx23)
            set_target_properties(__cmake_cxx23 PROPERTIES CXX_CLANG_TIDY "")
        endif()
    endfunction()
    cmake_language(DEFER DIRECTORY "${CMAKE_SOURCE_DIR}"
        CALL _ape_template_disable_tidy_on_cmake_cxx23)

    function(configure_import_std target)
        set_property(TARGET ${target} PROPERTY CXX_MODULE_STD 1)
    endfunction()

# ─── GCC ──────────────────────────────────────────────────────────────────────
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "15.2")
        message(STATUS
            "import std: GCC ${CMAKE_CXX_COMPILER_VERSION} < 15.2 — not supported")
        function(configure_import_std target)
        endfunction()
        return()
    endif()

    if(APE_TEMPLATE_ENABLE_CLANG_TIDY)
        # CppModules.cmake disabled dyndep to keep clang-tidy functional.
        # import std; needs dyndep, so the two options cannot both be on with GCC.
        message(STATUS
            "import std: GCC — disabled because APE_TEMPLATE_ENABLE_CLANG_TIDY=ON "
            "conflicts with module dyndep scanning. "
            "Use a preset with APE_TEMPLATE_ENABLE_CLANG_TIDY=OFF "
            "(e.g. linux-gcc-release-import-std).")
        function(configure_import_std target)
        endfunction()
        return()
    endif()

    # clang-tidy is off → CppModules.cmake already enabled dyndep for GCC.
    message(STATUS
        "import std: enabled — GCC ${CMAKE_CXX_COMPILER_VERSION} (experimental)")
    function(configure_import_std target)
        set_property(TARGET ${target} PROPERTY CXX_MODULE_STD 1)
    endfunction()

# ─── Apple Clang ──────────────────────────────────────────────────────────────
elseif(APPLE)
    message(STATUS
        "import std: Apple Clang — not yet supported (requires future Xcode version)")
    function(configure_import_std target)
    endfunction()

# ─── Everything else (NDK, Emscripten, …) ────────────────────────────────────
else()
    message(STATUS
        "import std: ${CMAKE_CXX_COMPILER_ID} on ${CMAKE_SYSTEM_NAME} — not supported")
    function(configure_import_std target)
    endfunction()
endif()
