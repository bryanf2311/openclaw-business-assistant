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

# ── Model provider registration ──
# Mainstream providers (openai/anthropic/google/openrouter/xai) are
# picked up from their API-key env vars automatically. Ollama CLOUD is
# not: the bundled ollama plugin only auto-discovers a LOCAL daemon, so
# a cloud model ref needs an explicit models.providers.ollama entry.
# Build it here so PRIMARY_MODEL="ollama/<model>:cloud" + OLLAMA_API_KEY
# in .env is all a client install needs.
MODEL_PROVIDERS='{}'
AUTH_PROFILES='{}'
if [[ "${PRIMARY_MODEL}" == ollama/* ]] && [ -n "${OLLAMA_API_KEY:-}" ]; then
  OLLAMA_MODEL_ID="${PRIMARY_MODEL#ollama/}"
  MODEL_PROVIDERS='{"ollama":{"baseUrl":"https://ollama.com","apiKey":"OLLAMA_API_KEY","api":"ollama","models":[{"id":"'"${OLLAMA_MODEL_ID}"'","name":"'"${OLLAMA_MODEL_ID}"'","reasoning":false,"input":["text","image"],"cost":{"input":0,"output":0,"cacheRead":0,"cacheWrite":0},"contextWindow":128000,"maxTokens":8192,"params":{"num_ctx":128000}}]}}'
  AUTH_PROFILES='{"ollama-cloud:default":{"provider":"ollama-cloud","mode":"api_key"}}'
  echo "[entrypoint] Registered Ollama Cloud provider for ${PRIMARY_MODEL}"
fi

# ── Config file ──
# OpenClaw does NOT substitute ${VAR} placeholders in openclaw.json
# itself for structural fields (gateway.bind, model.primary, etc — it
# treats them as literal strings and rejects them against the field's
# schema). So this renders the template with real values substituted
# BEFORE OpenClaw ever reads the file. Only happens once, on first
# boot — after that, openclaw.json is yours, hand-edit it freely and
# it won't be overwritten. Delete it and restart to regenerate.
if [ ! -f openclaw.json ]; then
  if [ -f openclaw.template.json ]; then
    sed \
      -e "s#\${HOME}#${HOME}#g" \
      -e "s#\${PRIMARY_MODEL}#${PRIMARY_MODEL}#g" \
      -e "s#\${OPENCLAW_GATEWAY_TOKEN}#${OPENCLAW_GATEWAY_TOKEN}#g" \
      -e "s#\${OPENCLAW_GATEWAY_BIND}#${OPENCLAW_GATEWAY_BIND}#g" \
      -e "s#\${TELEGRAM_BOT_TOKEN}#${TELEGRAM_BOT_TOKEN}#g" \
      -e "s#\"\${MODEL_PROVIDERS}\"#${MODEL_PROVIDERS}#g" \
      -e "s#\"\${AUTH_PROFILES}\"#${AUTH_PROFILES}#g" \
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

# ── Token drift check ──
# openclaw.json is rendered once; if the token in .env changes later
# the two silently disagree and the dashboard rejects you. Warn early.
if ! grep -q "\"token\": \"${OPENCLAW_GATEWAY_TOKEN}\"" openclaw.json; then
  echo "[entrypoint] WARNING: OPENCLAW_GATEWAY_TOKEN in .env does not match the token in openclaw.json." >&2
  echo "[entrypoint]          The dashboard will reject the .env token. Use the token from openclaw.json," >&2
  echo "[entrypoint]          or delete openclaw.json and restart to regenerate it from .env." >&2
fi

# ── Runtime directories ──
mkdir -p \
  workspace-business-assistant/memory \
  agents/business-assistant/agent \
  agents/business-assistant/sessions

# ── Preflight ──
# Validate before starting so a bad config fails ONCE with the real
# error at the top of the log, instead of a 2-second crash loop that
# trips OpenClaw's restart breaker and buries the cause. Start anyway:
# some validate complaints are warnings the gateway tolerates.
if ! openclaw config validate; then
  echo "[entrypoint] Config validation failed (see above). Retrying start in 15s —" >&2
  echo "[entrypoint] fix openclaw.json, or delete it and restart to regenerate from .env." >&2
  sleep 15
fi

echo "[entrypoint] Starting: $*"
exec "$@"
