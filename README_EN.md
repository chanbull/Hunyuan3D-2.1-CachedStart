# Hunyuan3D-2.1 🎮🚀

**English** | [日本語](README_JP.md) | [Official Specs](README.md)

> **⚡ About This Enhanced Fork**  
> This is an **enhanced fork** of the original [Tencent-Hunyuan/Hunyuan3D-2.1](https://github.com/Tencent-Hunyuan/Hunyuan3D-2.1) repository with **persistent model caching** capabilities.
> 
> **Key Improvements:**
> - 🔄 **Persistent Model Cache**: Avoids 18GB re-downloads on subsequent startups
> - ⚡ **Faster Startup**: Cached models reduce initialization time (~1 minute vs 10+ minutes without cache)
> - 💾 **Docker-Ready**: Cache persists across container restarts
> - 🛠️ **Production Ready**: Enhanced scripts for reliable deployment

> **📖 About This Document**  
> Quick start guide optimized for game developers.  
> For official technical specifications, see [README.md](README.md).

## 🌟 Overview

Hunyuan3D-2.1 is an AI system that generates high-quality 3D models from 2D images. It's a production-ready toolchain optimized for game developers.

### ✨ Key Features
- 🖼️ **Image-to-3D**: Generate 3D meshes + textures from 2D images
- ⚡ **Faster Startup**: Persistent cache prevents 18GB re-downloads (initialization ~1 minute)
- 🔗 **REST API**: Professional API for programmatic integration
- 🎮 **Game Integration**: Direct Unity/Unreal Engine support
- 🐳 **Docker Ready**: Fully containerized environment

## 🚀 Quick Start

### WebUI (Recommended)
```bash
./start_app.sh
# → http://localhost:8080
```

### Advanced: Custom WebUI Port
```bash
# Default: Uses port 8080. If busy, an available port will be selected automatically.
python3 gradio_app.py \
  --model_path tencent/Hunyuan3D-2.1 \
  --subfolder hunyuan3d-dit-v2-1 \
  --texgen_model_path tencent/Hunyuan3D-2.1 \
  --low_vram_mode

# To specify a custom port:
python3 gradio_app.py \
  --model_path tencent/Hunyuan3D-2.1 \
  --subfolder hunyuan3d-dit-v2-1 \
  --texgen_model_path tencent/Hunyuan3D-2.1 \
  --low_vram_mode \
  --port 8888
```

### Advanced: Custom REST API Port
```bash
# Default: Uses port 8081. If busy, an available port will be selected automatically.
python3 api_server.py \
  --model_path tencent/Hunyuan3D-2.1 \
  --subfolder hunyuan3d-dit-v2-1 \
  --cache-path ./save_dir \
  --port 8081 \
  --host 0.0.0.0 \
  --device cuda

# To specify a custom port:
python3 api_server.py \
  --model_path tencent/Hunyuan3D-2.1 \
  --subfolder hunyuan3d-dit-v2-1 \
  --cache-path ./save_dir \
  --port 9000 \
  --host 0.0.0.0 \
  --device cuda
```

### REST API (Developers)
```bash
./start_api.sh
# → http://localhost:8081/docs
```

## 📚 Documentation

### 🎯 Use Case Guides
- **[Distribution](docs/ja/distribution.md)** - License-compliant sharing

### 🔧 Technical Documentation
- **[Docker Setup](docs/en/docker-setup.md)** - Container build and deployment
- **[Model Cache](MODEL_CACHE_README.md)** - 18GB acceleration system
- **[Original Documentation](README.md)** - Official technical specifications

## ⚖️ License

TENCENT HUNYUAN NON-COMMERCIAL LICENSE AGREEMENT

- ✅ Personal, research, educational use OK
- ✅ Non-commercial game development OK
- ⚠️ Commercial use (>1M MAU) requires separate license
- ❌ Not available in EU, UK, South Korea

Details: [DISTRIBUTION_NOTICE.txt](DISTRIBUTION_NOTICE.txt)

## 🤝 Support

- 📖 [Documentation](docs/en/)
- 🐛 [Issues](https://github.com/Tencent-Hunyuan/Hunyuan3D-2.1/issues)
- 💬 [Discussions](https://github.com/Tencent-Hunyuan/Hunyuan3D-2.1/discussions)

## 📁 Fork Information

**Original Repository**: [https://github.com/Tencent-Hunyuan/Hunyuan3D-2.1](https://github.com/Tencent-Hunyuan/Hunyuan3D-2.1)  
**License**: Same as original (TENCENT HUNYUAN NON-COMMERCIAL LICENSE AGREEMENT)

---

**Made with ❤️ for Game Developers**
