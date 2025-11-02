# ape-template - Advanced C++ Project Template

[![CI](https://github.com/xbigo/ape-template/workflows/CI/badge.svg)](https://github.com/xbigo/ape-template/actions)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![C++23](https://img.shields.io/badge/C%2B%2B-23-blue.svg)](https://en.cppreference.com/w/cpp/23)

> **Disclaimer:** The AI-generated content in this template may contain marketing-like language that does not reflect the author's intention. This project was created as an exercise. For the original project requirements (in Chinese), see [README.original.zh.md](README.original.zh.md). For the English translation, see [README.original.md](README.original.md).

This is a **modern C++ project template** created from scratch, containing a complete build system, testing framework, CI/CD configuration, and development toolchain. It can serve as a starting point for new projects, saving a significant amount of configuration time.

## ✨ Why Choose This Template?

- 🚀 **Ready to Use** - All tools and configurations are prepared
- 🎯 **Production Quality** - Fully tested and verified configurations
- 📦 **Reusable** - Easily adaptable to your projects
- 🔧 **Modern C++23** - Uses the latest C++ features and module support
- 🌍 **Truly Cross-Platform** - Windows, Linux, macOS, iOS, Android, WebAssembly
- 🐳 **Containerized Builds** - Docker support ensures environment consistency
- 🧪 **Complete Testing** - Unit tests, regression tests, fuzz tests, performance benchmarks
- 📊 **Code Quality** - clang-tidy, clang-format, code coverage
- 📚 **Automated Documentation** - Doxygen configuration
- 🔄 **CI/CD Ready** - Pre-configured GitHub Actions

## 🎯 Use Cases

This template is suitable for:
- ✅ Quickly starting new C++ projects
- ✅ Cross-platform libraries or applications
- ✅ Team projects requiring high code quality standards
- ✅ Production projects needing complete testing and CI/CD
- ✅ Learning modern C++ project best practices

## 📋 Platform Support Matrix

| OS | Arch | Compiler | Build Tool | Status |
|---|---|---|---|---|
| Windows | x86_64, arm64 | MSVC, Clang | Visual Studio, Ninja | ✅ |
| Linux | x86_64, arm64 | GCC, Clang | Make, Ninja | ✅ |
| macOS | x86_64, arm64, universal | Clang | Xcode, Ninja | ✅ |
| iOS | arm64 | Clang | Xcode, Ninja | ✅ |
| Android | arm64 | Clang | Ninja | ✅ (NDK) |
| WebAssembly | - | Clang | Ninja | ✅ (Emscripten) |

## 🚀 Quick Start

### Prerequisites

- CMake 3.28+
- C++23-capable compiler:
  - Clang 19.1+ (full C++ module support)
  - GCC 15.2+ (full C++ module support)
  - MSVC 19.42+ (Visual Studio 2022 17.12+, full C++ module support)
- Ninja (recommended)

### Creating a Project from This Template

#### Method 1: Use GitHub Template

1. Click the "Use this template" button
2. Create your new repository
3. Clone locally and customize

#### Method 2: Manual Clone

```bash
# Clone the template
git clone https://github.com/xbigo/ape-template.git my-project
cd my-project

# Remove original git history
rm -rf .git
git init

# Customize the project (see below)
```

### Customizing the Template

1. **Update Project Information**
   - Edit `CMakeLists.txt`: modify project name, version, description
   - Edit `README.md`: update project information
   - Edit `LICENSE`: update copyright information

2. **Rename Namespace**
   - Global search and replace `ape_template` with your project namespace
   - Rename `include/ape_template` directory

3. **Configure Project**
   ```bash
   cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
   ```

4. **Build and Test**
   ```bash
   cmake --build build --parallel
   cd build && ctest --output-on-failure
   ```

### Build Steps

```bash
# Configure
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release

# Build
cmake --build build --parallel

# Run tests
cd build && ctest --output-on-failure
```

For detailed build instructions, see [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md).

## 🐳 Docker Builds

The project provides complete Docker support for containerized builds:

```bash
# Linux build
bash scripts/docker-build.sh -p linux -t Release -r

# Android build
bash scripts/docker-build.sh -p android -t Release

# WebAssembly build
bash scripts/docker-build.sh -p webassembly -t Release

# Enter interactive shell
bash scripts/docker-shell.sh linux
```

Windows users can use PowerShell scripts:

```powershell
.\scripts\docker-build.ps1 -Platform linux -BuildType Release -RunTests
```

## 📦 Project Structure

```
ape-template/
├── include/ape_template/  # Public headers
├── src/                    # Source code implementation
├── tests/                  # Test code
│   ├── unit/              # Unit tests
│   ├── regression/        # Regression tests
│   ├── fuzz/              # Fuzz tests
│   └── benchmark/         # Performance tests
├── cmake/                  # CMake modules
├── docker/                 # Docker configuration
├── scripts/                # Build scripts
├── docs/                   # Documentation
└── .github/workflows/      # CI/CD configuration
```

For detailed project structure, see [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md).

## 🔧 Build Options

### Build Types

- `Debug` - No optimization, full debug info
- `Release` - Full optimization
- `FastDebug` - Light optimization (O1) + debug info
- `SlowRelease` - No optimization (O0) + Release configuration
- `RelWithDebInfo` - Optimized with debug info
- `MinSizeRel` - Size optimization

### CMake Options

```bash
# Test options
-DAPE_TEMPLATE_BUILD_TESTS=ON              # Build tests (default: ON)
-DAPE_TEMPLATE_BUILD_UNIT_TESTS=ON         # Build unit tests
-DAPE_TEMPLATE_BUILD_REGRESSION_TESTS=ON   # Build regression tests
-DAPE_TEMPLATE_BUILD_FUZZ_TESTS=OFF        # Build fuzz tests
-DAPE_TEMPLATE_BUILD_BENCHMARKS=ON         # Build benchmarks

# Code quality
-DAPE_TEMPLATE_ENABLE_COVERAGE=OFF         # Enable code coverage
-DAPE_TEMPLATE_ENABLE_CLANG_TIDY=ON        # Enable clang-tidy

# Sanitizers
-DAPE_TEMPLATE_ENABLE_SANITIZERS=OFF       # Enable sanitizers
-DAPE_TEMPLATE_SANITIZER_TYPE=address      # Sanitizer type

# Other options
-DAPE_TEMPLATE_BUILD_DOCS=OFF              # Build documentation
-DAPE_TEMPLATE_STRIP_SYMBOLS=OFF           # Strip symbols
-DAPE_TEMPLATE_ENABLE_DISTRIBUTED_BUILD=OFF # Distributed build
-DAPE_TEMPLATE_USE_MODULES=ON              # Enable C++ modules
```

## 🧪 Testing

The project includes a complete test suite:

```bash
# Run all tests
cd build && ctest --output-on-failure

# Run unit tests only
ctest -L unit

# Run regression tests only
ctest -L regression

# Generate code coverage report
cmake -B build -DAPE_TEMPLATE_ENABLE_COVERAGE=ON
cmake --build build --target coverage
```

## 📚 Documentation

Generate API documentation:

```bash
cmake -B build -DAPE_TEMPLATE_BUILD_DOCS=ON
cmake --build build --target doc
```

Generated documentation is located at `build/docs/html/index.html`.

## 🎓 Template Features

### Build System
- ✅ CMake 3.28+ configuration
- ✅ Multiple generators support (Ninja, Make, Visual Studio, Xcode)
- ✅ Custom build types (FastDebug, SlowRelease)
- ✅ Debug symbol separation
- ✅ C++ module support
- ✅ Package configuration files

### Code Quality
- ✅ clang-format configuration
- ✅ clang-tidy configuration
- ✅ EditorConfig configuration
- ✅ Compiler warning configuration
- ✅ Sanitizer support (Address, Memory, Thread, Undefined, Leak)

### Testing Framework
- ✅ Google Test integration
- ✅ Google Benchmark integration
- ✅ Fuzz testing configuration (libFuzzer)
- ✅ Code coverage reporting

### Docker Support
- ✅ Linux build environment
- ✅ Android NDK environment
- ✅ WebAssembly (Emscripten) environment
- ✅ Build scripts (Bash + PowerShell)

### Development Tools
- ✅ Complete VSCode configuration
- ✅ Build tasks
- ✅ Debug configuration
- ✅ Recommended extensions list

### CI/CD
- ✅ GitHub Actions workflows
- ✅ Multi-platform builds (Linux, Windows, macOS)
- ✅ Multi-compiler testing
- ✅ Sanitizer testing
- ✅ Code coverage upload
- ✅ Format checking
- ✅ Static analysis
- ✅ Automated releases

### Documentation
- ✅ Doxygen configuration
- ✅ Complete README
- ✅ Build instructions
- ✅ Contribution guide
- ✅ Project structure description
- ✅ Compiler version requirements

## 🤝 Contributing

Contributions to improve this template are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution guidelines.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Related Resources

- [Build Instructions](BUILD_INSTRUCTIONS.md) - Detailed build guide
- [Compiler Version Requirements](COMPILER_VERSIONS.md) - Compiler version details
- [Project Structure](PROJECT_STRUCTURE.md) - Project organization description
- [Contributing Guide](CONTRIBUTING.md) - How to participate in the project

## 📞 Feedback and Support

For questions or suggestions:
- Submit an [Issue](https://github.com/xbigo/ape-template/issues)
- Start a [Discussion](https://github.com/xbigo/ape-template/discussions)
- If you find it useful, please give it a ⭐️

## 🙏 Acknowledgments

Thanks to the following open source projects:
- [CMake](https://cmake.org/)
- [Google Test](https://github.com/google/googletest)
- [Google Benchmark](https://github.com/google/benchmark)
- [Doxygen](https://www.doxygen.nl/)

---

**✨ Use this template to start your C++ project on the right path from the beginning!**
