FROM node:22-bookworm-slim

# Pin a specific OpenClaw version for reproducible client installs:
#   docker compose build --build-arg OPENCLAW_VERSION=x.y.z
ARG OPENCLAW_VERSION=latest

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    openssl \
    procps \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g openclaw@${OPENCLAW_VERSION}

# The repo is bind-mounted here at runtime (see docker-compose.yml),
# so config, skills, workspace, and agent state all live on the host
# and survive container rebuilds. A plain `git pull` on the host
# updates the running assistant.
ENV HOME=/root
WORKDIR /root/.openclaw

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 18789

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["openclaw", "gateway", "run"]
