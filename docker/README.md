# Docker ビルド手順

このディレクトリには、Hunyuan3D-2.1-CachedStartのDockerイメージをビルドするためのファイルが含まれています。

## ファイル構成

- `Dockerfile`: Dockerイメージのビルド定義
- `BUILD_INSTRUCTIONS.md`: 詳細なビルド手順の説明
- `README.md`: このファイル - 基本的なビルド手順

## PowerShellスクリプトの実行方法

PowerShellスクリプトを実行する際に問題が発生する場合は、以下の方法を試してください：

### 1. スクリプトファイルの作成

まず最初に、スクリプトファイルが存在するか確認します：
```powershell
# スクリプトファイルが存在するか確認
Test-Path .\docker\build_with_powershell.ps1
```

ファイルが存在しない場合（False が返される場合）は、以下の手順でスクリプトファイルを作成してください：

```powershell
# dockerディレクトリが存在することを確認（必要に応じて作成）
if (!(Test-Path .\docker)) {
    New-Item -Path .\docker -ItemType Directory
}

# スクリプトファイルを作成
@'
# PowerShellでDockerイメージをビルドするスクリプト

# 現在の作業ディレクトリを表示
Write-Host "Current directory: $(Get-Location)"

# リポジトリのルートディレクトリに移動
Set-Location -Path "I:\Hunyuan3D-2.1-main"

# 常にキャッシュなしでクリーンビルド
$tagName = "kechiro/hunyuan3d:2.1"
Write-Host "Building Docker image without cache as $tagName..."
docker build --no-cache -t $tagName -f docker/Dockerfile .

# ビルドが成功したかチェック
if ($LASTEXITCODE -eq 0) {
    Write-Host "Docker image built successfully!"
    
    # Docker Hubにログイン
    Write-Host "Logging in to Docker Hub..."
    docker login
    
    # イメージをプッシュ
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Pushing image to Docker Hub as $tagName..."
        docker push $tagName
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Image pushed successfully to Docker Hub!"
        } else {
            Write-Host "Failed to push image to Docker Hub."
        }
    } else {
        Write-Host "Docker Hub login failed."
    }
} else {
    Write-Host "Docker image build failed."
}
'@ | Out-File -FilePath .\docker\build_with_powershell.ps1 -Encoding utf8
```

### 2. 実行ポリシーの確認と変更

```powershell
# 現在の実行ポリシーを確認
Get-ExecutionPolicy

# 以下のいずれかのコマンドで実行ポリシーを変更（管理者権限が必要な場合があります）
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned  # 推奨: 現在のユーザーに対して
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass  # 現在のセッションのみ
```

### 3. スクリプトの実行

```powershell
# 方法1: 相対パス
.\docker\build_with_powershell.ps1

# 方法2: PowerShellの&演算子を使用
& ".\docker\build_with_powershell.ps1"

# 方法2-2: 絶対パスを使用
& "I:\Hunyuan3D-2.1-main\docker\build_with_powershell.ps1"

# 方法3: カレントディレクトリを変更してから実行
cd docker
.\build_with_powershell.ps1

# 方法4: スクリプトのコンテンツを直接コピーして新しいPowerShellウィンドウに貼り付ける
# スクリプトのコンテンツをメモ帳などで開いてコピーし、PowerShellウィンドウに貼り付けて実行
```

### 4. 手動でコマンドを実行（推奨方法）

PowerShellスクリプトの代わりに、以下の直接コマンド実行が最も確実な方法です：

```powershell
# Dockerイメージを常にクリーンビルド（キャッシュなし）
docker build --no-cache -t kechiro/hunyuan3d:2.1 -f docker/Dockerfile .

# Docker Hubにログイン
docker login

# イメージをプッシュ
docker push kechiro/hunyuan3d:2.1
```

## トラブルシューティング

### スクリプトファイルが見つからない場合

スクリプトファイルが見つからないエラーが発生する場合の解決策：

1. スクリプトファイルを正しい場所に作成する
   - 上記の「スクリプトファイルの作成」セクションのコードを使用

2. ファイルパスの問題を解決する
   - バックスラッシュではなくスラッシュを試す: `./docker/build_with_powershell.ps1`
   - ドライブレターの後にコロンがあることを確認: `I:\Hunyuan3D-2.1-main\docker\build_with_powershell.ps1`

3. ファイル拡張子の関連付けを確認する
   - PowerShellを管理者として実行
   - 以下のコマンドでPS1ファイルを実行: `powershell -File I:\Hunyuan3D-2.1-main\docker\build_with_powershell.ps1`

4. 直接Dockerコマンドを実行する
   - Dockerビルドコマンドを直接実行（手動でコマンドを実行セクション参照）

詳細なトラブルシューティングについては `BUILD_INSTRUCTIONS.md` も参照してください。