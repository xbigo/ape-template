# Tests directory

# Find or fetch Google Test
include(FetchContent)

FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG v1.14.0
    GIT_SHALLOW TRUE
    SYSTEM
)

# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(googletest)
ape_suppress_3rdparty_warnings(gtest gtest_main gmock gmock_main)

# Enable CTest
include(CTest)
include(GoogleTest)

# Common test settings
function(configure_test test_target)
    target_link_libraries(${test_target}
        PRIVATE
            ape_template::core
            ape_template::utils
            GTest::gtest
            GTest::gtest_main
    )

    target_compile_definitions(${test_target}
        PRIVATE
            APE_TEMPLATE_TEST_DATA_DIR="${CMAKE_CURRENT_SOURCE_DIR}/data"
    )

    # Discover tests
    gtest_discover_tests(${test_target}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        PROPERTIES
            LABELS "unit"
    )

    # Add to post-build test execution
    add_custom_command(TARGET ${test_target} POST_BUILD
        COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure -L unit
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Running unit tests for ${test_target}"
    )

    # Separate debug symbols into build/symbols/ (all platforms)
    if(COMMAND extract_debug_symbols)
        extract_debug_symbols(${test_target})
    endif()

    # Register binary path for llvm-cov (macOS).
    # configure_test() is always called before the coverage target is created,
    # so the global property is fully populated by the time it is read below.
    if(APE_TEMPLATE_ENABLE_COVERAGE AND APPLE)
        set_property(GLOBAL APPEND PROPERTY APE_TEMPLATE_COVERAGE_TARGETS "${test_target}")
    endif()
endfunction()

# Unit tests
if(APE_TEMPLATE_BUILD_UNIT_TESTS)
    add_subdirectory(unit)
endif()

# Regression tests
if(APE_TEMPLATE_BUILD_REGRESSION_TESTS)
    add_subdirectory(regression)
endif()

# Fuzz tests
if(APE_TEMPLATE_BUILD_FUZZ_TESTS)
    add_subdirectory(fuzz)
endif()

# Benchmark tests
if(APE_TEMPLATE_BUILD_BENCHMARKS)
    add_subdirectory(benchmark)
endif()

# ─────────────────────────────────────────────────────────────────────────────
# Code coverage
#
# Tool selection by platform / compiler:
#   Windows MSVC       → OpenCppCoverage   (FetchContent, NuGet, no compile flags)
#   macOS   any Clang  → xcrun llvm-profdata + xcrun llvm-cov  (Xcode CLT)
#                         compile: -fprofile-instr-generate -fcoverage-mapping
#   Linux   GCC        → --coverage (gcov) + lcov + genhtml
#   Linux   Clang      → --coverage (gcov-compat mode) + lcov + genhtml
# ─────────────────────────────────────────────────────────────────────────────
if(APE_TEMPLATE_ENABLE_COVERAGE)
    if(MSVC)
        # ── Windows MSVC ────────────────────────────────────────────────────
        # Requires OpenCppCoverage to be installed by the developer.
        # Download: https://github.com/OpenCppCoverage/OpenCppCoverage/releases
        find_program(OPENCPPCOVERAGE_EXE OpenCppCoverage)
        if(NOT OPENCPPCOVERAGE_EXE)
            message(FATAL_ERROR
                "OpenCppCoverage not found. Install it and ensure it is on PATH.\n"
                "Download: https://github.com/OpenCppCoverage/OpenCppCoverage/releases")
        endif()

        # OpenCppCoverage requires Windows-style backslash paths.
        # file(TO_NATIVE_PATH) converts forward slashes at configure time.
        file(TO_NATIVE_PATH "${CMAKE_SOURCE_DIR}/src"      _occ_src)
        file(TO_NATIVE_PATH "${CMAKE_SOURCE_DIR}/include"  _occ_include)
        file(TO_NATIVE_PATH "${CMAKE_BINARY_DIR}"          _occ_build)
        file(TO_NATIVE_PATH "${CMAKE_BINARY_DIR}/coverage" _occ_output)

        add_custom_target(coverage
            COMMAND "${OPENCPPCOVERAGE_EXE}"
                --sources "${_occ_src}"
                --sources "${_occ_include}"
                --modules "${_occ_build}"
                --cover_children
                --export_type "html:${_occ_output}"
                -- ${CMAKE_CTEST_COMMAND} --output-on-failure
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            COMMENT "Generating coverage report (build/coverage/index.html)"
        )

    elseif(APPLE)
        # ── macOS (Apple Clang / LLVM Clang) ────────────────────────────────
        # Use LLVM source-based coverage: more accurate than gcov on Apple
        # platforms, and llvm-profdata/llvm-cov ship with Xcode Command Line Tools.
        find_program(XCRUN xcrun)
        if(NOT XCRUN)
            message(FATAL_ERROR
                "xcrun not found. Install Xcode Command Line Tools:\n"
                "  xcode-select --install")
        endif()

        target_compile_options(ape_template_core  PUBLIC -fprofile-instr-generate -fcoverage-mapping)
        target_link_options(ape_template_core     PUBLIC -fprofile-instr-generate)
        target_compile_options(ape_template_utils PUBLIC -fprofile-instr-generate -fcoverage-mapping)
        target_link_options(ape_template_utils    PUBLIC -fprofile-instr-generate)

        # Collect test binaries registered by configure_test() above.
        # add_subdirectory(unit/regression) runs before this block, so the
        # property is already fully populated by the time we read it here.
        get_property(_cov_targets GLOBAL PROPERTY APE_TEMPLATE_COVERAGE_TARGETS)
        if(NOT _cov_targets)
            message(FATAL_ERROR
                "No test targets registered for coverage.\n"
                "Enable APE_TEMPLATE_BUILD_UNIT_TESTS or APE_TEMPLATE_BUILD_REGRESSION_TESTS.")
        endif()

        # Build the llvm-cov -object argument list.
        # Generator expressions ($<TARGET_FILE:...>) are resolved at build time,
        # so the paths are correct even before the binaries are compiled.
        set(_llvm_cov_objects)
        set(_first TRUE)
        foreach(_target IN LISTS _cov_targets)
            if(_first)
                list(APPEND _llvm_cov_objects "$<TARGET_FILE:${_target}>")
                set(_first FALSE)
            else()
                list(APPEND _llvm_cov_objects -object "$<TARGET_FILE:${_target}>")
            endif()
        endforeach()

        # Write a helper CMake script that globs *.profraw and merges them.
        # Doing the glob inside a -P script avoids shell-specific expansion and
        # works identically whether invoked from Ninja, Xcode, or the CLI.
        set(_profraw_dir   "${CMAKE_BINARY_DIR}/profraw")
        set(_profdata_file "${CMAKE_BINARY_DIR}/coverage.profdata")
        file(WRITE "${CMAKE_BINARY_DIR}/merge_profraw.cmake"
            "file(GLOB _files LIST_DIRECTORIES false \"${_profraw_dir}/*.profraw\")\n"
            "if(NOT _files)\n"
            "  message(FATAL_ERROR \"No .profraw files found in ${_profraw_dir}.\\n\"\n"
            "    \"Ensure tests were built with -fprofile-instr-generate and the coverage target ran.\")\n"
            "endif()\n"
            "execute_process(\n"
            "  COMMAND \"${XCRUN}\" llvm-profdata merge -sparse \${_files}\n"
            "          -o \"${_profdata_file}\"\n"
            "  RESULT_VARIABLE _r)\n"
            "if(NOT _r EQUAL 0)\n"
            "  message(FATAL_ERROR \"llvm-profdata merge failed\")\n"
            "endif()\n"
        )

        add_custom_target(coverage
            # 1. Clean stale profiling data from previous runs
            COMMAND ${CMAKE_COMMAND} -E rm -rf        "${_profraw_dir}"
            COMMAND ${CMAKE_COMMAND} -E make_directory "${_profraw_dir}"
            # 2. Run all CTest tests; each process writes its own <pid>.profraw
            COMMAND ${CMAKE_COMMAND} -E env
                "LLVM_PROFILE_FILE=${_profraw_dir}/%p.profraw"
                ${CMAKE_CTEST_COMMAND} --output-on-failure
            # 3. Glob-merge all profraw files into a single profdata
            COMMAND ${CMAKE_COMMAND} -P "${CMAKE_BINARY_DIR}/merge_profraw.cmake"
            # 4. Generate HTML report from all instrumented test binaries
            COMMAND ${XCRUN} llvm-cov show
                ${_llvm_cov_objects}
                -instr-profile="${_profdata_file}"
                -format=html
                -output-dir="${CMAKE_BINARY_DIR}/coverage"
                -show-line-counts-or-regions
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            COMMENT "Generating coverage report (build/coverage/index.html)"
        )

    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        # ── Linux GCC ────────────────────────────────────────────────────────
        # --coverage emits gcov-compatible .gcno/.gcda files; lcov collects and
        # genhtml renders them into an HTML report.
        target_compile_options(ape_template_core  PUBLIC --coverage)
        target_link_options(ape_template_core     PUBLIC --coverage)
        target_compile_options(ape_template_utils PUBLIC --coverage)
        target_link_options(ape_template_utils    PUBLIC --coverage)

        find_program(LCOV_PATH    lcov)
        find_program(GENHTML_PATH genhtml)
        if(NOT LCOV_PATH OR NOT GENHTML_PATH)
            message(FATAL_ERROR
                "APE_TEMPLATE_ENABLE_COVERAGE=ON with GCC requires lcov and genhtml.\n"
                "Install with: sudo apt-get install lcov")
        endif()

        add_custom_target(coverage
            COMMAND ${LCOV_PATH} --directory . --zerocounters
            COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure
            COMMAND ${LCOV_PATH} --directory . --capture --output-file coverage.info
            COMMAND ${LCOV_PATH} --remove coverage.info '/usr/*' '*/test/*' '*/tests/*'
                    --output-file coverage.info.cleaned
            COMMAND ${GENHTML_PATH} -o coverage coverage.info.cleaned
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            COMMENT "Generating coverage report (build/coverage/index.html)"
        )

    elseif(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
        # ── Linux Clang ──────────────────────────────────────────────────────
        # Clang supports --coverage in gcov-compatible mode, so the same
        # lcov + genhtml pipeline used for GCC works here without modification.
        target_compile_options(ape_template_core  PUBLIC --coverage)
        target_link_options(ape_template_core     PUBLIC --coverage)
        target_compile_options(ape_template_utils PUBLIC --coverage)
        target_link_options(ape_template_utils    PUBLIC --coverage)

        find_program(LCOV_PATH    lcov)
        find_program(GENHTML_PATH genhtml)
        if(NOT LCOV_PATH OR NOT GENHTML_PATH)
            message(FATAL_ERROR
                "APE_TEMPLATE_ENABLE_COVERAGE=ON with Clang requires lcov and genhtml.\n"
                "Install with: sudo apt-get install lcov")
        endif()

        add_custom_target(coverage
            COMMAND ${LCOV_PATH} --directory . --zerocounters
            COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure
            COMMAND ${LCOV_PATH} --directory . --capture --output-file coverage.info
            COMMAND ${LCOV_PATH} --remove coverage.info '/usr/*' '*/test/*' '*/tests/*'
                    --output-file coverage.info.cleaned
            COMMAND ${GENHTML_PATH} -o coverage coverage.info.cleaned
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            COMMENT "Generating coverage report (build/coverage/index.html)"
        )

    else()
        message(FATAL_ERROR
            "APE_TEMPLATE_ENABLE_COVERAGE=ON is not supported for compiler: "
            "${CMAKE_CXX_COMPILER_ID} on ${CMAKE_SYSTEM_NAME}")
    endif()
endif()

