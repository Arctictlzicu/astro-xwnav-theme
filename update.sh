#!/bin/bash
set -e

# --- 更新脚本 ---

echo "✅ 步骤 1: 重新构建 Docker 镜像 (使用最新代码)"
docker build -t astro-xwnav .

echo "✅ 步骤 2: 停止旧的容器 (如果存在)"
docker stop my-nav-site || true

echo "✅ 步骤 3: 删除旧的容器 (如果存在)"
docker rm my-nav-site || true

echo "✅ 步骤 4: 启动包含最新内容的新容器"
docker run -d -p 8080:80 --name my-nav-site astro-xwnav

echo "🎉 更新完成！您的导航站已是最新版本。"
