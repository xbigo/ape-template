# Fuzz tests
# These tests require special compiler support

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    add_executable(fuzz_string_utils
        fuzz_string_utils.cpp
    )

    target_link_libraries(fuzz_string_utils
        PRIVATE
            ape_template::utils
    )

    target_compile_options(fuzz_string_utils
        PRIVATE
            -g -O1 -fsanitize=fuzzer,address
    )

    target_link_options(fuzz_string_utils
        PRIVATE
            -fsanitize=fuzzer,address
    )

    # Note: Fuzz tests are typically run manually or in CI
    # They don't integrate with CTest in the traditional way
else()
    message(STATUS "Fuzz tests require Clang compiler with libFuzzer support")
endif()

