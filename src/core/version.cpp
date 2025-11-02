#include "ape_template/core/version.hpp"
#include <sstream>

namespace ape_template::core {

constexpr Version VERSION{0, 1, 0};

std::string Version::to_string() const {
    std::ostringstream oss;
    oss << major << '.' << minor << '.' << patch;
    return oss.str();
}

std::uint32_t Version::to_number() const noexcept {
    return (major << 16) | (minor << 8) | patch;
}

Version get_version() noexcept {
    return VERSION;
}

const char* get_version_string() noexcept {
    return "0.1.0";
}

const char* get_build_info() noexcept {
#ifdef NDEBUG
    return "Release Build";
#else
    return "Debug Build";
#endif
}

} // namespace ape_template::core

