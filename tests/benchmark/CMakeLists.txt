# Benchmark tests

# Fetch Google Benchmark
include(FetchContent)

FetchContent_Declare(
    benchmark
    GIT_REPOSITORY https://github.com/google/benchmark.git
    GIT_TAG v1.8.3
    GIT_SHALLOW TRUE
)

set(BENCHMARK_ENABLE_TESTING OFF CACHE BOOL "" FORCE)
set(BENCHMARK_ENABLE_GTEST_TESTS OFF CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(benchmark)

# Benchmark executable
add_executable(bench_string_utils
    bench_string_utils.cpp
)

target_link_libraries(bench_string_utils
    PRIVATE
        ape_template::utils
        benchmark::benchmark
        benchmark::benchmark_main
)

# Benchmarks are not run as part of normal testing
# They can be run manually with: ./bench_string_utils

