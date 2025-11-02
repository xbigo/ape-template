# Unit tests

add_executable(test_core
    test_version.cpp
)

configure_test(test_core)

add_executable(test_utils
    test_string_utils.cpp
)

configure_test(test_utils)

