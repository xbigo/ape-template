# Regression tests
# These tests are run separately from unit tests

add_executable(regression_tests
    regression_suite.cpp
)

target_link_libraries(regression_tests
    PRIVATE
        ape_template::core
        ape_template::utils
        GTest::gtest
        GTest::gtest_main
)

gtest_discover_tests(regression_tests
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    PROPERTIES
        LABELS "regression"
)

