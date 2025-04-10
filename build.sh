#!/bin/bash

# Exit on any error
set -e

# Apply patches
echo "Applying patches..."
for patch in $(ls /patches/*.patch); do
    echo "Applying $patch..."
    git apply "$patch"
done

# Build Mesa
echo "Building Mesa..."
meson setup builddir --prefix=/mesa/install
ninja -C builddir
ninja -C builddir install

echo "Build complete. Mesa installed in /mesa/install."