#include <gtest/gtest.h>
#include "ape_template/core/version.hpp"

namespace ape_template::core::test {

TEST(VersionTest, GetVersion) {
    auto version = get_version();
    EXPECT_EQ(version.major, 0u);
    EXPECT_EQ(version.minor, 1u);
    EXPECT_EQ(version.patch, 0u);
}

TEST(VersionTest, VersionToString) {
    Version v{1, 2, 3};
    EXPECT_EQ(v.to_string(), "1.2.3");
}

TEST(VersionTest, VersionToNumber) {
    Version v{1, 2, 3};
    std::uint32_t expected = (1u << 16) | (2u << 8) | 3u;
    EXPECT_EQ(v.to_number(), expected);
}

TEST(VersionTest, GetVersionString) {
    const char* version_str = get_version_string();
    EXPECT_STREQ(version_str, "0.1.0");
}

TEST(VersionTest, GetBuildInfo) {
    const char* build_info = get_build_info();
    EXPECT_NE(build_info, nullptr);
}

} // namespace ape_template::core::test

