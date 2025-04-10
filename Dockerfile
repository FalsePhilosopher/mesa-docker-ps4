# Base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    meson \
    ninja-build \
    python3 \
    python3-pip \
    python3-setuptools \
    libdrm-dev \
    libgbm-dev \
    libx11-dev \
    libxext-dev \
    libxdamage-dev \
    libxfixes-dev \
    libxcb-glx0-dev \
    libxcb-dri2-0-dev \
    libxcb-dri3-dev \
    libxcb-present-dev \
    libxcb-sync-dev \
    libxshmfence-dev \
    libxxf86vm-dev \
    zlib1g-dev \
    wget \
    curl \
    && apt-get clean

# Clone Mesa repository
RUN git clone https://gitlab.freedesktop.org/mesa/mesa.git /mesa

# Set working directory
WORKDIR /mesa