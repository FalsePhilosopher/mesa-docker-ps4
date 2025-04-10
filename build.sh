#!/bin/bash

# Exit on any error
set -e

# Variables
MESA_VERSION=mesa-25.0.1
LIBDRM_VERSION=2.4.124
XORG_VERSION=23.0.0

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
meson setup  build64 \
    -D b_ndebug=true \
    -D b_lto=true \
    -D buildtype=plain \
    --wrap-mode=nofallback \
    -D prefix=/usr \
    -D sysconfdir=/etc \
    --libdir=/usr/x86_64 \
    -D platforms=x11,wayland \
    -D gallium-drivers=kmsro,radeonsi,r300,r600,nouveau,freedreno,swrast,v3d,vc4,etnaviv,tegra,i915,svga,virgl,panfrost,iris,lima,zink,d3d12,asahi,crocus \
    -D vulkan-drivers=amd,swrast,intel \
    -D dri3=enabled \
    -D egl=enabled \
    -D gallium-extra-hud=true \
    -D gallium-nine=true \
    -D gallium-omx=bellagio \
    -D gallium-va=enabled \
    -D gallium-vdpau=enabled \
    -D gallium-xa=enabled \
    -D gallium-omx=disabled \
    -D gbm=enabled \
    -D gles1=disabled \
    -D gles2=enabled \
    -D glvnd=true \
    -D glx=dri \
    -D libunwind=enabled \
    -D llvm=enabled \
    -D lmsensors=enabled \
    -D osmesa=true \
    -D shared-glapi=enabled \
    -D gallium-opencl=icd \
    -D valgrind=disabled \
    -D vulkan-layers=device-select,overlay \
    -D tools=[] \
    -D zstd=enabled \
    -D microsoft-clc=disabled \
ninja -C build64
sudo ninja -C build64 install
cd ..

# Build libdrm
echo "Building libdrm..."
cd libdrm-ps4
meson setup build64 \
    --prefix /usr \
    --libdir x86_64 \
    --buildtype plain \
    --wrap-mode      nofallback \
    -D udev=false \
    -D valgrind=disabled \
    -D intel=enabled
meson configure build64
ninja -C build64
meson test -C build64 -t 10
sudo ninja -C build64 install