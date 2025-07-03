# 🐳 Docker Overview for Hunyuan3D-2.1 CachedStart

## Docker Integration

This repository provides comprehensive Docker support for running Hunyuan3D-2.1 easily in Docker containers. The **"CachedStart"** fork focuses on optimizing the startup experience through persistent caching mechanisms, significantly reducing initialization time after the first run.

## ✨ Key Features

- **Persistent Model Caching** - Models are stored on the host system and persist between container restarts
- **Fast Subsequent Startups** - Up to 10x faster launch times after initial download
- **GPU Acceleration** - Optimized performance with CUDA 12.4 support
- **Cross-Platform Support** - Works on both Windows and Linux environments

## 🚀 Quick Start

```bash
# Build the image
docker build --no-cache -t kechiro/hunyuan3d-2.1-cachedstart:latest -f docker/Dockerfile .

# Run with GUI (with persistent cache for faster subsequent starts)
docker run --gpus all -p 8080:8080 -v ./model_cache:/workspace/model_cache kechiro/hunyuan3d-2.1-cachedstart:latest python3 gradio_app.py

# Run API server (with the same persistent cache)
docker run --gpus all -p 8081:8081 -v ./model_cache:/workspace/model_cache kechiro/hunyuan3d-2.1-cachedstart:latest python3 api_server.py
```

## 📦 Docker Image Configuration

The Docker image includes the following components:

- NVIDIA CUDA 12.4.1 base environment
- Python 3.10 + PyTorch 2.5.1 (with CUDA support)
- All dependencies for Hunyuan3D-2.1
- Pre-configured model cache directories for immediate use
- Pre-compiled custom rasterizers for optimal performance
- Optimized sample image gallery (108 high-quality examples)

## 💾 Persistent Model Cache - The CachedStart Advantage

**The core feature of this CachedStart fork** is the persistent model cache system that dramatically reduces startup time on subsequent runs. The Docker image mounts the `model_cache` directory to the host system, preventing redundant downloads:

```
model_cache/
├── huggingface/         # HuggingFace model cache (multiple GB of models)
├── hy3dgen/             # Hunyuan3D-specific models
└── .u2net/              # Background removal models
```

### Benefits of the Persistent Cache

- **First run**: Downloads all necessary models (~10GB+)
- **Subsequent runs**: Near-instant startup (10x faster)
- **Container restarts**: No re-downloading required
- **Disk space efficiency**: Models stored only once on the host

This persistent caching mechanism is what makes the "CachedStart" fork particularly valuable for production and development environments.

## 🛠️ Build Instructions

For detailed build instructions, refer to [docker/BUILD_INSTRUCTIONS.md](docker/BUILD_INSTRUCTIONS.md).

## 🔍 Troubleshooting

Common issues during build or runtime:

1. **GPU not recognized** - Verify NVIDIA drivers and Docker GPU configuration
2. **Out of memory errors** - Increase Docker Desktop resource allocation (8GB+ recommended)
3. **Long build times** - Check internet connection and consider using cached builds
4. **Cache not persisting** - Ensure proper volume mounting with absolute paths

For more detailed troubleshooting, refer to [docker/README.md](docker/README.md).

## 📄 Environment Variables

Key environment variables available in the Docker container:

| Variable Name | Description | Default |
|--------------|-------------|---------|
| `HF_HOME` | HuggingFace cache location | `/workspace/model_cache/huggingface` |
| `HF_MODULES_CACHE` | HuggingFace modules cache | `/workspace/model_cache/huggingface/modules` |
| `CACHE_ENABLED` | Enable persistent caching | `true` |

## 📋 Supported Tags

- `kechiro/hunyuan3d-2.1-cachedstart:latest` - Latest stable CachedStart release
- `kechiro/hunyuan3d-2.1-cachedstart:v2.1` - Version tagged release

## ⚡ Performance Comparison

| Scenario | Original Repo | CachedStart Fork |
|----------|---------------|------------------|
| First startup | 10-15 minutes | 10-15 minutes |
| Subsequent startups | 10-15 minutes | 30-60 seconds |
| Container restarts | Full redownload | Instant cache reuse |

## 👥 Contributing

Contributions to improve the Docker configuration or build instructions are welcome. The CachedStart fork specifically aims to enhance the user experience through optimized caching mechanisms.
