# PowerShellでDockerイメージをビルドするスクリプト

# 現在の作業ディレクトリを表示
Write-Host "Current directory: $(Get-Location)"

# リポジトリのルートディレクトリに移動
Set-Location -Path "I:\Hunyuan3D-2.1-main"

# キャッシュを使うかどうかを選択
$useCache = Read-Host "キャッシュを使用しますか？ (Y/n)"

if ($useCache -eq "n" -or $useCache -eq "N") {
    # キャッシュなしでビルド（完全にクリーンな環境で再ビルド）
    $tagName = "kechiro/hunyuan3d:2.1-fresh"
    Write-Host "Building Docker image without cache as $tagName..."
    docker build --no-cache -t $tagName -f docker/Dockerfile .
} else {
    # 通常のビルド（キャッシュあり）
    $tagName = "kechiro/hunyuan3d:2.1"
    Write-Host "Building Docker image as $tagName using cache..."
    docker build -t $tagName -f docker/Dockerfile .
}

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
