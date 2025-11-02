#pragma once

#include <string>
#include <cstdint>

namespace ape_template::core {

struct Version {
    std::uint32_t major;
    std::uint32_t minor;
    std::uint32_t patch;

    [[nodiscard]] std::string to_string() const;
    [[nodiscard]] std::uint32_t to_number() const noexcept;
};

[[nodiscard]] Version get_version() noexcept;
[[nodiscard]] const char* get_version_string() noexcept;
[[nodiscard]] const char* get_build_info() noexcept;

} // namespace ape_template::core

