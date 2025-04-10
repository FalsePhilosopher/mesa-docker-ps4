# Mesa Docker for PS4

This repository contains Docker configurations for building Mesa with patches for PS4. The setup includes multiple `Dockerfile` variations for different distributions, a set of patches, and a build script to streamline the build process.

## Getting Started

### Prerequisites
- Docker installed on your system.

### Supported Distributions
This repository provides Dockerfiles for the following distributions:
- Debian/Ubuntu (`Dockerfile.ubuntu`)
- Arch Linux (`Dockerfile.arch`)
- Fedora (`Dockerfile.fedora`)

### Building the Docker Image
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/mesa-docker-ps4.git
   cd mesa-docker-ps4
   ```

2. Build the Docker image for your desired distribution:

   - **Ubuntu/Debian**:
     ```bash
     docker build -t mesa-ubuntu -f Dockerfile.ubuntu .
     ```

   - **Arch Linux**:
     ```bash
     docker build -t mesa-arch -f Dockerfile.arch .
     ```

   - **Fedora**:
     ```bash
     docker build -t mesa-fedora -f Dockerfile.fedora .
     ```

### Applying Patches and Building Mesa
Run the build script to apply patches and build Mesa:
```bash
./build.sh
```

The script will output the built Mesa binaries.

### Adding or Modifying Patches
To add or modify patches:
1. Place your patch files in the `patches/` directory.
2. Ensure they are listed in the `build.sh` script, which applies patches before building Mesa.

## License
This repository is licensed under the MIT License.