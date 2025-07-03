#!/bin/bash

# Hunyuan3D-2.1 Application Startup Script
echo "Starting Hunyuan3D-2.1..."

# Ensure model cache directories exist
mkdir -p /workspace/Hunyuan3D-2.1/model_cache/hy3dgen
mkdir -p /workspace/Hunyuan3D-2.1/model_cache/huggingface
mkdir -p /workspace/Hunyuan3D-2.1/model_cache/.u2net

# Set environment variables for persistent model cache
export HY3DGEN_MODELS="/workspace/Hunyuan3D-2.1/model_cache/hy3dgen"
export HF_HOME="/workspace/Hunyuan3D-2.1/model_cache/huggingface"
export TRANSFORMERS_CACHE="/workspace/Hunyuan3D-2.1/model_cache/huggingface"
export HF_HUB_CACHE="/workspace/Hunyuan3D-2.1/model_cache/huggingface/hub"
export HF_MODULES_CACHE="/workspace/Hunyuan3D-2.1/model_cache/huggingface/modules"

# Copy models from system cache to persistent cache if available
if [ -d "/root/.cache/hy3dgen" ] && [ ! -d "/workspace/Hunyuan3D-2.1/model_cache/hy3dgen/tencent" ]; then
    echo "Copying Hunyuan3D models to persistent cache..."
    cp -r /root/.cache/hy3dgen/* /workspace/Hunyuan3D-2.1/model_cache/hy3dgen/
fi

if [ -d "/root/.cache/huggingface" ] && [ ! -d "/workspace/Hunyuan3D-2.1/model_cache/huggingface/hub" ]; then
    echo "Copying Huggingface models to persistent cache..."
    cp -r /root/.cache/huggingface/* /workspace/Hunyuan3D-2.1/model_cache/huggingface/
fi

if [ -d "/root/.u2net" ] && [ ! -d "/workspace/Hunyuan3D-2.1/model_cache/.u2net" ]; then
    echo "Copying U2Net models to persistent cache..."
    cp -r /root/.u2net/* /workspace/Hunyuan3D-2.1/model_cache/.u2net/
fi

# Create symlinks from system cache to persistent cache for compatibility
mkdir -p /root/.cache

if [ ! -L "/root/.cache/hy3dgen" ]; then
    rm -rf /root/.cache/hy3dgen
    ln -s /workspace/Hunyuan3D-2.1/model_cache/hy3dgen /root/.cache/hy3dgen
    echo "Created symlink: /root/.cache/hy3dgen -> /workspace/Hunyuan3D-2.1/model_cache/hy3dgen"
fi

if [ ! -L "/root/.cache/huggingface" ]; then
    rm -rf /root/.cache/huggingface
    ln -s /workspace/Hunyuan3D-2.1/model_cache/huggingface /root/.cache/huggingface
    echo "Created symlink: /root/.cache/huggingface -> /workspace/Hunyuan3D-2.1/model_cache/huggingface"
fi

if [ ! -L "/root/.u2net" ]; then
    rm -rf /root/.u2net
    ln -s /workspace/Hunyuan3D-2.1/model_cache/.u2net /root/.u2net
    echo "Created symlink: /root/.u2net -> /workspace/Hunyuan3D-2.1/model_cache/.u2net"
fi

echo "Model cache directories:"
echo "  HY3DGEN_MODELS: $HY3DGEN_MODELS"
echo "  HF_HOME: $HF_HOME"
echo "Starting Gradio application..."

# Run the application with environment variables explicitly set
HY3DGEN_MODELS="$HY3DGEN_MODELS" \
HF_HOME="$HF_HOME" \
TRANSFORMERS_CACHE="$TRANSFORMERS_CACHE" \
HF_HUB_CACHE="$HF_HUB_CACHE" \
HF_MODULES_CACHE="$HF_MODULES_CACHE" \
python gradio_app.py "$@"
