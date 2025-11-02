免责声明：

只有这个文件的中文版本是作者原创的， 其他的所有内容都是由AI生成。 我对其生成的文件中营销似的措辞很不安，但那不是我的本意。因为这只是我的一个练习， 我也不想浪费时间去纠正。特此申明。

-----


这是一个从零开始创建的C++项目， 计划包含一系列通用和专用的程序库组件。

本项目需要支持多种操作系统和编译器， 并采用最新的C++标准。计划以CMake作为构建脚本的基本工具， 并支持生成特定平台常用的工程文件。
具体支持矩阵如下
| OS | Arch | Compiler| Build Tool | Comments|
|--- |--- |---|---|---|
|Windows| x86_64, arm64 | MSVC, Clang | Visual Studio, Ninja||
|Linux | x86_64, arm64 | Gcc, Clang | Make, Ninja||
|MacOS | x86_64, arm64, universal | Clang | Xcode， Ninja ||
|iOS | arm64 | Clang | Xcode, Ninja? ||
|Android| arm64 | Clang | Android Studio, Ninja |需要 NDK|
|WebAssembly| nodejs, browser | Clang | Make, Ninja | 需要EMSDK|

其中Linux，Android，和WebAssembly 要支持Docker 构建。 项目代码和生成目录应该映射入Docker容器， 并注意容器内不要以root用户构建项目。另外， 需要支持将host环境中存储的私钥和其他敏感信息文件映射到Docker内恰当的目录。需要创建符合上述要求的Dockerfile，也可以引用满足要求的已有的Docker image。为此创建能简化操作的辅助脚本。


编译配置和开发环境要求
- 代码将采用C++23标准
- 启用尽可能多的检查选项，报告不符合标准的代码。
- 启用clang-tidy 和clang-format。
- 支持Debug，Relase 等多种构建类型， 但所有构建都要生成分离的调试符号文件。
- 支持FastDebug 构建类型，该配置和Debug相同， 但是优化级别为O1
- 支持SlowRelease 构建类型。该配置和Release相同，但是优化级别为O0
- 启用C++ module


编译支持的参数要求如下
- 可开启各种Sanitizer， 包裹但不限于Memory，Address。 默认关闭
- 允许Strip 生成的共享库中的符号。 默认关闭。
- 支持分布式编译，默认关闭。

特定的编译目标
- Doc. 生成doxygen文档。 默认只在Linux docker环境中开启。当别的OS存在doxygen 程序时，也可以开启。
- 支持Local install

第三方库
- 本项目会引用少量第三方库， 包括但不限于Boost， Zlib, SQLite等。
- 需要试验性引入Github上的某些程序库。
- 为了支持多个平台， 可能需要为第三方库打补丁。需要妥善组织和管理这些patch文件。
- 选择合适的包管理器或直接使用CMake。

测试
- 区分单元测试，回归测试，和Fuzz 测试。另外还有benchmark测试和压力测试。
- 运行单元测试要作为post build 步骤存在。
- 回归测试和Fuzz测试要和其他测试代码分离。
- 生成代码覆盖率报告

其他构建配置
- 创建支持VScode的配置
- 创建Git Actions 配置和脚本
- 生成代码静态分析报告
- 生成项目分析报告
  - 生成项目依赖关系图
  - 代码质量分析报告

注意事项：
- MacOS，iOS 要正确处理签名和打包问题。Android 也需要考虑签名和打包问题。
- 构建系统要支持Git Action。
  - 适当考虑其他环境， 如Jenkins，Azure 等。

