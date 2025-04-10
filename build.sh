#!/bin/bash

# Exit on any error
set -e

# Variables
MESA_VERSION=23.0
LIBDRM_VERSION=2.4.117
XORG_VERSION=22.0.0

# Download source files
echo "Downloading source files..."
wget "https://gitlab.freedesktop.org/mesa/mesa/-/archive/$MESA_VERSION/mesa-$MESA_VERSION.tar.gz"
wget "https://gitlab.freedesktop.org/mesa/drm/-/archive/libdrm-$LIBDRM_VERSION/drm-libdrm-$LIBDRM_VERSION.tar.gz"
wget "https://gitlab.freedesktop.org/xorg/driver/xf86-video-amdgpu/-/archive/xf86-video-amdgpu-$XORG_VERSION/xf86-video-amdgpu-xf86-video-amdgpu-$XORG_VERSION.tar.gz"

# Extract sources
echo "Extracting sources..."
tar -xvzf "mesa-$MESA_VERSION.tar.gz"
mv "mesa-$MESA_VERSION" mesa-ps4
tar -xvzf "drm-libdrm-$LIBDRM_VERSION.tar.gz"
mv "drm-libdrm-$LIBDRM_VERSION" libdrm-ps4
tar -xvzf "xf86-video-amdgpu-xf86-video-amdgpu-$XORG_VERSION.tar.gz"
mv "xf86-video-amdgpu-xf86-video-amdgpu-$XORG_VERSION" xorg-ps4

# Apply patches
echo "Applying patches..."
patch -d mesa-ps4 -p1 < patches/mesa.patch
patch -d libdrm-ps4 -p1 < patches/libdrm.patch
patch -d xorg-ps4 -p1 < patches/xf86-video-amdgpu.patch

# Build Mesa
echo "Building Mesa..."
cd mesa-ps4
meson setup builddir \
    -Dprefix=/usr \
    -Dbuildtype=release \
    -Dplatforms=x11,wayland \
    -Dvulkan-drivers=amd,swrast,intel
ninja -C builddir
sudo ninja -C builddir install
cd ..

# Build libdrm
echo "Building libdrm..."
cd libdrm-ps4
meson setup builddir \
    -Dprefix=/usr \
    -Dbuildtype=release
ninja -C builddir
sudo ninja -C