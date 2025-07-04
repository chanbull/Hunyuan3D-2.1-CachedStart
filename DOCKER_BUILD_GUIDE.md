# 🐳 Docker Build Guide for Hunyuan3D-2.1 CachedStart

## 📋 Prerequisites

### 1. Docker Installation
- **Windows/Mac**: [Docker Desktop](https://docs.docker.com/get-docker/)
- **Linux**: [Docker Engine](https://docs.docker.com/engine/install/)

### 2. NVIDIA Docker Support (for GPU acceleration)
```bash
# Install NVIDIA Container Toolkit (Linux)
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

## 🚀 Build Instructions

### Option 1: Using the Build Script (Recommended)

```bash
# Clone the repository
git clone https://github.com/kechirojp/Hunyuan3D-2.1-CachedStart.git
cd Hunyuan3D-2.1-CachedStart

# Build with default tag (latest)
./docker-build-commands.sh

# Or build with custom tag
./docker-build-commands.sh v2.1
```

### Option 2: Manual Build

```bash
# Build the Docker image manually
docker build --no-cache -t kechiro/hunyuan3d-2.1-cachedstart:latest -f docker/Dockerfile .

# Build with custom tag
docker build --no-cache -t kechiro/hunyuan3d-2.1-cachedstart:v2.1 -f docker/Dockerfile .
```

## 🔧 Running the Container

### WebUI (Gradio App)
```bash
# Create model cache directory
mkdir -p ./model_cache

# Run WebUI on port 8080
docker run --gpus all -p 8080:8080 -v ./model_cache:/workspace/model_cache kechiro/hunyuan3d-2.1-cachedstart:latest python3 gradio_app.py
```

### API Server
```bash
# Run API server on port 8081
docker run --gpus all -p 8081:8081 -v ./model_cache:/workspace/model_cache kechiro/hunyuan3d-2.1-cachedstart:latest python3 api_server.py
```

### Interactive Shell
```bash
# Start interactive shell for debugging
docker run --gpus all -it -v ./model_cache:/workspace/model_cache kechiro/hunyuan3d-2.1-cachedstart:latest /bin/bash
```

## 💾 Persistent Model Cache

The CachedStart fork's key feature is the persistent model cache:

```bash
# The model_cache directory structure
model_cache/
├── huggingface/          # HuggingFace models cache (~10GB+)
├── hy3dgen/              # Hunyuan3D specific models
└── .u2net/               # Background removal models
```

**Benefits:**
- ✅ **First run**: Downloads all models (~10-15 minutes)
- ✅ **Subsequent runs**: Near-instant startup (30-60 seconds)
- ✅ **Container restarts**: No re-downloading required

## 🔍 Build Logs and Troubleshooting

### Expected Build Time
- **Initial build**: 15-30 minutes (depending on internet speed)
- **CUDA compilation**: 5-10 minutes for custom rasterizers
- **Total image size**: ~8-10 GB

### Common Issues

1. **Out of disk space**
   ```bash
   # Clean up Docker system
   docker system prune -a
   ```

2. **CUDA compilation errors**
   - Ensure NVIDIA drivers are installed
   - Check CUDA compatibility with your GPU

3. **Network timeouts**
   ```bash
   # Use build args for proxy if needed
   docker build --build-arg HTTP_PROXY=http://proxy:port --build-arg HTTPS_PROXY=http://proxy:port -t kechiro/hunyuan3d-2.1-cachedstart:latest -f docker/Dockerfile .
   ```

4. **Memory issues during build**
   - Increase Docker Desktop memory limit (8GB+ recommended)
   - Close other applications during build

## 📊 Build Progress Monitoring

The build process includes these major steps:

1. **Base Image Setup** (2-3 minutes)
   - NVIDIA CUDA 12.4.1 Ubuntu 22.04
   - System dependencies installation

2. **Conda Environment** (5-8 minutes)
   - Miniconda installation
   - Python 3.10 environment setup
   - CUDA toolkit installation

3. **Repository Clone** (1-2 minutes)
   - Clone CachedStart repository
   - Install Python dependencies

4. **Custom Compilation** (5-10 minutes)
   - Custom rasterizer compilation
   - DifferentiableRenderer setup

5. **Model Downloads** (2-5 minutes)
   - RealESRGAN model download
   - Path configuration updates

## 🎯 Verification

After successful build, verify the image:

```bash
# Check image size and details
docker images kechiro/hunyuan3d-2.1-cachedstart

# Test the container
docker run --rm kechiro/hunyuan3d-2.1-cachedstart:latest python3 -c "import torch; print(f'PyTorch: {torch.__version__}'); print(f'CUDA available: {torch.cuda.is_available()}')"
```

## 📝 Next Steps

1. **Start the WebUI**: Access http://localhost:8080
2. **Upload sample images**: Use optimized gallery (108 examples)
3. **Generate 3D models**: Test shape generation
4. **Try texture synthesis**: Test PBR texture generation

For more details, see [DOCKER_OVERVIEW.md](DOCKER_OVERVIEW.md).
