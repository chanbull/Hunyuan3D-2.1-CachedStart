# 🐳 Docker Overview for Hunyuan3D-2.1 CachedStart

## Docker Integration

This repository provides comprehensive Docker support for running Hunyuan3D-2.1 easily in Docker containers. The **"CachedStart"** fork focuses on optimizing the startup experience through persistent caching mechanisms, significantly reducing initialization time after the first run.

## ✨ Key Features

- **Persistent Model Caching** - Models are stored on the host system and persist between container restarts
- **Fast Subsequent Startups** - Up to 10x faster launch times after initial download
- **GPU Acceleration** - Optimized performance with CUDA 12.4 support
- **Cross-Platform Support** - Works on both Windows and Linux environments

## 🚀 Quick Start

### Option 1: Pre-built Image from Docker Hub (Recommended)
```bash
# Pull pre-built image from Docker Hub
docker pull kechiro/hunyuan3d-2.1-cachedstart:latest

# Run with GUI (with persistent cache for faster subsequent starts)
docker run --gpus all -p 8080:8080 -v ./model_cache:/workspace/model_cache kechiro/hunyuan3d-2.1-cachedstart:latest python3 gradio_app.py

# Run API server (with the same persistent cache)
docker run --gpus all -p 8081:8081 -v ./model_cache:/workspace/model_cache kechiro/hunyuan3d-2.1-cachedstart:latest python3 api_server.py
```

### Option 2: Build from Source
```bash
# Build the image locally
./docker-build-commands.sh

# Or manually build
docker build --no-cache -t kechiro/hunyuan3d-2.1-cachedstart:latest -f docker/Dockerfile .
```

### Option 3: Docker Compose (Production)
```bash
# Using docker-compose for easier management
docker-compose up -d

# Stop services
docker-compose down
```

## 📦 Docker Image Configuration

The Docker image includes the following components:

- **Base Environment**: NVIDIA CUDA 12.4.1 on Ubuntu 22.04
- **Python Environment**: Python 3.10 + PyTorch 2.5.1 (with CUDA 12.4 support)
- **Dependencies**: All requirements from `requirements.txt` pre-installed
- **Model Cache**: Pre-configured cache directories with optimized paths
- **Custom Rasterizers**: Pre-compiled for optimal 3D rendering performance
- **Sample Gallery**: 108 high-quality example images in `assets/example_images/`
- **Auto-Downloads**: RealESRGAN model automatically downloaded on first run
- **Production Ready**: Enhanced error handling and timeout mechanisms

**Image Size**: ~12-15 GB (includes all dependencies and optimizations)

## 💾 Persistent Model Cache - The CachedStart Advantage

**The core feature of this CachedStart fork** is the persistent model cache system that dramatically reduces startup time on subsequent runs. The Docker image mounts the `model_cache` directory to the host system, preventing redundant downloads:

```
model_cache/
├── huggingface/          # HuggingFace model cache (~10GB+)
│   ├── models--tencent--Hunyuan3D-2/    # Main 3D generation model
│   ├── models--microsoft--DiT-XL-2-256/ # Diffusion transformer
│   └── modules/          # Shared HuggingFace modules
├── hy3dgen/              # Hunyuan3D-specific models
└── .u2net/               # Background removal models
```

### Benefits of the Persistent Cache

- **First run**: Downloads all necessary models (~15-20GB total)
- **Subsequent runs**: Near-instant startup (30-60 seconds vs 10+ minutes)
- **Container restarts**: No re-downloading required
- **Disk space efficiency**: Models stored only once on the host
- **Multi-container support**: Shared cache across multiple instances
- **Development friendly**: Fast iteration cycles with cached models

This persistent caching mechanism is what makes the "CachedStart" fork particularly valuable for production and development environments.

## 🛠️ Build Instructions

For detailed build instructions, see:
- [DOCKER_BUILD_GUIDE.md](DOCKER_BUILD_GUIDE.md) - Comprehensive build guide
- [DOCKER_BUILD_GUIDE_JP.md](DOCKER_BUILD_GUIDE_JP.md) - Japanese version
- [docker/BUILD_INSTRUCTIONS.md](docker/BUILD_INSTRUCTIONS.md) - Legacy documentation

## 🔍 Troubleshooting

Common issues during build or runtime:

1. **GPU not recognized** 
   ```bash
   # Verify NVIDIA drivers and Docker GPU configuration
   docker run --rm --gpus all nvidia/cuda:12.4.1-base-ubuntu22.04 nvidia-smi
   ```

2. **Out of memory errors** 
   - Increase Docker Desktop resource allocation (16GB+ recommended)
   - Use `--low_vram_mode` flag for the application

3. **Long build times** 
   - Use pre-built image from Docker Hub: `docker pull kechiro/hunyuan3d-2.1-cachedstart:latest`
   - Check internet connection and consider using build cache

4. **Cache not persisting** 
   - Ensure proper volume mounting with absolute paths
   - Verify `./model_cache` directory permissions

5. **Application timeouts**
   - Reduce texture generation parameters (`max_num_view`, `resolution`)
   - Monitor GPU memory usage with `nvidia-smi`

For more detailed troubleshooting, refer to [docker/README.md](docker/README.md).

## 📄 Environment Variables

Key environment variables available in the Docker container:

| Variable Name | Description | Default |
|--------------|-------------|---------|
| `HF_HOME` | HuggingFace cache location | `/workspace/model_cache/huggingface` |
| `HF_MODULES_CACHE` | HuggingFace modules cache | `/workspace/model_cache/huggingface/modules` |
| `CACHE_ENABLED` | Enable persistent caching | `true` |

## 📋 Supported Tags and Images

**Docker Hub Repository**: [kechiro/hunyuan3d-2.1-cachedstart](https://hub.docker.com/r/kechiro/hunyuan3d-2.1-cachedstart)

| Tag | Description | Size | Build Date |
|-----|-------------|------|------------|
| `latest` | Latest stable CachedStart release | ~12-15GB | Always current |
| `v2.1` | Version tagged release for Hunyuan3D-2.1 | ~12-15GB | Stable |

**Pull Commands:**
```bash
# Latest version (recommended)
docker pull kechiro/hunyuan3d-2.1-cachedstart:latest

# Specific version
docker pull kechiro/hunyuan3d-2.1-cachedstart:v2.1
```

## ⚡ Performance Comparison

| Scenario | Original Repo | CachedStart Fork |
|----------|---------------|------------------|
| First startup | 10-15 minutes | 15-20 minutes |
| Subsequent startups | 10-15 minutes | 30-60 seconds |
| Container restarts | Full redownload | Instant cache reuse |
| Model download size | ~18GB each time | ~18GB one time |
| Development workflow | Slow iteration | Fast iteration |

## 👥 Contributing

Contributions to improve the Docker configuration, build instructions, or caching mechanisms are welcome. The CachedStart fork specifically aims to enhance the user experience through:

- **Optimized caching mechanisms** for faster startup times
- **Improved build processes** with better error handling
- **Enhanced documentation** for easier deployment
- **Production-ready configurations** for stable operation

**Areas for contribution:**
- Docker image optimization and size reduction
- Multi-architecture support (ARM64, AMD64)
- Alternative deployment methods (Kubernetes, etc.)
- Performance benchmarking and optimization
- Documentation improvements and translations

For contributing guidelines, see the main repository [CONTRIBUTING.md](CONTRIBUTING.md).
