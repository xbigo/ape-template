from conan import ConanFile
from conan.tools.cmake import CMake, CMakeToolchain, CMakeDeps, cmake_layout


class Ape2Conan(ConanFile):
    name = "ape-template"
    version = "0.1.0"
    license = "MIT"  # Change to your license
    author = "Your Name <your.email@example.com>"
    url = "https://github.com/xbigo/ape-template"
    description = "A comprehensive C++ library collection"
    topics = ("cpp", "library", "cross-platform")
    settings = "os", "compiler", "build_type", "arch"
    options = {
        "shared": [True, False],
        "fPIC": [True, False],
        "enable_tests": [True, False],
    }
    default_options = {
        "shared": False,
        "fPIC": True,
        "enable_tests": True,
    }
    exports_sources = "CMakeLists.txt", "src/*", "include/*", "cmake/*", "tests/*"

    def config_options(self):
        if self.settings.os == "Windows":
            del self.options.fPIC

    def configure(self):
        if self.options.shared:
            self.options.rm_safe("fPIC")

    def requirements(self):
        # Add your dependencies here
        # Example:
        # self.requires("boost/1.82.0")
        # self.requires("zlib/1.2.13")
        pass

    def build_requirements(self):
        # Build-only dependencies
        # Example:
        # self.tool_requires("cmake/3.28.1")
        pass

    def layout(self):
        cmake_layout(self)

    def generate(self):
        deps = CMakeDeps(self)
        deps.generate()
        tc = CMakeToolchain(self)
        tc.variables["APE2_BUILD_TESTS"] = self.options.enable_tests
        tc.generate()

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def package(self):
        cmake = CMake(self)
        cmake.install()

    def package_info(self):
        self.cpp_info.libs = ["ape-template_core", "ape-template_utils"]
        self.cpp_info.includedirs = ["include"]

