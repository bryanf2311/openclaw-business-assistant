#!/usr/bin/env bash
set -e

# ──────────────────────────────────────────────
# OpenClaw Business Assistant — Docker Deploy
# Works on a fresh VPS or a local machine.
#
#   git clone <repo> && cd <repo> && ./deploy.sh
# ──────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "╔══════════════════════════════════════════╗"
echo "║  OpenClaw Business Assistant — Deploy    ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ── Docker ──
if ! command -v docker &>/dev/null; then
  echo "❌ Docker is not installed."
  echo ""
  echo "   On a Linux VPS, install it with:"
  echo "     curl -fsSL https://get.docker.com | sh"
  echo ""
  echo "   On Mac/Windows, install Docker Desktop: https://docs.docker.com/get-docker/"
  exit 1
fi
echo "   ✅ Docker $(docker --version | cut -d' ' -f3 | tr -d ',')"

if ! docker compose version &>/dev/null; then
  echo "❌ Docker Compose v2 is required (the 'docker compose' command)."
  echo "   It ships with Docker Desktop and with the get.docker.com install."
  exit 1
fi
echo "   ✅ Docker Compose $(docker compose version --short)"

# ── .env ──
echo ""
if [ ! -f .env ]; then
  cp .env.example .env
  echo "   ✅ Created .env from .env.example"
else
  echo "   ✅ .env exists"
fi

# Generate a gateway token if the .env doesn't have one yet
if ! grep -q '^OPENCLAW_GATEWAY_TOKEN="..*"' .env; then
  if command -v openssl &>/dev/null; then
    TOKEN="$(openssl rand -hex 20)"
  else
    TOKEN="$(head -c 20 /dev/urandom | od -An -tx1 | tr -d ' \n')"
  fi
  if grep -q '^OPENCLAW_GATEWAY_TOKEN=' .env; then
    sed -i.bak "s|^OPENCLAW_GATEWAY_TOKEN=.*|OPENCLAW_GATEWAY_TOKEN=\"${TOKEN}\"|" .env && rm -f .env.bak
  else
    printf '\nOPENCLAW_GATEWAY_TOKEN="%s"\n' "${TOKEN}" >> .env
  fi
  echo "   ✅ Generated gateway token"
fi

# ── Build and start ──
echo ""
echo "🐳 Building and starting the container..."
docker compose up -d --build

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║  Deployed!                               ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "   Add API keys (model provider, Telegram) then restart:"
echo "     nano .env && docker compose restart"
echo ""
echo "   Logs:        docker compose logs -f"
echo "   Status:      docker compose ps"
echo "   Update:      git pull && docker compose up -d --build"
echo "   Control UI:  http://127.0.0.1:18789"
echo "     (on a VPS: ssh -L 18789:127.0.0.1:18789 user@your-vps, then open locally)"
echo ""
