# --- STAGE 1: Build the application ---
# 使用一个包含 Node.js 18 的轻量级 Alpine 镜像作为构建环境
FROM node:18-alpine AS builder

# 设置工作目录
WORKDIR /app

# 安装 pnpm
RUN npm install -g pnpm

# 复制项目配置文件
COPY package.json pnpm-lock.yaml ./

# 安装项目依赖
RUN pnpm install

# 复制所有项目源文件
COPY . .

# （重要）运行图标下载脚本
# 注意：在 Docker 环境中，脚本路径要用 ./
RUN npx tsx ./icon-system/0icon.ts

# 运行构建命令，生成静态文件到 /app/dist 目录
RUN pnpm build

# --- STAGE 2: Create the final production image ---
# 使用一个超轻量的 Nginx Alpine 镜像作为最终环境
FROM nginx:alpine

# 从构建阶段（builder）复制构建好的静态文件到 Nginx 的网站根目录
COPY --from=builder /app/dist /usr/share/nginx/html

# （可选）复制自定义的 Nginx 配置文件
# 我们将在下一步创建这个文件
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露容器的 80 端口
EXPOSE 80

# 启动 Nginx 服务
CMD ["nginx", "-g", "daemon off;"]
