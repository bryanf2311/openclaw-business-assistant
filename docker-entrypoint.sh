#!/usr/bin/env bash
set -e

cd /root/.openclaw

# ── .env file ──
if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
  echo "[entrypoint] Created .env from .env.example — add your API keys to it"
fi

# ── Gateway auth token ──
# Generate one if it wasn't provided, and persist it to .env so it
# survives container restarts.
if [ -z "${OPENCLAW_GATEWAY_TOKEN}" ]; then
  OPENCLAW_GATEWAY_TOKEN="$(openssl rand -hex 20)"
  if [ -f .env ] && grep -q '^OPENCLAW_GATEWAY_TOKEN=' .env; then
    sed -i "s|^OPENCLAW_GATEWAY_TOKEN=.*|OPENCLAW_GATEWAY_TOKEN=\"${OPENCLAW_GATEWAY_TOKEN}\"|" .env
  else
    printf '\nOPENCLAW_GATEWAY_TOKEN="%s"\n' "${OPENCLAW_GATEWAY_TOKEN}" >> .env
  fi
  echo "[entrypoint] Generated gateway token and saved it to .env"
fi
export OPENCLAW_GATEWAY_TOKEN

# ── Defaults ──
# Inside a container the gateway must bind beyond loopback to be
# reachable through the published port. The compose file publishes it
# on the *host's* loopback only, so this stays private by default.
export OPENCLAW_GATEWAY_BIND="${OPENCLAW_GATEWAY_BIND:-lan}"
export PRIMARY_MODEL="${PRIMARY_MODEL:-}"
export TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN:-}"

# ── Config file ──
# OpenClaw does NOT substitute ${VAR} placeholders in openclaw.json
# itself for structural fields (gateway.bind, model.primary, etc — it
# treats them as literal strings and rejects them against the field's
# schema). So this renders the template with real values substituted
# BEFORE OpenClaw ever reads the file. Only happens once, on first
# boot — after that, openclaw.json is yours, hand-edit it freely (e.g.
# to add a custom models.providers entry) and it won't be overwritten.
if [ ! -f openclaw.json ]; then
  if [ -f openclaw.template.json ]; then
    sed \
      -e "s#\${HOME}#${HOME}#g" \
      -e "s#\${PRIMARY_MODEL}#${PRIMARY_MODEL}#g" \
      -e "s#\${OPENCLAW_GATEWAY_TOKEN}#${OPENCLAW_GATEWAY_TOKEN}#g" \
      -e "s#\${OPENCLAW_GATEWAY_BIND}#${OPENCLAW_GATEWAY_BIND}#g" \
      -e "s#\${TELEGRAM_BOT_TOKEN}#${TELEGRAM_BOT_TOKEN}#g" \
      openclaw.template.json > openclaw.json
    echo "[entrypoint] Created openclaw.json from template (env values substituted)"
    if [ -z "${PRIMARY_MODEL}" ]; then
      echo "[entrypoint] WARNING: PRIMARY_MODEL is empty — set it in .env, delete openclaw.json, and restart to regenerate." >&2
    fi
  else
    echo "[entrypoint] ERROR: no openclaw.json and no openclaw.template.json found." >&2
    echo "[entrypoint] Did you mount the repo at /root/.openclaw? (see docker-compose.yml)" >&2
    exit 1
  fi
fi

# ── Runtime directories ──
mkdir -p \
  workspace-business-assistant/memory \
  agents/business-assistant/agent \
  agents/business-assistant/sessions

echo "[entrypoint] Starting: $*"
exec "$@"
