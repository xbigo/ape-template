#include "ape_template/utils/string_utils.hpp"
#include <algorithm>
#include <cctype>
#include <sstream>

namespace ape_template::utils {

std::string trim_left(std::string_view str) {
    auto it = std::find_if(str.begin(), str.end(), [](unsigned char ch) {
        return !std::isspace(ch);
    });
    return std::string(it, str.end());
}

std::string trim_right(std::string_view str) {
    auto it = std::find_if(str.rbegin(), str.rend(), [](unsigned char ch) {
        return !std::isspace(ch);
    });
    return std::string(str.begin(), it.base());
}

std::string trim(std::string_view str) {
    return trim_left(trim_right(str));
}

std::vector<std::string> split(std::string_view str, char delimiter) {
    std::vector<std::string> result;
    std::string current;

    for (char ch : str) {
        if (ch == delimiter) {
            if (!current.empty()) {
                result.push_back(std::move(current));
                current.clear();
            }
        } else {
            current += ch;
        }
    }

    if (!current.empty()) {
        result.push_back(std::move(current));
    }

    return result;
}

std::vector<std::string> split(std::string_view str, std::string_view delimiter) {
    std::vector<std::string> result;
    std::size_t start = 0;
    std::size_t end = str.find(delimiter);

    while (end != std::string_view::npos) {
        result.emplace_back(str.substr(start, end - start));
        start = end + delimiter.length();
        end = str.find(delimiter, start);
    }

    result.emplace_back(str.substr(start));
    return result;
}

std::string join(const std::vector<std::string>& parts, std::string_view separator) {
    if (parts.empty()) {
        return {};
    }

    std::ostringstream oss;
    oss << parts[0];

    for (std::size_t i = 1; i < parts.size(); ++i) {
        oss << separator << parts[i];
    }

    return oss.str();
}

std::string to_upper(std::string_view str) {
    std::string result;
    result.reserve(str.size());

    std::transform(str.begin(), str.end(), std::back_inserter(result),
        [](unsigned char ch) { return static_cast<char>(std::toupper(ch)); });

    return result;
}

std::string to_lower(std::string_view str) {
    std::string result;
    result.reserve(str.size());

    std::transform(str.begin(), str.end(), std::back_inserter(result),
        [](unsigned char ch) { return static_cast<char>(std::tolower(ch)); });

    return result;
}

bool starts_with(std::string_view str, std::string_view prefix) noexcept {
    return str.size() >= prefix.size() &&
           str.substr(0, prefix.size()) == prefix;
}

bool ends_with(std::string_view str, std::string_view suffix) noexcept {
    return str.size() >= suffix.size() &&
           str.substr(str.size() - suffix.size()) == suffix;
}

bool contains(std::string_view str, std::string_view substr) noexcept {
    return str.find(substr) != std::string_view::npos;
}

} // namespace ape_template::utils

