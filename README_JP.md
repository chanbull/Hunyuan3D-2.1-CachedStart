# Hunyuan3D-2.1 🎮🚀

[English](README_EN.md) | **日本語** | [公式仕様書](README.md)

> **⚡ 改良版フォークについて**  
> これは元の [Tencent-Hunyuan/Hunyuan3D-2.1](https://github.com/Tencent-Hunyuan/Hunyuan3D-2.1) の**永続モデルキャッシュ機能付き改良版**です。
> 
> **主な改良点:**
> - 🔄 **永続モデルキャッシュ**: 18GB再ダウンロード回避
> - ⚡ **高速再起動**: 2回目以降は数秒で起動
> - 💾 **Docker対応**: コンテナ再起動でもキャッシュ保持
> - 🛠️ **本格運用対応**: エラーハンドリング・ログ機能強化

> **📖 このドキュメントについて**  
> 日本のゲーム開発者向けに最適化されたクイックスタートガイドです。  
> 公式技術仕様は [README.md](README.md) を参照してください。

## 🌟 概要

Hunyuan3D-2.1は、2D画像から高品質な3Dモデルを生成するAIシステムです。ゲーム開発者向けに最適化されたプロダクションレディなツールチェーンです。

### ✨ 主要機能
- 🖼️ **画像から3D**: 2D画像から3Dメッシュ + テクスチャ生成
- ⚡ **高速起動**: 永続キャッシュで18GB再ダウンロード回避
- 🔗 **REST API**: プログラム連携可能なプロフェッショナルAPI
- 🎮 **ゲーム統合**: Unity/Unreal Engine直接対応
- 🐳 **Docker対応**: 完全パッケージ化された環境

## 🚀 クイックスタート

### WebUI（推奨）
```bash
./start_app.sh
# → http://localhost:8080
```

### 発展: WebUIのポート指定
```bash
# デフォルト: 8080ポート。競合時は自動で空きポートを使用します。
python3 gradio_app.py \
  --model_path tencent/Hunyuan3D-2.1 \
  --subfolder hunyuan3d-dit-v2-1 \
  --texgen_model_path tencent/Hunyuan3D-2.1 \
  --low_vram_mode

# 任意のポートを指定したい場合:
python3 gradio_app.py \
  --model_path tencent/Hunyuan3D-2.1 \
  --subfolder hunyuan3d-dit-v2-1 \
  --texgen_model_path tencent/Hunyuan3D-2.1 \
  --low_vram_mode \
  --port 8888
```

### 発展: REST APIのポート指定
```bash
# デフォルト: 8081ポート。競合時は自動で空きポートを使用します。
python3 api_server.py \
  --model_path tencent/Hunyuan3D-2.1 \
  --subfolder hunyuan3d-dit-v2-1 \
  --cache-path ./save_dir \
  --port 8081 \
  --host 0.0.0.0 \
  --device cuda

# 任意のポートを指定したい場合:
python3 api_server.py \
  --model_path tencent/Hunyuan3D-2.1 \
  --subfolder hunyuan3d-dit-v2-1 \
  --cache-path ./save_dir \
  --port 9000 \
  --host 0.0.0.0 \
  --device cuda
```

### REST API（開発者向け）
```bash
./start_api.sh
# → http://localhost:8081/docs
```

## 📚 詳細ドキュメント

### 🎯 用途別ガイド
- **[ゲーム開発者向け](docs/ja/game-development.md)** - Unity/Unreal連携
- **[API開発者向け](docs/ja/api-reference.md)** - REST API仕様
- **[配布・共有](docs/ja/distribution.md)** - ライセンス準拠の共有方法

### 🔧 技術ドキュメント
- **[Docker環境](docs/ja/docker-setup.md)** - コンテナビルドとデプロイ
- **[モデルキャッシュ](MODEL_CACHE_README.md)** - 18GB高速化システム
- **[公式仕様書](README.md)** - オリジナル技術仕様（英語）

## ⚖️ ライセンス

TENCENT HUNYUAN NON-COMMERCIAL LICENSE AGREEMENT

- ✅ 個人・研究・学習利用OK
- ✅ 非商用ゲーム開発OK
- ⚠️ 商用利用（月間100万ユーザー超）は別途ライセンス必要
- ❌ EU・イギリス・韓国では利用不可

詳細: [DISTRIBUTION_NOTICE.txt](DISTRIBUTION_NOTICE.txt)

## 🤝 サポート

- 📖 [ドキュメント](docs/ja/)
- 🐛 [Issues](https://github.com/Tencent-Hunyuan/Hunyuan3D-2.1/issues)
- 💬 [Discussions](https://github.com/Tencent-Hunyuan/Hunyuan3D-2.1/discussions)

## 📁 フォーク情報

**元のリポジトリ**: [https://github.com/Tencent-Hunyuan/Hunyuan3D-2.1](https://github.com/Tencent-Hunyuan/Hunyuan3D-2.1)  
**ライセンス**: オリジナルと同じ（TENCENT HUNYUAN NON-COMMERCIAL LICENSE AGREEMENT）

---

**Made with ❤️ for Game Developers**
