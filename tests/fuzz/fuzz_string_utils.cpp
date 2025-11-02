#include "ape_template/utils/string_utils.hpp"
#include <cstdint>
#include <cstddef>
#include <string>

// Fuzz test for string utilities
// This is designed to work with libFuzzer

extern "C" int LLVMFuzzerTestOneInput(const std::uint8_t* data, std::size_t size) {
    if (size == 0) {
        return 0;
    }

    // Convert input to string
    std::string input(reinterpret_cast<const char*>(data), size);

    // Test various string operations
    try {
        // These operations should not crash regardless of input
        [[maybe_unused]] auto trimmed = ape_template::utils::trim(input);
        [[maybe_unused]] auto upper = ape_template::utils::to_upper(input);
        [[maybe_unused]] auto lower = ape_template::utils::to_lower(input);

        // Test splitting with first character as delimiter
        if (!input.empty()) {
            [[maybe_unused]] auto parts = ape_template::utils::split(input, input[0]);
        }

        // Test string predicates
        if (size > 1) {
            std::string_view view(input);
            [[maybe_unused]] auto sw = ape_template::utils::starts_with(view, view.substr(0, 1));
            [[maybe_unused]] auto ew = ape_template::utils::ends_with(view, view.substr(size - 1));
            [[maybe_unused]] auto c = ape_template::utils::contains(view, view.substr(0, 1));
        }
    } catch (...) {
        // Catch any exceptions to prevent fuzzer from stopping
        return 0;
    }

    return 0;
}

