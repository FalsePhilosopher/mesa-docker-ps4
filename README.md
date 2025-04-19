# Mesa Docker for PS4

This repository contains Docker configurations for building Mesa with patches for PS4 in a github runner and/or docker container.
## Getting Started

### Prerequisites
- Docker installed on your system.

### Building the Docker Image
1. Clone the repository:
   ```
   git clone https://github.com/FalsePhilosopher/mesa-docker-ps4.git
   cd mesa-docker-ps4
   latest_tag=$(curl -s "https://gitlab.freedesktop.org/api/v4/projects/176/repository/tags" | jq -r '.[0].name')
   export LATEST_TAG="$latest_tag"
   latestdrm_tag=$(curl -s "https://gitlab.freedesktop.org/api/v4/projects/177/repository/tags" | jq -r '.[0].name')
   export LATESTDRM_TAG="$latestdrm_tag"
   curl -L "https://gitlab.freedesktop.org/mesa/mesa/-/archive/${{ env.LATEST_TAG }}/${{ env.LATEST_TAG }}.tar.gz" | tar -xzvf -
   mv mesa-* mesa
   curl -L "https://gitlab.freedesktop.org/mesa/drm/-/archive/${{ env.LATESTDRM_TAG }}/drm-${{ env.LATESTDRM_TAG }}.tar.gz" | tar -xzvf -
   mv drm-${{ env.LATESTDRM_TAG }} libdrm

   ```

2. Build the Docker image
     ```
     docker build -t mesa32 -f Dockerfile.mesa32 .
     ```

3. Run the Docker image to build mesa
   ```
   docker run \
            --rm \
            --platform linux/386 \
            -v ${{ github.workspace }}/mesa:/mesa \
            -w /mesa \
            mesa32 \
            bash -c "
            mkdir -p build32 && \
            meson setup build32 --buildtype=release -Dprefix=/usr -Dplatforms=x11,wayland -Dvulkan-drivers=amd,swrast,virtio -Dshader-cache=enabled -Dshader-cache-max-size=8G -Dvulkan-layers=device-select,overlay,screenshot -Dgallium-extra-hud=true -Dgallium-drivers=radeonsi,r600,zink,virgl,softpipe,llvmpipe -Dopengl=true -Dgles1=enabled -Dgles2=enabled -Degl=enabled -Dllvm=enabled -Dlmsensors=enabled -Dglx=dri -Dtools=glsl,nir -Dgallium-vdpau=enabled -Dgallium-va=enabled -Dglvnd=enabled -Dgbm=enabled -Dlibunwind=enabled -Dosmesa=true -Dgallium-nine=true -Dvideo-codecs=vc1dec,h264dec,h264enc,h265dec,h265enc,av1dec,av1enc,vp9dec -Dlegacy-x11=dri2 -Dteflon=true -Dzstd=enabled -Dshared-glapi=enabled -Dmicrosoft-clc=disabled -Dvalgrind=disabled && \
            meson configure build32 && \
            ninja -C build32 && \
            DESTDIR='/mesa/package-root' ninja -C build32 install && \
            mkdir -p package-root/DEBIAN && \
            printf \"Package: ${{ env.LATESTDRM_TAG }}\\nVersion: 42069-${{ env.LATESTDRM_TAG }}-PS4\\nArchitecture: amd64\\nMaintainer: Your Name\\nDescription: libdrm for PS4\\n\" > package-root/DEBIAN/control && \
            dpkg-deb --build package-root lib32${{ env.LATEST_TAG }}-PS4.deb"
   ```
   4. Run the Docker image to build libdrm
      ```
      docker run \
            --rm \
            --platform linux/386 \
            -v ${{ github.workspace }}/libdrm:/libdrm \
            -w /libdrm \
            mesa32 \
            bash -c "
              mkdir -p build32 && \
              meson setup build32 -Dsysconfdir=/etc -Dprefix=/usr --buildtype plain -Dudev=false -Dvalgrind=disabled -Dintel=enabled && \
              meson configure build32 && \
              ninja -C build32 && \
              DESTDIR='/libdrm/package-root' ninja -C build32 install && \
              mkdir -p package-root/DEBIAN && \
              cat <<EOF > package-root/DEBIAN/control
              Package: ${{ env.LATESTDRM_TAG }}
              Version: 42069-${{ env.LATESTDRM_TAG }}-PS4
              Architecture: amd64
              Maintainer: Your Name <youremail@example.com>
              Description: libdrm for PS4
              EOF && \
              dpkg-deb --build package-root lib32${{ env.LATESTDRM_TAG }}-PS4.deb"
      ```
You might have to chown the files in the docker run step if you don't have access to the local docker files if you plan on automating the packaging outside of the container.
