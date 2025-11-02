# Contributing to ape2

Thank you for your interest in contributing to ape2! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Documentation](#documentation)
- [Submitting Changes](#submitting-changes)

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code. Please be respectful and constructive in all interactions.

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/xbigo/ape2.git
   cd ape2
   ```
3. Add the upstream repository:
   ```bash
   git remote add upstream https://github.com/originalowner/ape2.git
   ```
4. Create a development branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Workflow

### Building the Project

See [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md) for detailed build instructions.

Quick start:
```bash
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug
cmake --build build --parallel
```

### Running Tests

Always run tests before submitting changes:

```bash
cd build
ctest --output-on-failure
```

### Code Formatting

We use clang-format for code formatting. Format your code before committing:

```bash
# Format a single file
clang-format -i path/to/file.cpp

# Format all files (Linux/macOS)
find src include tests -type f \( -name "*.cpp" -o -name "*.hpp" -o -name "*.h" \) -exec clang-format -i {} +

# Format all files (Windows)
Get-ChildItem -Recurse -Include *.cpp,*.hpp,*.h | ForEach-Object { clang-format -i $_.FullName }
```

### Static Analysis

Run clang-tidy to check for code issues:

```bash
cmake -B build -DAPE2_ENABLE_CLANG_TIDY=ON
cmake --build build
```

## Coding Standards

### C++ Standards

- Use C++23 features where appropriate
- Follow the [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines)
- Use modern C++ idioms and best practices

### Style Guide

- Follow the .clang-format configuration in the repository
- Use snake_case for functions and variables
- Use CamelCase for classes and types
- Use UPPER_CASE for constants and macros
- Private member variables should end with underscore `_`

Example:

```cpp
namespace ape2::utils {

class StringParser {
public:
    StringParser() = default;

    std::string parse_input(std::string_view input) const;

private:
    std::string buffer_;
    size_t position_ = 0;
};

constexpr int MAX_BUFFER_SIZE = 1024;

} // namespace ape2::utils
```

### File Organization

- Header files: `include/ape2/module/file.hpp`
- Source files: `src/module/file.cpp`
- Test files: `tests/unit/test_file.cpp`

### Header Guards

Use `#pragma once` for header guards:

```cpp
#pragma once

namespace ape2 {
// declarations
}
```

### Documentation

Document public APIs using Doxygen style comments:

```cpp
/**
 * @brief Parse a string into tokens
 *
 * @param input The input string to parse
 * @param delimiter The delimiter character
 * @return Vector of tokens
 *
 * @throws std::invalid_argument if input is empty
 */
[[nodiscard]] std::vector<std::string> parse(
    std::string_view input,
    char delimiter
);
```

### Error Handling

- Use exceptions for error conditions that cannot be handled locally
- Use return codes or std::expected/std::optional for expected failures
- Provide strong exception safety guarantees where possible

### Modern C++ Features

Embrace modern C++ features:

- Use `auto` where it improves readability
- Use `constexpr` for compile-time computation
- Use `[[nodiscard]]` for functions that return important values
- Use structured bindings
- Use concepts for template constraints (C++20)
- Use ranges (C++20)
- Use modules where supported (C++20)

## Testing

### Writing Tests

- Write tests for all new features
- Place unit tests in `tests/unit/`
- Place regression tests in `tests/regression/`
- Use Google Test framework

Example test:

```cpp
#include <gtest/gtest.h>
#include "ape2/utils/string_utils.hpp"

namespace ape2::utils::test {

TEST(StringUtilsTest, TrimRemovesWhitespace) {
    EXPECT_EQ(trim("  hello  "), "hello");
    EXPECT_EQ(trim("hello"), "hello");
    EXPECT_EQ(trim(""), "");
}

TEST(StringUtilsTest, SplitDividesString) {
    auto result = split("a,b,c", ',');
    ASSERT_EQ(result.size(), 3u);
    EXPECT_EQ(result[0], "a");
    EXPECT_EQ(result[1], "b");
    EXPECT_EQ(result[2], "c");
}

} // namespace ape2::utils::test
```

### Test Coverage

- Aim for high test coverage (>80%)
- Test edge cases and error conditions
- Run coverage analysis:

```bash
cmake -B build -DAPE2_ENABLE_COVERAGE=ON
cmake --build build
cmake --build build --target coverage
```

## Documentation

### Code Documentation

- Document all public APIs
- Use Doxygen-style comments
- Explain complex algorithms
- Add examples for non-obvious usage

### README and Guides

- Update README.md for user-facing changes
- Update BUILD_INSTRUCTIONS.md for build-related changes
- Add examples in the examples/ directory

## Submitting Changes

### Commit Guidelines

Write clear, descriptive commit messages:

```
Short summary (50 chars or less)

More detailed explanation if needed. Wrap at 72 characters.

- Bullet points are fine
- Use present tense ("Add feature" not "Added feature")
- Reference issues: Fixes #123
```

### Pull Request Process

1. Update your branch with the latest upstream changes:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. Ensure all tests pass:
   ```bash
   cmake --build build
   cd build && ctest
   ```

3. Push your changes:
   ```bash
   git push origin feature/your-feature-name
   ```

4. Create a pull request on GitHub with:
   - Clear description of changes
   - Reference to related issues
   - Screenshots for UI changes
   - Test results

5. Address review feedback:
   - Make requested changes
   - Push updates to your branch
   - Reply to comments

### PR Checklist

- [ ] Code follows project style guidelines
- [ ] Code is formatted with clang-format
- [ ] All tests pass
- [ ] New tests added for new features
- [ ] Documentation updated
- [ ] Commit messages are clear
- [ ] No merge conflicts with main branch

## Additional Resources

- [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines)
- [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html)
- [CMake Documentation](https://cmake.org/documentation/)
- [Google Test Documentation](https://google.github.io/googletest/)

## Questions?

If you have questions:
- Open an issue for discussion
- Check existing issues and pull requests
- Review project documentation

Thank you for contributing to ape2!

