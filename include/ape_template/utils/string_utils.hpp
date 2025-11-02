#pragma once

#include <string>
#include <string_view>
#include <vector>

namespace ape_template::utils {

// String trimming
[[nodiscard]] std::string trim_left(std::string_view str);
[[nodiscard]] std::string trim_right(std::string_view str);
[[nodiscard]] std::string trim(std::string_view str);

// String splitting
[[nodiscard]] std::vector<std::string> split(std::string_view str, char delimiter);
[[nodiscard]] std::vector<std::string> split(std::string_view str, std::string_view delimiter);

// String joining
[[nodiscard]] std::string join(const std::vector<std::string>& parts, std::string_view separator);

// Case conversion
[[nodiscard]] std::string to_upper(std::string_view str);
[[nodiscard]] std::string to_lower(std::string_view str);

// String checking
[[nodiscard]] bool starts_with(std::string_view str, std::string_view prefix) noexcept;
[[nodiscard]] bool ends_with(std::string_view str, std::string_view suffix) noexcept;
[[nodiscard]] bool contains(std::string_view str, std::string_view substr) noexcept;

} // namespace ape_template::utils

