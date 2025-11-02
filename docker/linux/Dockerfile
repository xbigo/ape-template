# Dockerfile for Linux development and building
FROM ubuntu:24.10

# Set non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Install build essentials and tools
RUN apt-get update && apt-get install -y \
    # Compilers
    build-essential \
    gcc-15 \
    g++-15 \
    clang-19 \
    clang-format-19 \
    clang-tidy-19 \
    lld-19 \
    lldb-19 \
    # Build tools
    cmake \
    ninja-build \
    make \
    ccache \
    # Version control
    git \
    # Documentation
    doxygen \
    graphviz \
    # Utilities
    curl \
    wget \
    vim \
    # Coverage tools
    lcov \
    gcovr \
    # Other tools
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Set default compiler versions
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-15 100 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-15 100 && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-19 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-19 100 && \
    update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-19 100 && \
    update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-19 100

# Install latest CMake
RUN wget -q -O cmake-linux.sh https://github.com/Kitware/CMake/releases/download/v3.28.1/cmake-3.28.1-linux-x86_64.sh && \
    sh cmake-linux.sh -- --skip-license --prefix=/usr/local && \
    rm cmake-linux.sh

# Create a non-root user for building
ARG USERNAME=builder
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \
    mkdir -p /workspace /build && \
    chown -R $USERNAME:$USERNAME /workspace /build

# Setup ccache
RUN mkdir -p /home/$USERNAME/.ccache && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.ccache

# Set working directory
WORKDIR /workspace

# Switch to non-root user
USER $USERNAME

# Set environment variables
ENV CC=gcc
ENV CXX=g++
ENV PATH="/usr/lib/ccache:${PATH}"

CMD ["/bin/bash"]

