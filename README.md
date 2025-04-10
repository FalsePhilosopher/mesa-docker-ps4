# Mesa Docker for PS4

This repository contains a Docker container setup to build Mesa with patches for PS4. The setup includes a `Dockerfile` for creating the container, a set of patches, and a build script to streamline the process.

## Getting Started

### Prerequisites
- Docker installed on your system.

### Building the Docker Image
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/mesa-docker-ps4.git
   cd mesa-docker-ps4
   ```

2. Build the Docker image:
   ```bash
   docker build -t mesa-ps4 .
   ```

### Applying Patches and Building Mesa
Run the build script to apply patches and build Mesa:
```bash
./build.sh
```

The script will output the built Mesa binaries.

## Customizing Patches
To add or modify patches, place your patch files in the `patches/` directory and ensure they are listed in the `build.sh` script.

## License
This repository is licensed under the MIT License.