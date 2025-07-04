# 🐳 Hunyuan3D-2.1 CachedStart Docker 概要

## Docker 統合

このリポジトリは、Hunyuan3D-2.1をDockerコンテナで簡単に実行するための包括的なDockerサポートを提供します。**"CachedStart"** フォークは、永続的なキャッシュメカニズムを通じてスタートアップ体験を最適化し、初回実行後の初期化時間を大幅に短縮することに重点を置いています。

## ✨ 主要機能

- **永続的なモデルキャッシュ** - モデルがホストシステムに保存され、コンテナ再起動時も持続
- **高速な2回目以降の起動** - 初回ダウンロード後、最大10倍高速な起動時間
- **GPU アクセラレーション** - CUDA 12.4サポートによる最適化されたパフォーマンス
- **クロスプラットフォーム対応** - WindowsとLinux環境の両方で動作

## 🚀 クイックスタート

### オプション1: Docker Hubからの事前ビルドイメージ（推奨）
```bash
# Docker Hubから事前ビルドイメージをプル
docker pull kechiro/hunyuan3d-2.1-cachedstart:latest

# GUI付きで実行（高速化のための永続キャッシュ付き）
docker run --gpus all -p 8080:8080 -v ./model_cache:/workspace/model_cache kechiro/hunyuan3d-2.1-cachedstart:latest python3 gradio_app.py

# APIサーバーを実行（同じ永続キャッシュを使用）
docker run --gpus all -p 8081:8081 -v ./model_cache:/workspace/model_cache kechiro/hunyuan3d-2.1-cachedstart:latest python3 api_server.py
```

### オプション2: ソースからビルド
```bash
# イメージをローカルでビルド
./docker-build-commands.sh

# または手動でビルド
docker build --no-cache -t kechiro/hunyuan3d-2.1-cachedstart:latest -f docker/Dockerfile .
```

### オプション3: Docker Compose（本番環境）
```bash
# docker-composeを使用した簡単な管理
docker-compose up -d

# サービス停止
docker-compose down
```

## 📦 Docker イメージ構成

Dockerイメージには以下のコンポーネントが含まれています：

- **ベース環境**: Ubuntu 22.04上のNVIDIA CUDA 12.4.1
- **Python環境**: Python 3.10 + PyTorch 2.5.1（CUDA 12.4サポート付き）
- **依存関係**: `requirements.txt`からのすべての要件がプリインストール
- **モデルキャッシュ**: 最適化されたパスを持つ事前設定されたキャッシュディレクトリ
- **カスタムラスタライザー**: 最適な3Dレンダリングパフォーマンス用にプリコンパイル
- **サンプルギャラリー**: `assets/example_images/`の108の高品質サンプル画像
- **自動ダウンロード**: 初回実行時にRealESRGANモデルを自動ダウンロード
- **本番対応**: 強化されたエラーハンドリングとタイムアウトメカニズム

**イメージサイズ**: 約12-15 GB（すべての依存関係と最適化を含む）

## 💾 永続的なモデルキャッシュ - CachedStartの利点

**このCachedStartフォークの核心機能**は、後続実行での起動時間を劇的に短縮する永続的なモデルキャッシュシステムです。Dockerイメージは`model_cache`ディレクトリをホストシステムにマウントし、冗長なダウンロードを防止します：

```
model_cache/
├── huggingface/          # HuggingFaceモデルキャッシュ（約10GB以上）
│   ├── models--tencent--Hunyuan3D-2/    # メイン3D生成モデル
│   ├── models--microsoft--DiT-XL-2-256/ # 拡散トランスフォーマー
│   └── modules/          # 共有HuggingFaceモジュール
├── hy3dgen/              # Hunyuan3D専用モデル
└── .u2net/               # 背景除去モデル
```

### 永続キャッシュのメリット

- **初回実行**: 必要なすべてのモデルをダウンロード（約15-20GB総計）
- **次回以降の実行**: ほぼ瞬時の起動（30-60秒 vs 10分以上）
- **コンテナ再起動**: 再ダウンロード不要
- **ディスク容量効率**: ホスト上でモデルを一度だけ保存
- **マルチコンテナサポート**: 複数のインスタンス間でキャッシュを共有
- **開発フレンドリー**: キャッシュされたモデルでの高速反復サイクル

この永続キャッシュメカニズムが「CachedStart」フォークを本番環境と開発環境で特に価値あるものにしています。

## 🛠️ ビルド手順

詳細なビルド手順については以下を参照：
- [DOCKER_BUILD_GUIDE.md](DOCKER_BUILD_GUIDE.md) - 包括的なビルドガイド
- [DOCKER_BUILD_GUIDE_JP.md](DOCKER_BUILD_GUIDE_JP.md) - 日本語版
- [docker/BUILD_INSTRUCTIONS.md](docker/BUILD_INSTRUCTIONS.md) - レガシー文書

## 🔍 トラブルシューティング

ビルドまたは実行時の一般的な問題：

1. **GPUが認識されない**
   ```bash
   # NVIDIAドライバーとDocker GPU設定を確認
   docker run --rm --gpus all nvidia/cuda:12.4.1-base-ubuntu22.04 nvidia-smi
   ```

2. **メモリ不足エラー**
   - Docker Desktopのリソース割り当てを増加（16GB以上推奨）
   - アプリケーションで`--low_vram_mode`フラグを使用

3. **長いビルド時間**
   - Docker Hubから事前ビルドイメージを使用：`docker pull kechiro/hunyuan3d-2.1-cachedstart:latest`
   - インターネット接続を確認し、ビルドキャッシュの使用を検討

4. **キャッシュが持続しない**
   - 絶対パスでの適切なボリュームマウントを確認
   - `./model_cache`ディレクトリの権限を確認

5. **アプリケーションタイムアウト**
   - テクスチャ生成パラメータを削減（`max_num_view`、`resolution`）
   - `nvidia-smi`でGPUメモリ使用量を監視

詳細なトラブルシューティングについては、[docker/README.md](docker/README.md)を参照してください。

## 📄 環境変数

Dockerコンテナで利用可能な主要な環境変数：

| 変数名 | 説明 | デフォルト |
|--------|------|----------|
| `HF_HOME` | HuggingFaceキャッシュの場所 | `/workspace/model_cache/huggingface` |
| `HF_MODULES_CACHE` | HuggingFaceモジュールキャッシュ | `/workspace/model_cache/huggingface/modules` |
| `CACHE_ENABLED` | 永続キャッシュを有効化 | `true` |

## 📋 サポートされているタグとイメージ

**Docker Hubリポジトリ**: [kechiro/hunyuan3d-2.1-cachedstart](https://hub.docker.com/r/kechiro/hunyuan3d-2.1-cachedstart)

| タグ | 説明 | サイズ | ビルド日 |
|------|------|--------|----------|
| `latest` | 最新安定版CachedStartリリース | 約12-15GB | 常に最新 |
| `v2.1` | Hunyuan3D-2.1用のバージョンタグリリース | 約12-15GB | 安定版 |

**プルコマンド:**
```bash
# 最新版（推奨）
docker pull kechiro/hunyuan3d-2.1-cachedstart:latest

# 特定バージョン
docker pull kechiro/hunyuan3d-2.1-cachedstart:v2.1
```

## ⚡ パフォーマンス比較

| シナリオ | オリジナルリポジトリ | CachedStartフォーク |
|----------|---------------------|---------------------|
| 初回起動 | 10-15分 | 15-20分 |
| 次回以降の起動 | 10-15分 | 30-60秒 |
| コンテナ再起動 | 完全再ダウンロード | 瞬時のキャッシュ再利用 |
| モデルダウンロードサイズ | 毎回約18GB | 一度だけ約18GB |
| 開発ワークフロー | 遅い反復 | 高速反復 |

## 👥 貢献

Docker設定、ビルド手順、またはキャッシュメカニズムの改善に対する貢献を歓迎します。CachedStartフォークは特に以下を通じてユーザー体験の向上を目指しています：

- **最適化されたキャッシュメカニズム** による高速な起動時間
- **改良されたビルドプロセス** とより良いエラーハンドリング
- **強化されたドキュメント** による簡単な展開
- **本番対応の設定** による安定した動作

**貢献分野:**
- Dockerイメージの最適化とサイズ削減
- マルチアーキテクチャサポート（ARM64、AMD64）
- 代替デプロイメント方法（Kubernetesなど）
- パフォーマンスベンチマークと最適化
- ドキュメントの改善と翻訳

貢献ガイドラインについては、メインリポジトリの[CONTRIBUTING.md](CONTRIBUTING.md)を参照してください。
