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

# ── Reset mode: ./deploy.sh --reset ──
# Wipes everything the first boot generated (config, agent state,
# memory, logs) but KEEPS .env, then falls through to a fresh deploy.
if [ "${1:-}" = "--reset" ]; then
  echo "⚠️  RESET: this deletes the generated openclaw.json, all agent"
  echo "   state, memory, and logs. Your .env (API keys) is kept."
  read -r -p "   Continue? [y/N] " answer
  case "$answer" in
    [yY]|[yY][eE][sS]) ;;
    *) echo "   Aborted."; exit 1 ;;
  esac
  docker compose down --remove-orphans 2>/dev/null || true
  RESET_PATHS=(openclaw.json openclaw.json.* workspace agents logs state media
    credentials cache cron devices identity subagents telegram canvas)
  # The container runs as root, so generated files may be root-owned on
  # the host — retry with sudo only if a plain delete can't finish.
  if ! rm -rf "${RESET_PATHS[@]}" 2>/dev/null; then
    echo "   Some files are root-owned (created by the container) — using sudo to remove them."
    sudo rm -rf "${RESET_PATHS[@]}"
  fi
  if ! rm -rf workspace-business-assistant/memory 2>/dev/null; then
    sudo rm -rf workspace-business-assistant/memory
  fi
  mkdir -p workspace-business-assistant/memory
  echo "   ✅ Reset complete — deploying fresh."
  echo ""
fi

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
echo "   Add API keys (model provider, Telegram) then apply them:"
echo "     nano .env && docker compose up -d"
echo ""
echo "   Logs:        docker compose logs -f"
echo "   Status:      docker compose ps"
echo "   Update:      git pull && docker compose up -d --build"
echo "   Control UI:  http://127.0.0.1:18789"
echo "     (on a VPS: ssh -L 18789:127.0.0.1:18789 user@your-vps, then open locally)"
echo ""
