#!/usr/bin/env bash
set -e

# ──────────────────────────────────────────────
# OpenClaw Business Assistant — Quick Setup
# Run this after cloning: bash setup.sh
# ──────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "╔══════════════════════════════════════════╗"
echo "║  OpenClaw Business Assistant — Setup     ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ── Check prerequisites ──
echo "🔍 Checking prerequisites..."

if ! command -v node &>/dev/null; then
  echo "❌ Node.js is not installed. Install it first: https://nodejs.org"
  exit 1
fi
echo "   ✅ Node.js $(node -v)"

if ! command -v openclaw &>/dev/null; then
  echo "   ⚠️  OpenClaw not found. Installing..."
  npm install -g openclaw
fi
echo "   ✅ OpenClaw $(openclaw --version 2>/dev/null || echo 'installed')"

# ── Set up .env ──
echo ""
echo "🔑 Checking environment variables..."

if [ ! -f .env ]; then
  if [ -f .env.example ]; then
    cp .env.example .env
    echo "   ⚠️  Created .env from .env.example — EDIT IT with your real keys!"
    echo "   📝 Run: nano .env"
  else
    echo "   ⚠️  No .env.example found. Create .env manually."
  fi
else
  echo "   ✅ .env exists"
fi

# Ensure the bind var exists (added after early versions of this template)
if [ -f .env ] && ! grep -q '^OPENCLAW_GATEWAY_BIND=' .env; then
  printf '\nOPENCLAW_GATEWAY_BIND="loopback"\n' >> .env
  echo "   ✅ Added OPENCLAW_GATEWAY_BIND=loopback to .env"
fi

# Generate a gateway token if the .env doesn't have one yet
if [ -f .env ] && ! grep -q '^OPENCLAW_GATEWAY_TOKEN="..*"' .env; then
  TOKEN="$(openssl rand -hex 20 2>/dev/null || head -c 20 /dev/urandom | od -An -tx1 | tr -d ' \n')"
  if grep -q '^OPENCLAW_GATEWAY_TOKEN=' .env; then
    sed -i.bak "s|^OPENCLAW_GATEWAY_TOKEN=.*|OPENCLAW_GATEWAY_TOKEN=\"${TOKEN}\"|" .env && rm -f .env.bak
  else
    printf '\nOPENCLAW_GATEWAY_TOKEN="%s"\n' "${TOKEN}" >> .env
  fi
  echo "   ✅ Generated gateway token"
fi

# ── Set up config ──
echo ""
echo "📋 Setting up configuration..."

if [ ! -f openclaw.json ]; then
  # shellcheck disable=SC1091
  PRIMARY_MODEL_CHECK="$(grep -E '^PRIMARY_MODEL="..*"' .env 2>/dev/null || true)"
  if [ -z "${PRIMARY_MODEL_CHECK}" ]; then
    echo "   ⚠️  PRIMARY_MODEL is not set in .env yet — skipping config generation."
    echo "   📝 Edit .env (set PRIMARY_MODEL and its API key), then re-run: bash setup.sh"
  elif [ -f openclaw.template.json ]; then
    # OpenClaw does NOT substitute ${VAR} placeholders in openclaw.json
    # itself for structural fields (gateway.bind, model.primary) — it
    # treats them as literal strings and rejects them. Render the
    # template with real values from .env substituted in directly.
    set -a
    # shellcheck disable=SC1091
    source .env
    set +a

    # Ollama Cloud needs an explicit provider entry — the bundled ollama
    # plugin only auto-discovers a LOCAL daemon (see docker-entrypoint.sh
    # for the same logic).
    MODEL_PROVIDERS='{}'
    AUTH_PROFILES='{}'
    if [[ "${PRIMARY_MODEL:-}" == ollama/* ]] && [ -n "${OLLAMA_API_KEY:-}" ]; then
      OLLAMA_MODEL_ID="${PRIMARY_MODEL#ollama/}"
      MODEL_PROVIDERS='{"ollama":{"baseUrl":"https://ollama.com","apiKey":"OLLAMA_API_KEY","api":"ollama","models":[{"id":"'"${OLLAMA_MODEL_ID}"'","name":"'"${OLLAMA_MODEL_ID}"'","reasoning":false,"input":["text","image"],"cost":{"input":0,"output":0,"cacheRead":0,"cacheWrite":0},"contextWindow":128000,"maxTokens":8192,"params":{"num_ctx":128000}}]}}'
      AUTH_PROFILES='{"ollama-cloud:default":{"provider":"ollama-cloud","mode":"api_key"}}'
      echo "   ✅ Registered Ollama Cloud provider for ${PRIMARY_MODEL}"
    fi

    sed \
      -e "s#\${HOME}#${HOME}#g" \
      -e "s#\${PRIMARY_MODEL}#${PRIMARY_MODEL:-}#g" \
      -e "s#\${OPENCLAW_GATEWAY_TOKEN}#${OPENCLAW_GATEWAY_TOKEN:-}#g" \
      -e "s#\${OPENCLAW_GATEWAY_BIND}#${OPENCLAW_GATEWAY_BIND:-loopback}#g" \
      -e "s#\${TELEGRAM_BOT_TOKEN}#${TELEGRAM_BOT_TOKEN:-}#g" \
      -e "s#\"\${MODEL_PROVIDERS}\"#${MODEL_PROVIDERS}#g" \
      -e "s#\"\${AUTH_PROFILES}\"#${AUTH_PROFILES}#g" \
      openclaw.template.json > openclaw.json
    echo "   ✅ Created openclaw.json from template (env values substituted)"
  else
    echo "   ❌ openclaw.template.json not found!"
    exit 1
  fi
else
  echo "   ⏭️  openclaw.json already exists, skipping"
fi

# ── Create workspace directories ──
echo ""
echo "📁 Creating workspace directories..."
mkdir -p workspace-business-assistant/memory
mkdir -p agents/business-assistant/agent
mkdir -p agents/business-assistant/sessions
echo "   ✅ Done"

# ── Run OpenClaw configure ──
echo ""
echo "⚙️  Running OpenClaw configure..."
openclaw configure 2>/dev/null || echo "   ⚠️  Configure skipped (you can run it manually: openclaw configure)"

# ── Summary ──
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║  Setup Complete!                         ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "   Next steps:"
echo "   1. Edit your .env file with real API keys:"
echo "      nano .env"
echo ""
echo "   2. Start the gateway:"
echo "      openclaw gateway run"
echo ""
echo "   3. Open the control UI:"
echo "      http://localhost:18789"
echo ""
echo "   4. Customize your assistant's personality:"
echo "      nano workspace-business-assistant/SOUL.md"
echo ""
echo "   Need help? https://docs.openclaw.ai"
echo ""
