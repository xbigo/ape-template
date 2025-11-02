#include <gtest/gtest.h>
#include "ape_template/utils/string_utils.hpp"

namespace ape_template::utils::test {

TEST(StringUtilsTest, TrimLeft) {
    EXPECT_EQ(trim_left("  hello"), "hello");
    EXPECT_EQ(trim_left("hello"), "hello");
    EXPECT_EQ(trim_left("  "), "");
}

TEST(StringUtilsTest, TrimRight) {
    EXPECT_EQ(trim_right("hello  "), "hello");
    EXPECT_EQ(trim_right("hello"), "hello");
    EXPECT_EQ(trim_right("  "), "");
}

TEST(StringUtilsTest, Trim) {
    EXPECT_EQ(trim("  hello  "), "hello");
    EXPECT_EQ(trim("hello"), "hello");
    EXPECT_EQ(trim("  "), "");
    EXPECT_EQ(trim("\t\nhello\r\n"), "hello");
}

TEST(StringUtilsTest, SplitByChar) {
    auto result = split("a,b,c", ',');
    ASSERT_EQ(result.size(), 3u);
    EXPECT_EQ(result[0], "a");
    EXPECT_EQ(result[1], "b");
    EXPECT_EQ(result[2], "c");
}

TEST(StringUtilsTest, SplitByString) {
    auto result = split("a::b::c", "::");
    ASSERT_EQ(result.size(), 3u);
    EXPECT_EQ(result[0], "a");
    EXPECT_EQ(result[1], "b");
    EXPECT_EQ(result[2], "c");
}

TEST(StringUtilsTest, Join) {
    std::vector<std::string> parts{"a", "b", "c"};
    EXPECT_EQ(join(parts, ","), "a,b,c");
    EXPECT_EQ(join(parts, "::"), "a::b::c");
    EXPECT_EQ(join({}, ","), "");
}

TEST(StringUtilsTest, ToUpper) {
    EXPECT_EQ(to_upper("hello"), "HELLO");
    EXPECT_EQ(to_upper("Hello World"), "HELLO WORLD");
    EXPECT_EQ(to_upper(""), "");
}

TEST(StringUtilsTest, ToLower) {
    EXPECT_EQ(to_lower("HELLO"), "hello");
    EXPECT_EQ(to_lower("Hello World"), "hello world");
    EXPECT_EQ(to_lower(""), "");
}

TEST(StringUtilsTest, StartsWith) {
    EXPECT_TRUE(starts_with("hello world", "hello"));
    EXPECT_FALSE(starts_with("hello world", "world"));
    EXPECT_TRUE(starts_with("hello", "hello"));
    EXPECT_FALSE(starts_with("hi", "hello"));
}

TEST(StringUtilsTest, EndsWith) {
    EXPECT_TRUE(ends_with("hello world", "world"));
    EXPECT_FALSE(ends_with("hello world", "hello"));
    EXPECT_TRUE(ends_with("world", "world"));
    EXPECT_FALSE(ends_with("hi", "world"));
}

TEST(StringUtilsTest, Contains) {
    EXPECT_TRUE(contains("hello world", "lo wo"));
    EXPECT_FALSE(contains("hello world", "xyz"));
    EXPECT_TRUE(contains("hello", "hello"));
}

} // namespace ape_template::utils::test

