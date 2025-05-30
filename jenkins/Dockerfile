FROM golang

RUN apt-get update && apt-get install -y \
    bash \
    ca-certificates \
    curl \
    git \
    libpam0g \
    openssh-client \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY gogs/gogs /app/

EXPOSE 22 3000

CMD ["./gogs", "web"]