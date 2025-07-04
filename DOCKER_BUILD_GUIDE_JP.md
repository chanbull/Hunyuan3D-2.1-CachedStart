# 🐳 Hunyuan3D-2.1 CachedStart Docker ビルドガイド

## 📋 前提条件

### 1. Docker のインストール
- **Windows/Mac**: [Docker Desktop](https://docs.docker.com/get-docker/)
- **Linux**: [Docker Engine](https://docs.docker.com/engine/install/)

### 2. NVIDIA Docker サポート（GPU アクセラレーション用）
```bash
# NVIDIA Container Toolkit をインストール（Linux）
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

## 🚀 ビルド手順

### オプション1: ビルドスクリプトを使用（推奨）

```bash
# リポジトリをクローン
git clone https://github.com/kechirojp/Hunyuan3D-2.1-CachedStart.git
cd Hunyuan3D-2.1-CachedStart

# デフォルトタグ（latest）でビルド
./docker-build-commands.sh

# カスタムタグでビルド
./docker-build-commands.sh v2.1
```

### オプション2: 手動ビルド

```bash
# Docker イメージを手動でビルド
docker build --no-cache -t kechiro/hunyuan3d-2.1-cachedstart:latest -f docker/Dockerfile .

# カスタムタグでビルド
docker build --no-cache -t kechiro/hunyuan3d-2.1-cachedstart:v2.1 -f docker/Dockerfile .
```

## 🔧 コンテナの実行

### WebUI（Gradio アプリ）
```bash
# モデルキャッシュディレクトリを作成
mkdir -p ./model_cache

# ポート8080でWebUIを実行
docker run --gpus all -p 8080:8080 -v ./model_cache:/workspace/model_cache kechiro/hunyuan3d-2.1-cachedstart:latest python3 gradio_app.py
```

### API サーバー
```bash
# ポート8081でAPIサーバーを実行
docker run --gpus all -p 8081:8081 -v ./model_cache:/workspace/model_cache kechiro/hunyuan3d-2.1-cachedstart:latest python3 api_server.py
```

### Docker Compose（推奨）
```bash
# docker-compose を使用した簡単な管理
docker-compose up -d

# サービス停止
docker-compose down
```

### インタラクティブシェル
```bash
# デバッグ用のインタラクティブシェルを開始
docker run --gpus all -it -v ./model_cache:/workspace/model_cache kechiro/hunyuan3d-2.1-cachedstart:latest /bin/bash
```

## 💾 永続的なモデルキャッシュ

CachedStart フォークの主要機能は永続的なモデルキャッシュです：

```bash
# model_cache ディレクトリ構造
model_cache/
├── huggingface/          # HuggingFace モデルキャッシュ（約10GB以上）
│   ├── models--tencent--Hunyuan3D-2/    # メイン3D生成モデル
│   ├── models--microsoft--DiT-XL-2-256/ # 拡散トランスフォーマー
│   └── modules/          # 共有HuggingFaceモジュール
├── hy3dgen/              # Hunyuan3D専用モデル
└── .u2net/               # 背景除去モデル
```

**メリット:**
- ✅ **初回実行**: 全モデルをダウンロード（約15-20分）
- ✅ **次回以降**: ほぼ瞬時に起動（30-60秒）
- ✅ **コンテナ再起動**: 再ダウンロード不要
- ✅ **複数コンテナ**: インスタンス間でキャッシュ共有

## 🔍 ビルドログとトラブルシューティング

### 予想ビルド時間
- **初回ビルド**: 20-35分（インターネット速度による）
- **CUDA コンパイル**: カスタムラスタライザーで8-15分
- **総イメージサイズ**: 約12-15 GB

### よくある問題

1. **ディスク容量不足**
   ```bash
   # Docker システムをクリーンアップ
   docker system prune -a
   ```

2. **CUDA コンパイルエラー**
   - NVIDIA ドライバーがインストールされていることを確認
   - GPU との CUDA 互換性を確認

3. **ネットワークタイムアウト**
   ```bash
   # 必要に応じてプロキシのビルド引数を使用
   docker build --build-arg HTTP_PROXY=http://proxy:port --build-arg HTTPS_PROXY=http://proxy:port -t kechiro/hunyuan3d-2.1-cachedstart:latest -f docker/Dockerfile .
   ```

4. **ビルド中のメモリ問題**
   - Docker Desktop のメモリ制限を増加（16GB以上推奨）
   - ビルド中は他のアプリケーションを終了
   - 必要に応じて `--memory=16g` フラグを使用

5. **PyTorch/CUDA バージョン競合**
   ```bash
   # コンテナ内でCUDAバージョンを確認
   docker run --rm --gpus all kechiro/hunyuan3d-2.1-cachedstart:latest nvidia-smi
   ```

## 📊 ビルド進行状況の監視

ビルドプロセスには以下の主要ステップが含まれます：

1. **ベースイメージセットアップ**（2-3分）
   - NVIDIA CUDA 12.4.1 Ubuntu 22.04
   - システム依存関係のインストール

2. **Conda 環境**（8-12分）
   - Miniconda インストール
   - Python 3.10 環境セットアップ
   - CUDA ツールキットと PyTorch インストール

3. **リポジトリクローンと依存関係**（3-5分）
   - CachedStart リポジトリをクローン
   - requirements.txt から Python 依存関係をインストール

4. **カスタムコンパイル**（8-15分）
   - カスタムラスタライザーのコンパイル
   - DifferentiableRenderer セットアップ
   - CUDA カーネルコンパイル

5. **モデルダウンロードと設定**（2-5分）
   - RealESRGAN モデルダウンロード
   - パス設定の更新
   - キャッシュディレクトリセットアップ

## 🎯 検証

ビルド成功後、イメージを検証：

```bash
# イメージサイズと詳細を確認
docker images kechiro/hunyuan3d-2.1-cachedstart

# PyTorch と CUDA をテスト
docker run --rm --gpus all kechiro/hunyuan3d-2.1-cachedstart:latest python3 -c "import torch; print(f'PyTorch: {torch.__version__}'); print(f'CUDA available: {torch.cuda.is_available()}'); print(f'CUDA devices: {torch.cuda.device_count()}')"

# カスタムラスタライザーをテスト
docker run --rm --gpus all kechiro/hunyuan3d-2.1-cachedstart:latest python3 -c "from hy3dpaint.custom_rasterizer import Custom_Rasterizer; print('Custom rasterizer loaded successfully')"
```

## 📝 次のステップ

1. **WebUI を開始**: http://localhost:8080 にアクセス
2. **サンプル画像をアップロード**: 最適化されたギャラリー（`assets/example_images/` の108例）を使用
3. **3D モデルを生成**: 様々なプロンプトで形状生成をテスト
4. **テクスチャ合成を試す**: マテリアル付きPBRテクスチャ生成をテスト
5. **API 統合**: http://localhost:8081/docs でREST APIを使用

詳細については以下を参照：
- [DOCKER_OVERVIEW.md](DOCKER_OVERVIEW.md) - 詳細なアーキテクチャ概要
- [README.md](README.md) - 使用方法と例
- [setup-instructions.md](setup-instructions.md) - 代替セットアップ方法
