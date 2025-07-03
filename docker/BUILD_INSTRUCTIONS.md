# Dockerイメージビルド手順

このドキュメントでは、Hunyuan3D-2.1-CachedStartのDockerイメージをビルドし、Docker Hubにプッシュする方法について説明します。

## 前提条件

- Windows 10/11
- Docker Desktop がインストールされていること
- PowerShellが利用可能であること
- GitHubリポジトリがクローンされていること

## Docker Desktopのインストール

まだDocker Desktopをインストールしていない場合は、以下の手順に従ってインストールしてください：

1. [Docker Desktop公式サイト](https://www.docker.com/products/docker-desktop/)からインストーラをダウンロード
2. ダウンロードしたインストーラを実行し、指示に従ってインストール
3. インストール完了後、Docker Desktopを起動
4. Docker Desktopが正常に起動し、ステータスが「Running」になっていることを確認

## リポジトリのクローン

まだリポジトリをクローンしていない場合は、以下のコマンドを実行してください：

```powershell
# 適切なディレクトリに移動（例：Iドライブのルート）
cd I:\

# リポジトリをクローン
git clone https://github.com/kechirojp/Hunyuan3D-2.1-CachedStart.git Hunyuan3D-2.1-main

# クローンしたディレクトリに移動
cd Hunyuan3D-2.1-main
```

## PowerShellでのDockerイメージのビルド

以下の手順でDockerイメージをビルドします：

1. PowerShellを管理者として起動
2. リポジトリのディレクトリに移動：

```powershell
cd I:\Hunyuan3D-2.1-main
```

3. Dockerイメージのビルドを実行：

```powershell
# 常にキャッシュなしでクリーンビルドを実行（推奨）
docker build --no-cache -t kechiro/hunyuan3d:2.1 -f docker/Dockerfile .
```

ビルドプロセスは、依存関係のダウンロードと構築に時間がかかる場合があります。完了するまでお待ちください。

## Docker Hubへのプッシュ

ビルドが完了したら、以下の手順でDocker Hubにイメージをプッシュします：

1. Docker Hubにログイン：

```powershell
docker login
```

プロンプトが表示されたら、kechiroアカウントのユーザー名とパスワードを入力してください。

2. イメージをプッシュ：

```powershell
# ビルドしたイメージをプッシュ
docker push kechiro/hunyuan3d:2.1
```

## 推奨コマンド実行方法

自動化スクリプトではなく、以下の直接コマンド実行が最も確実な方法です：

```powershell
# Dockerイメージをクリーンビルド
docker build --no-cache -t kechiro/hunyuan3d:2.1 -f docker/Dockerfile .

# Docker Hubにログイン
docker login

# イメージをプッシュ
docker push kechiro/hunyuan3d:2.1
```

## トラブルシューティング

### ビルド中のメモリ不足エラー

Dockerビルド中にメモリ不足エラーが発生した場合は、Docker Desktopの設定でリソース割り当てを増やしてください：

1. Docker Desktopを開く
2. 設定（Settings）を選択
3. リソース（Resources）セクションに移動
4. メモリ割り当てを増やす（最低8GB推奨、可能であれば16GB以上）
5. 変更を適用して再試行

### ネットワーク接続の問題

ビルド中にネットワーク関連のエラーが発生した場合は、以下を確認してください：

1. インターネット接続が安定していること
2. VPNを使用している場合は、一時的に無効にしてみる
3. Docker Desktopを再起動

### PowerShellスクリプト実行エラー

スクリプトが見つからない、または実行できないというエラーが表示される場合：

1. スクリプトが正しい場所に存在することを確認：
   ```powershell
   Test-Path .\docker\build_with_powershell.ps1
   ```

2. PowerShellの実行ポリシーを確認し、必要に応じて変更：
   ```powershell
   # 現在の実行ポリシーを確認
   Get-ExecutionPolicy

   # 推奨: RemoteSignedポリシーを設定（管理者権限が必要）
   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

   # または一時的に現在のセッションの実行ポリシーを変更
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```

3. スクリプトを直接指定して実行：
   ```powershell
   & ".\docker\build_with_powershell.ps1"
   ```

> **注記**: `RemoteSigned`実行ポリシーは、ローカルで作成したスクリプトは無署名で実行できますが、
> インターネットからダウンロードされたスクリプトは信頼できる発行元による署名が必要になります。
> 開発環境としては最も一般的に推奨される設定です。

### キャッシュの問題

ビルドが予想よりも早く終了し、期待通りの結果が得られない場合：

1. `--no-cache`オプションを使用して完全に新しいビルドを行う：
   ```powershell
   docker build --no-cache -t kechiro/hunyuan3d:2.1-fresh -f docker/Dockerfile .
   ```

2. 異なるタグ名を使用してビルドする：
   ```powershell
   docker build -t kechiro/hunyuan3d:2.1-new -f docker/Dockerfile .
   ```

3. Dockerのビルドキャッシュをクリア：
   ```powershell
   docker builder prune -a
   ```

## 追加情報

- イメージ名: `kechiro/hunyuan3d:2.1`
- ベースイメージ: `nvidia/cuda:12.4.1-devel-ubuntu22.04`
- 公開リポジトリ: https://github.com/kechirojp/Hunyuan3D-2.1-CachedStart
