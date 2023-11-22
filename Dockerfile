# 使用基础镜像
FROM golang:alpine AS builder

# 安装必要的工具
RUN apk update && apk add --no-cache \
    curl \
    tar

# 创建新的工作目录
WORKDIR /app

# 下载并解压文件，并给予所有用户读写和执行权限
RUN curl -LO https://github.com/pandora-next/deploy/releases/download/v0.2.1/PandoraNext-v0.2.1-linux-amd64-90b19a5.tar.gz \
    && tar -xzf PandoraNext-v0.2.1-linux-amd64-90b19a5.tar.gz --strip-components=1 \
    && rm PandoraNext-v0.2.1-linux-amd64-90b19a5.tar.gz \
    && chmod 777 -R .
    
# 获取授权
RUN --mount=type=secret,id=LICENSE_URL,dst=/etc/secrets/LICENSE_URL \
    curl -fLO https://dash.pandoranext.com/data/$(cat /etc/secrets/LICENSE_URL)/license.jwt
RUN chmod 777 license.jwt

# 获取tokens.json
RUN --mount=type=secret,id=TOKENS_JSON,dst=/etc/secrets/TOKENS_JSON \
    cat /etc/secrets/TOKENS_JSON > tokens.json
RUN chmod 777 tokens.json

# config.json文件
COPY config.json .
RUN chmod 777 config.json

COPY start.sh .
RUN chmod 777 start.sh

# 修改PandoraNext的执行权限
RUN chmod 777 ./PandoraNext

# 创建全局缓存目录并提供最宽松的权限
RUN mkdir /.cache && chmod 777 /.cache

# 开放端口
EXPOSE 8080

# 启动命令
CMD ["sh","start.sh"]
