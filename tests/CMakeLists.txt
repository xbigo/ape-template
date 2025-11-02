# Tests directory

# Find or fetch Google Test
include(FetchContent)

FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG v1.14.0
    GIT_SHALLOW TRUE
)

# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(googletest)

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

# Code coverage
if(APE_TEMPLATE_ENABLE_COVERAGE)
    if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
        target_compile_options(ape_template_core PUBLIC --coverage)
        target_link_options(ape_template_core PUBLIC --coverage)
        target_compile_options(ape_template_utils PUBLIC --coverage)
        target_link_options(ape_template_utils PUBLIC --coverage)

        # Add coverage target
        find_program(LCOV_PATH lcov)
        find_program(GENHTML_PATH genhtml)

        if(LCOV_PATH AND GENHTML_PATH)
            add_custom_target(coverage
                COMMAND ${LCOV_PATH} --directory . --zerocounters
                COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure
                COMMAND ${LCOV_PATH} --directory . --capture --output-file coverage.info
                COMMAND ${LCOV_PATH} --remove coverage.info '/usr/*' '*/test/*' '*/tests/*' --output-file coverage.info.cleaned
                COMMAND ${GENHTML_PATH} -o coverage coverage.info.cleaned
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                COMMENT "Generating code coverage report"
            )
        endif()
    endif()
endif()

