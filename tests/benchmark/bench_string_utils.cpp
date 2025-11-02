#include <benchmark/benchmark.h>
#include "ape_template/utils/string_utils.hpp"

namespace ape_template::utils::bench {

static void BM_Trim(benchmark::State& state) {
    const std::string input = "   hello world   ";
    for (auto _ : state) {
        auto result = trim(input);
        benchmark::DoNotOptimize(result);
    }
}
BENCHMARK(BM_Trim);

static void BM_ToUpper(benchmark::State& state) {
    const std::string input = "hello world this is a test string";
    for (auto _ : state) {
        auto result = to_upper(input);
        benchmark::DoNotOptimize(result);
    }
}
BENCHMARK(BM_ToUpper);

static void BM_ToLower(benchmark::State& state) {
    const std::string input = "HELLO WORLD THIS IS A TEST STRING";
    for (auto _ : state) {
        auto result = to_lower(input);
        benchmark::DoNotOptimize(result);
    }
}
BENCHMARK(BM_ToLower);

static void BM_Split(benchmark::State& state) {
    const std::string input = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p";
    for (auto _ : state) {
        auto result = split(input, ',');
        benchmark::DoNotOptimize(result);
    }
}
BENCHMARK(BM_Split);

static void BM_Join(benchmark::State& state) {
    const std::vector<std::string> parts{"a", "b", "c", "d", "e", "f", "g", "h"};
    for (auto _ : state) {
        auto result = join(parts, ",");
        benchmark::DoNotOptimize(result);
    }
}
BENCHMARK(BM_Join);

static void BM_StartsWith(benchmark::State& state) {
    const std::string input = "hello world";
    const std::string prefix = "hello";
    for (auto _ : state) {
        auto result = starts_with(input, prefix);
        benchmark::DoNotOptimize(result);
    }
}
BENCHMARK(BM_StartsWith);

} // namespace ape_template::utils::bench

