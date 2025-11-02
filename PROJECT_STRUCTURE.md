# Project Structure

This document provides an overview of the ape-template project structure.

## Directory Layout

```
ape-template/
├── .github/                    # GitHub configuration
│   └── workflows/             # GitHub Actions workflows
│       ├── ci.yml            # Continuous integration
│       ├── docker.yml        # Docker builds
│       ├── documentation.yml # Documentation generation
│       └── release.yml       # Release workflow
│
├── .vscode/                   # VSCode configuration
│   ├── c_cpp_properties.json # C/C++ IntelliSense config
│   ├── extensions.json       # Recommended extensions
│   ├── launch.json          # Debug configurations
│   ├── settings.json        # Workspace settings
│   └── tasks.json           # Build tasks
│
├── cmake/                     # CMake modules and helpers
│   ├── modules/              # Custom CMake modules
│   │   ├── CompilerWarnings.cmake    # Warning configurations
│   │   ├── CppModules.cmake          # C++ modules support
│   │   ├── DebugSymbols.cmake        # Debug symbols handling
│   │   ├── DistributedBuild.cmake    # Distributed compilation
│   │   ├── Sanitizers.cmake          # Sanitizer configurations
│   │   └── ThirdParty.cmake          # Third-party dependencies
│   └── ape-templateConfig.cmake.in   # Package config template
│
├── docker/                    # Docker configurations
│   ├── android/              # Android NDK environment
│   │   └── Dockerfile
│   ├── linux/                # Linux build environment
│   │   └── Dockerfile
│   ├── webassembly/          # WebAssembly (Emscripten)
│   │   └── Dockerfile
│   └── secrets/              # Secrets mount point (not committed)
│       └── .gitkeep
│
├── docs/                      # Documentation
│   ├── CMakeLists.txt        # Documentation build config
│   └── Doxyfile.in           # Doxygen configuration
│
├── include/                   # Public headers
│   └── ape-template/
│       ├── core/             # Core library headers
│       │   └── version.hpp
│       └── utils/            # Utilities headers
│           └── string_utils.hpp
│
├── patches/                   # Third-party library patches
│   └── README.md             # Patch management guide
│
├── scripts/                   # Build and utility scripts
│   ├── docker-build.ps1      # Docker build (PowerShell)
│   ├── docker-build.sh       # Docker build (Bash)
│   └── docker-shell.sh       # Interactive Docker shell
│
├── src/                       # Source code
│   ├── core/                 # Core library implementation
│   │   ├── CMakeLists.txt
│   │   └── version.cpp
│   ├── utils/                # Utilities implementation
│   │   ├── CMakeLists.txt
│   │   └── string_utils.cpp
│   └── CMakeLists.txt        # Source root CMake
│
├── tests/                     # Tests
│   ├── benchmark/            # Performance benchmarks
│   │   ├── CMakeLists.txt
│   │   └── bench_string_utils.cpp
│   ├── fuzz/                 # Fuzz tests
│   │   ├── CMakeLists.txt
│   │   └── fuzz_string_utils.cpp
│   ├── regression/           # Regression tests
│   │   ├── CMakeLists.txt
│   │   └── regression_suite.cpp
│   ├── unit/                 # Unit tests
│   │   ├── CMakeLists.txt
│   │   ├── test_string_utils.cpp
│   │   └── test_version.cpp
│   └── CMakeLists.txt        # Test root CMake
│
├── .clang-format              # Code formatting configuration
├── .clang-tidy                # Static analysis configuration
├── .editorconfig              # Editor configuration
├── .gitignore                 # Git ignore rules
├── BUILD_INSTRUCTIONS.md      # Detailed build instructions
├── CMakeLists.txt             # Root CMake configuration
├── conanfile.py               # Conan package definition
├── conanfile.txt              # Conan dependencies
├── CONTRIBUTING.md            # Contribution guidelines
├── LICENSE                    # Project license
├── PROJECT_STRUCTURE.md       # This file
├── README.md                  # Project overview
└── vcpkg.json                 # vcpkg manifest

```

## Build Directories (Generated)

These directories are created during the build process and are not committed to git:

```
build/                         # Default build directory
build-debug/                   # Debug build
build-release/                 # Release build
build-fastdebug/              # FastDebug build
build-slowrelease/            # SlowRelease build
build-docker/                 # Docker build output
build-android/                # Android build output
build-wasm/                   # WebAssembly build output
```

## Key Files

### Configuration Files

- **CMakeLists.txt**: Root CMake configuration with all build options
- **.clang-format**: Code formatting rules for consistent style
- **.clang-tidy**: Static analysis checks and naming conventions
- **.editorconfig**: Editor settings for consistent coding style
- **conanfile.py/conanfile.txt**: Package management with Conan
- **vcpkg.json**: Package management with vcpkg

### Build Scripts

- **scripts/docker-build.sh**: Build in Docker (Linux/macOS)
- **scripts/docker-build.ps1**: Build in Docker (Windows)
- **scripts/docker-shell.sh**: Interactive Docker environment

### Documentation

- **README.md**: Project overview and quick start
- **BUILD_INSTRUCTIONS.md**: Comprehensive build guide
- **CONTRIBUTING.md**: Contribution guidelines
- **PROJECT_STRUCTURE.md**: This file
- **patches/README.md**: Patch management guide

### CI/CD

- **.github/workflows/ci.yml**: Continuous integration
- **.github/workflows/docker.yml**: Docker-based builds
- **.github/workflows/documentation.yml**: Documentation generation
- **.github/workflows/release.yml**: Release automation

## Module Organization

### Core Library (`ape-template::core`)

Located in `src/core/` and `include/ape-template/core/`

Contains fundamental functionality:
- Version information
- Core types and utilities

### Utils Library (`ape-template::utils`)

Located in `src/utils/` and `include/ape-template/utils/`

Contains utility functions:
- String manipulation
- Common algorithms
- Helper functions

## Test Organization

### Unit Tests (`tests/unit/`)

- Fast, isolated tests
- Test individual functions and classes
- Run as part of post-build step
- High code coverage target

### Regression Tests (`tests/regression/`)

- Tests for previously fixed bugs
- Ensure bugs don't reappear
- May be slower than unit tests
- Run separately from unit tests

### Fuzz Tests (`tests/fuzz/`)

- Requires Clang with libFuzzer
- Test robustness with random inputs
- Typically run manually or in CI
- Help find edge cases and crashes

### Benchmark Tests (`tests/benchmark/`)

- Performance measurement
- Compare different implementations
- Track performance regressions
- Use Google Benchmark framework

## CMake Module Organization

### CompilerWarnings.cmake

Configures comprehensive warning sets for:
- MSVC
- GCC
- Clang

### DebugSymbols.cmake

Handles platform-specific debug symbol generation:
- Windows: PDB files
- macOS: dSYM bundles
- Linux: Separate .dbg files

### Sanitizers.cmake

Configures various sanitizers:
- AddressSanitizer (ASan)
- MemorySanitizer (MSan)
- ThreadSanitizer (TSan)
- UndefinedBehaviorSanitizer (UBSan)
- LeakSanitizer (LSan)

### CppModules.cmake

Enables C++20/23 modules support:
- Compiler detection
- Module-specific flags
- Experimental CMake features

### ThirdParty.cmake

Manages third-party dependencies:
- Package manager selection (Conan/vcpkg/CMake)
- Patch application
- Dependency configuration

### DistributedBuild.cmake

Configures distributed compilation:
- IncrediBuild (Windows)
- distcc (Linux/macOS)
- ccache (fallback)

## Platform Support

### Native Platforms

- **Windows**: MSVC, Clang
- **Linux**: GCC, Clang
- **macOS**: Clang, Xcode

### Mobile Platforms

- **Android**: NDK with Clang
- **iOS**: Xcode with Clang

### Web Platform

- **WebAssembly**: Emscripten

### Build Tools

- **CMake**: 3.28+
- **Ninja**: Recommended generator
- **Make**: Alternative generator
- **Visual Studio**: IDE support
- **Xcode**: macOS/iOS IDE support

## Development Workflow

1. **Clone** the repository
2. **Configure** with CMake
3. **Build** with your preferred tool
4. **Test** with CTest
5. **Format** with clang-format
6. **Analyze** with clang-tidy
7. **Document** with Doxygen
8. **Submit** pull requests

## Adding New Components

### Adding a New Library

1. Create directories: `src/newlib/` and `include/ape-template/newlib/`
2. Add `src/newlib/CMakeLists.txt`
3. Update `src/CMakeLists.txt` to include new library
4. Create tests in `tests/unit/test_newlib.cpp`
5. Update documentation

### Adding a New Test Suite

1. Create test file in appropriate directory
2. Add test executable in corresponding `CMakeLists.txt`
3. Use `configure_test()` function for unit tests
4. Ensure tests run in CI

### Adding a Third-Party Dependency

1. Add to `conanfile.txt` or `vcpkg.json`
2. Update `cmake/modules/ThirdParty.cmake` if needed
3. Add patches to `patches/` if required
4. Document the dependency

## Best Practices

- Keep public headers in `include/ape-template/`
- Keep implementation in `src/`
- Write tests for all new code
- Format code with clang-format
- Run clang-tidy before committing
- Update documentation
- Follow naming conventions
- Use modern C++ features

## Additional Resources

- [CMake Documentation](https://cmake.org/documentation/)
- [Google Test](https://google.github.io/googletest/)
- [Google Benchmark](https://github.com/google/benchmark)
- [Doxygen](https://www.doxygen.nl/)
- [Conan](https://conan.io/)
- [vcpkg](https://vcpkg.io/)

