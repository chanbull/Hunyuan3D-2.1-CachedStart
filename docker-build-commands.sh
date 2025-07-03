#!/bin/bash

# 🐳 Hunyuan3D-2.1 CachedStart Docker Build Script
# This script provides commands to build the Docker image for Hunyuan3D-2.1

# Default image tag
IMAGE_TAG="kechiro/hunyuan3d-2.1-cachedstart:latest"

# Check for custom tag argument
if [ ! -z "$1" ]; then
    IMAGE_TAG="kechiro/hunyuan3d-2.1-cachedstart:$1"
fi

echo "🚀 Building Hunyuan3D-2.1 CachedStart Docker Image..."
echo "================================================="

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed or not in PATH"
    echo "Please install Docker first: https://docs.docker.com/get-docker/"
    exit 1
fi

# Create model_cache directory if it doesn't exist
mkdir -p ./model_cache

echo "📦 Building Docker image..."
echo "Image tag: $IMAGE_TAG"
echo "Build context: Current directory"
echo "Dockerfile: docker/Dockerfile"
echo ""

# Build the Docker image
docker build \
    --no-cache \
    -t "$IMAGE_TAG" \
    -f docker/Dockerfile \
    .

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Docker image built successfully!"
    echo ""
    echo "🔧 Usage Examples:"
    echo "=================="
    echo ""
    echo "# Run WebUI (port 8080):"
    echo "docker run --gpus all -p 8080:8080 -v ./model_cache:/workspace/model_cache $IMAGE_TAG python3 gradio_app.py"
    echo ""
    echo "# Run API Server (port 8081):"
    echo "docker run --gpus all -p 8081:8081 -v ./model_cache:/workspace/model_cache $IMAGE_TAG python3 api_server.py"
    echo ""
    echo "# Interactive shell:"
    echo "docker run --gpus all -it -v ./model_cache:/workspace/model_cache $IMAGE_TAG /bin/bash"
    echo ""
    echo "💡 Note: Models will be cached in ./model_cache for faster subsequent starts"
    echo ""
    echo "📝 To build with custom tag: ./docker-build-commands.sh v2.1"
else
    echo ""
    echo "❌ Docker build failed!"
    echo "Check the error messages above for troubleshooting."
    exit 1
fi
