# 使用 Node.js Slim 基础镜像（更小的攻击面）
FROM node:20-slim

# 设置工作目录
WORKDIR /app

# 设置时区
ENV TZ=Asia/Shanghai

# 创建非 root 用户（必须在创建目录之前）
RUN addgroup -g 1000 appgroup && \
    adduser -u 1000 -G appgroup -s /bin/sh -D appuser

# 安装依赖（使用缓存层）
COPY package*.json ./
RUN npm ci --only=production

# 复制应用代码
COPY server.js ./
COPY crypto-utils.js ./
COPY public/ ./public/

# 创建数据目录用于存储账号和密码文件，并设置权限
RUN mkdir -p /app/data && chown -R appuser:appgroup /app/data

# 设置环境变量
ENV PORT=3000
ENV NODE_ENV=production
ENV DATA_DIR=/app/data

# 暴露端口
EXPOSE 3000

# 切换用户
USER appuser

# 启动应用
CMD ["node", "server.js"]
