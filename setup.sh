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

# ── Set up config ──
echo ""
echo "📋 Setting up configuration..."

if [ ! -f openclaw.json ]; then
  if [ -f openclaw.template.json ]; then
    cp openclaw.template.json openclaw.json
    echo "   ✅ Created openclaw.json from template"
  else
    echo "   ❌ openclaw.template.json not found!"
    exit 1
  fi
else
  echo "   ⏭️  openclaw.json already exists, skipping"
fi

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
