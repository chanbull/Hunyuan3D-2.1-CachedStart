#!/bin/bash
# Start API script for Hunyuan3D-2.1
# This script starts the API server with model cache persistence

# Default settings
MODEL_PATH="tencent/Hunyuan3D-2.1"
SUBFOLDER="hunyuan3d-dit-v2-1"
MODEL_CACHE_DIR="./model_cache"
SAVE_DIR="./save_dir"
PORT=8081
HOST="0.0.0.0"
DEVICE="cuda"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --model_path)
      MODEL_PATH="$2"
      shift 2
      ;;
    --subfolder)
      SUBFOLDER="$2"
      shift 2
      ;;
    --model_cache_dir)
      MODEL_CACHE_DIR="$2"
      shift 2
      ;;
    --save_dir)
      SAVE_DIR="$2"
      shift 2
      ;;
    --port)
      PORT="$2"
      shift 2
      ;;
    --host)
      HOST="$2"
      shift 2
      ;;
    --device)
      DEVICE="$2"
      shift 2
      ;;
    --low_vram_mode)
      LOW_VRAM_MODE="--low_vram_mode"
      shift
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

# Check if the desired port is available; if not, find a free one
function find_free_port() {
  local base_port="$1"
  local port=$base_port
  while :; do
    if ! lsof -iTCP -sTCP:LISTEN -Pn | grep -q ":$port "; then
      echo $port
      return
    fi
    port=$((port+1))
    if [ $port -gt 65535 ]; then
      echo "No free port found." >&2
      exit 1
    fi
  done
}

PORT=$(find_free_port "$PORT")

# Ensure model cache directories exist
mkdir -p "$MODEL_CACHE_DIR/hy3dgen"
mkdir -p "$MODEL_CACHE_DIR/huggingface"
mkdir -p "$MODEL_CACHE_DIR/.u2net"
mkdir -p "$SAVE_DIR"

# Set environment variables for model caching
export HY3DGEN_MODELS="${MODEL_CACHE_DIR}/hy3dgen"
export HF_HOME="${MODEL_CACHE_DIR}/huggingface"
export TRANSFORMERS_CACHE="${MODEL_CACHE_DIR}/huggingface"
export HF_HUB_CACHE="${MODEL_CACHE_DIR}/huggingface/hub"
export HF_MODULES_CACHE="/tmp/hf_modules_cache"
export PYTORCH_TRANSFORMERS_CACHE="${MODEL_CACHE_DIR}/huggingface/pytorch_transformers"
export HF_DATASETS_CACHE="${MODEL_CACHE_DIR}/huggingface/datasets"
export U2NET_HOME="${MODEL_CACHE_DIR}/.u2net"

# Copy models from system cache to persistent cache if available
if [ -d "/root/.cache/hy3dgen" ] && [ ! -d "${MODEL_CACHE_DIR}/hy3dgen/tencent" ]; then
    echo "Copying Hunyuan3D models to persistent cache..."
    cp -r /root/.cache/hy3dgen/* "${MODEL_CACHE_DIR}/hy3dgen/"
fi

if [ -d "/root/.cache/huggingface" ] && [ ! -d "${MODEL_CACHE_DIR}/huggingface/hub" ]; then
    echo "Copying Huggingface models to persistent cache..."
    cp -r /root/.cache/huggingface/* "${MODEL_CACHE_DIR}/huggingface/"
fi

if [ -d "/root/.u2net" ] && [ ! -d "${MODEL_CACHE_DIR}/.u2net" ]; then
    echo "Copying U2Net models to persistent cache..."
    cp -r /root/.u2net/* "${MODEL_CACHE_DIR}/.u2net/"
fi

# Create symlinks from system cache to persistent cache for compatibility
mkdir -p /root/.cache

if [ ! -L "/root/.cache/hy3dgen" ]; then
    rm -rf /root/.cache/hy3dgen
    ln -s "${MODEL_CACHE_DIR}/hy3dgen" /root/.cache/hy3dgen
    echo "Created symlink: /root/.cache/hy3dgen -> ${MODEL_CACHE_DIR}/hy3dgen"
fi

if [ ! -L "/root/.cache/huggingface" ]; then
    rm -rf /root/.cache/huggingface
    ln -s "${MODEL_CACHE_DIR}/huggingface" /root/.cache/huggingface
    echo "Created symlink: /root/.cache/huggingface -> ${MODEL_CACHE_DIR}/huggingface"
fi

if [ ! -L "/root/.u2net" ]; then
    rm -rf /root/.u2net
    ln -s "${MODEL_CACHE_DIR}/.u2net" /root/.u2net
    echo "Created symlink: /root/.u2net -> ${MODEL_CACHE_DIR}/.u2net"
fi

# Print startup information
echo "Starting Hunyuan3D-2.1 API Server"
echo "------------------------------------"
echo "Model path: $MODEL_PATH"
echo "Subfolder: $SUBFOLDER"
echo "Model cache directory: $MODEL_CACHE_DIR"
echo "Save directory: $SAVE_DIR"
echo "Host: $HOST"
echo "Port: $PORT"
echo "Device: $DEVICE"
if [ -n "$LOW_VRAM_MODE" ]; then
  echo "Low VRAM mode: Enabled"
fi
echo "Model cache directories:"
echo "  HY3DGEN_MODELS: $HY3DGEN_MODELS"
echo "  HF_HOME: $HF_HOME"
echo "------------------------------------"

# Start the API server with environment variables explicitly set
HY3DGEN_MODELS="$HY3DGEN_MODELS" \
HF_HOME="$HF_HOME" \
TRANSFORMERS_CACHE="$TRANSFORMERS_CACHE" \
HF_HUB_CACHE="$HF_HUB_CACHE" \
HF_MODULES_CACHE="$HF_MODULES_CACHE" \
U2NET_HOME="$U2NET_HOME" \
python api_server.py \
  --model_path "$MODEL_PATH" \
  --subfolder "$SUBFOLDER" \
  --cache-path "$SAVE_DIR" \
  --port "$PORT" \
  --host "$HOST" \
  --device "$DEVICE" \
  $LOW_VRAM_MODE
