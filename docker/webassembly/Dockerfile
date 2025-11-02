# Dockerfile for WebAssembly building with Emscripten
FROM ubuntu:24.04

# Set non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    python3 \
    python3-pip \
    cmake \
    ninja-build \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install Emscripten SDK
ENV EMSDK_ROOT=/opt/emsdk
RUN git clone --depth 1 https://github.com/emscripten-core/emsdk.git ${EMSDK_ROOT} && \
    cd ${EMSDK_ROOT} && \
    ./emsdk install latest && \
    ./emsdk activate latest

# Create a non-root user
ARG USERNAME=builder
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \
    mkdir -p /workspace /build && \
    chown -R $USERNAME:$USERNAME /workspace /build

# Set working directory
WORKDIR /workspace

# Switch to non-root user
USER $USERNAME

# Source emsdk environment in bashrc
RUN echo "source ${EMSDK_ROOT}/emsdk_env.sh" >> /home/${USERNAME}/.bashrc

CMD ["/bin/bash", "-c", "source ${EMSDK_ROOT}/emsdk_env.sh && bash"]

