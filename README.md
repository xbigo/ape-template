# ape-template - Advanced C++ Project Template

[![CI](https://github.com/xbigo/ape-template/workflows/CI/badge.svg)](https://github.com/xbigo/ape-template/actions)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![C++23](https://img.shields.io/badge/C%2B%2B-23-blue.svg)](https://en.cppreference.com/w/cpp/23)

这是一个从零开始创建的**现代C++项目模板**，包含完整的构建系统、测试框架、CI/CD配置和开发工具链。可作为新项目的起点，节省大量配置时间。

## ✨ 为什么选择这个模板？

- 🚀 **开箱即用** - 所有工具和配置已准备就绪
- 🎯 **生产级质量** - 经过完整测试和验证的配置
- 📦 **可重复使用** - 轻松适配到您的项目
- 🔧 **现代C++23** - 使用最新的C++特性和模块支持
- 🌍 **真正跨平台** - Windows、Linux、macOS、iOS、Android、WebAssembly
- 🐳 **容器化构建** - Docker支持保证环境一致性
- 🧪 **完整测试** - 单元测试、回归测试、Fuzz测试、性能基准测试
- 📊 **代码质量** - clang-tidy、clang-format、代码覆盖率
- 📚 **自动化文档** - Doxygen配置
- 🔄 **CI/CD就绪** - GitHub Actions预配置

## 🎯 适用场景

本模板适合：
- ✅ 需要快速启动新C++项目
- ✅ 需要跨平台支持的库或应用
- ✅ 需要高质量代码标准的团队项目
- ✅ 需要完整测试和CI/CD的生产项目
- ✅ 学习现代C++项目最佳实践

## 📋 平台支持矩阵

| OS | Arch | Compiler | Build Tool | Status |
|---|---|---|---|---|
| Windows | x86_64, arm64 | MSVC, Clang | Visual Studio, Ninja | ✅ |
| Linux | x86_64, arm64 | GCC, Clang | Make, Ninja | ✅ |
| macOS | x86_64, arm64, universal | Clang | Xcode, Ninja | ✅ |
| iOS | arm64 | Clang | Xcode, Ninja | ✅ |
| Android | arm64 | Clang | Ninja | ✅ (NDK) |
| WebAssembly | - | Clang | Ninja | ✅ (Emscripten) |

## 🚀 快速开始

### 前置条件

- CMake 3.28+
- C++23支持的编译器：
  - Clang 19.1+ (完整的C++模块支持)
  - GCC 15.2+ (完整的C++模块支持)
  - MSVC 19.42+ (Visual Studio 2022 17.12+，完整的C++模块支持)
- Ninja (推荐)

### 使用此模板创建项目

#### 方法1：使用GitHub模板

1. 点击 "Use this template" 按钮
2. 创建您的新仓库
3. 克隆到本地并自定义

#### 方法2：手动克隆

```bash
# 克隆模板
git clone https://github.com/xbigo/ape-template.git my-project
cd my-project

# 移除原始git历史
rm -rf .git
git init

# 自定义项目（见下文）
```

### 自定义模板

1. **更新项目信息**
   - 编辑 `CMakeLists.txt`：修改项目名称、版本、描述
   - 编辑 `README.md`：更新项目信息
   - 编辑 `LICENSE`：更新版权信息

2. **重命名命名空间**
   - 全局搜索替换 `ape_template` 为您的项目命名空间
   - 重命名 `include/ape_template` 目录

3. **配置项目**
   ```bash
   cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
   ```

4. **编译测试**
   ```bash
   cmake --build build --parallel
   cd build && ctest --output-on-failure
   ```

### 构建步骤

```bash
# 配置
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release

# 编译
cmake --build build --parallel

# 运行测试
cd build && ctest --output-on-failure
```

详细的构建说明请参阅 [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)。

## 🐳 Docker构建

项目提供了完整的Docker支持，可以在容器中进行构建：

```bash
# Linux构建
bash scripts/docker-build.sh -p linux -t Release -r

# Android构建
bash scripts/docker-build.sh -p android -t Release

# WebAssembly构建
bash scripts/docker-build.sh -p webassembly -t Release

# 进入交互式Shell
bash scripts/docker-shell.sh linux
```

Windows用户可以使用PowerShell脚本：

```powershell
.\scripts\docker-build.ps1 -Platform linux -BuildType Release -RunTests
```

## 📦 项目结构

```
ape-template/
├── include/ape_template/  # 公共头文件
├── src/                    # 源代码实现
├── tests/                  # 测试代码
│   ├── unit/              # 单元测试
│   ├── regression/        # 回归测试
│   ├── fuzz/              # Fuzz测试
│   └── benchmark/         # 性能测试
├── cmake/                  # CMake模块
├── docker/                 # Docker配置
├── scripts/                # 构建脚本
├── docs/                   # 文档
└── .github/workflows/      # CI/CD配置
```

详细的项目结构说明请参阅 [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)。

## 🔧 构建选项

### 构建类型

- `Debug` - 无优化，完整调试信息
- `Release` - 完全优化
- `FastDebug` - 轻度优化(O1) + 调试信息
- `SlowRelease` - 无优化(O0) + Release配置
- `RelWithDebInfo` - 优化 + 调试信息
- `MinSizeRel` - 体积优化

### CMake选项

```bash
# 测试选项
-DAPE_TEMPLATE_BUILD_TESTS=ON              # 构建测试 (默认: ON)
-DAPE_TEMPLATE_BUILD_UNIT_TESTS=ON         # 构建单元测试
-DAPE_TEMPLATE_BUILD_REGRESSION_TESTS=ON   # 构建回归测试
-DAPE_TEMPLATE_BUILD_FUZZ_TESTS=OFF        # 构建Fuzz测试
-DAPE_TEMPLATE_BUILD_BENCHMARKS=ON         # 构建性能测试

# 代码质量
-DAPE_TEMPLATE_ENABLE_COVERAGE=OFF         # 启用代码覆盖率
-DAPE_TEMPLATE_ENABLE_CLANG_TIDY=ON        # 启用clang-tidy

# Sanitizers
-DAPE_TEMPLATE_ENABLE_SANITIZERS=OFF       # 启用Sanitizer
-DAPE_TEMPLATE_SANITIZER_TYPE=address      # Sanitizer类型

# 其他选项
-DAPE_TEMPLATE_BUILD_DOCS=OFF              # 生成文档
-DAPE_TEMPLATE_STRIP_SYMBOLS=OFF           # 剥离符号
-DAPE_TEMPLATE_ENABLE_DISTRIBUTED_BUILD=OFF # 分布式编译
-DAPE_TEMPLATE_USE_MODULES=ON              # 启用C++模块
```

## 🧪 测试

项目包含完整的测试套件：

```bash
# 运行所有测试
cd build && ctest --output-on-failure

# 只运行单元测试
ctest -L unit

# 只运行回归测试
ctest -L regression

# 生成代码覆盖率报告
cmake -B build -DAPE_TEMPLATE_ENABLE_COVERAGE=ON
cmake --build build --target coverage
```

## 📚 文档

生成API文档：

```bash
cmake -B build -DAPE_TEMPLATE_BUILD_DOCS=ON
cmake --build build --target doc
```

生成的文档位于 `build/docs/html/index.html`。

## 🎓 模板包含的功能

### 构建系统
- ✅ CMake 3.28+ 配置
- ✅ 支持多种生成器（Ninja、Make、Visual Studio、Xcode）
- ✅ 自定义构建类型（FastDebug、SlowRelease）
- ✅ 调试符号分离
- ✅ C++模块支持
- ✅ 包配置文件

### 代码质量
- ✅ clang-format配置
- ✅ clang-tidy配置
- ✅ EditorConfig配置
- ✅ 编译器警告配置
- ✅ Sanitizer支持（Address、Memory、Thread、Undefined、Leak）

### 测试框架
- ✅ Google Test集成
- ✅ Google Benchmark集成
- ✅ Fuzz测试配置（libFuzzer）
- ✅ 代码覆盖率报告

### Docker支持
- ✅ Linux构建环境
- ✅ Android NDK环境
- ✅ WebAssembly (Emscripten) 环境
- ✅ 构建脚本（Bash + PowerShell）

### 开发工具
- ✅ VSCode完整配置
- ✅ 构建任务
- ✅ 调试配置
- ✅ 推荐扩展列表

### CI/CD
- ✅ GitHub Actions工作流
- ✅ 多平台构建（Linux、Windows、macOS）
- ✅ 多编译器测试
- ✅ Sanitizer测试
- ✅ 代码覆盖率上传
- ✅ 格式检查
- ✅ 静态分析
- ✅ 自动化发布

### 文档
- ✅ Doxygen配置
- ✅ 完整的README
- ✅ 构建说明
- ✅ 贡献指南
- ✅ 项目结构说明
- ✅ 编译器版本要求

## 🤝 贡献

欢迎改进此模板！请阅读 [CONTRIBUTING.md](CONTRIBUTING.md) 了解详细的贡献指南。

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件。

## 🔗 相关资源

- [构建说明](BUILD_INSTRUCTIONS.md) - 详细的构建指南
- [编译器版本要求](COMPILER_VERSIONS.md) - 编译器版本详细说明
- [项目结构](PROJECT_STRUCTURE.md) - 项目组织说明
- [贡献指南](CONTRIBUTING.md) - 如何参与项目

## 📞 反馈和支持

如有问题或建议，请：
- 提交 [Issue](https://github.com/xbigo/ape-template/issues)
- 发起 [Discussion](https://github.com/xbigo/ape-template/discussions)
- 如果觉得有用，请给个 ⭐️

## 🙏 致谢

感谢以下开源项目：
- [CMake](https://cmake.org/)
- [Google Test](https://github.com/google/googletest)
- [Google Benchmark](https://github.com/google/benchmark)
- [Doxygen](https://www.doxygen.nl/)

---

**✨ 使用此模板，让您的C++项目从一开始就走在正确的道路上！**
