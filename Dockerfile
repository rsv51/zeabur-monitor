# 使用 Node.js Slim 基础镜像（更小的攻击面）
FROM node:20-slim

# 设置工作目录
WORKDIR /app

# 设置时区
ENV TZ=Asia/Shanghai

# 安装依赖（使用缓存层）
COPY package*.json ./
RUN npm ci --only=production

# 复制应用代码
COPY server.js ./
COPY crypto-utils.js ./
COPY public/ ./public/

# 创建数据目录用于存储账号和密码文件
RUN mkdir -p /app/data

# 设置环境变量
ENV PORT=3000
ENV NODE_ENV=production
ENV DATA_DIR=/app/data

# 暴露端口
EXPOSE 3000

# 启动应用（使用默认用户，无需非 root 用户配置）
CMD ["node", "server.js"]
