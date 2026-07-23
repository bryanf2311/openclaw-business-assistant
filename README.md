# OpenClaw Business Assistant Template

A ready-to-deploy AI personal assistant for business owners. Clone, configure, and deploy in under 30 minutes.

## What You Get

- A fully-configured AI assistant with memory, web search, and tool use
- Google Workspace integration (Gmail, Calendar, Drive)
- Telegram bot interface
- 18+ skills: data analysis, web research, image generation, diagram creation, project management, and more
- Proactive heartbeat system — your assistant checks in, doesn't wait to be asked
- Clean, opinionated personality — not a corporate chatbot, an actual assistant

## Prerequisites

- **Node.js 20+** and npm
- **OpenClaw** installed: `npm install -g openclaw`
- **A model provider** — OpenAI, Anthropic, Google, OpenRouter, or a local Ollama setup
- **Telegram bot token** (optional, for Telegram access) — talk to [@BotFather](https://t.me/botfather)
- **Google Cloud project** with Gmail/Calendar API enabled (optional, for Google integration)

## Quick Start (5 minutes)

```bash
# 1. Clone the template
git clone https://github.com/bryanf2311/openclaw-business-assistant.git ~/.openclaw
cd ~/.openclaw

# 2. Set up your config
cp openclaw.template.json openclaw.json

# 3. Create your .env file
cp .env.example .env
# Edit .env with your actual API keys

# 4. Run the setup wizard
openclaw configure

# 5. Start the gateway
openclaw gateway run
```

## Environment Variables

Copy `.env.example` to `.env` and fill in your values:

| Variable | Required | Description |
|----------|----------|-------------|
| `OPENCLAW_GATEWAY_TOKEN` | Yes | Auth token for your gateway (generate one: `openssl rand -hex 20`) |
| `PRIMARY_MODEL` | No | Override the default model (e.g. `openai/gpt-4o`) |
| `TELEGRAM_BOT_TOKEN` | No | Telegram bot token for chat interface |
| `GOOGLE_CLIENT_ID` | No | Google OAuth client ID |
| `GOOGLE_CLIENT_SECRET` | No | Google OAuth client secret |
| `GOOGLE_ACCESS_TOKEN` | No | Google OAuth access token |
| `GOOGLE_REFRESH_TOKEN` | No | Google OAuth refresh token |

## Customizing for Your Client

### 1. Brand the Assistant
Edit `workspace-business-assistant/SOUL.md` to match your client's brand voice.

### 2. Set Up Google Workspace
Run the Google OAuth setup to connect Gmail and Calendar:
```bash
openclaw auth google
```

### 3. Configure Telegram
Create a bot with [@BotFather](https://t.me/botfather), get the token, add it to your `.env`.

### 4. Add Extra Skills
Skills live in `~/.openclaw/skills/`. Install more from ClawHub:
```bash
openclaw skills install <skill-name>
```

## Included Skills

| Skill | What It Does |
|-------|-------------|
| **gog** | Google Workspace CLI (Gmail, Calendar, Drive, Contacts) |
| **data-analysis** | Query databases, generate reports, analyze spreadsheets |
| **playwright** | Browser automation, web scraping |
| **weather** | Current weather and forecasts |
| **notion** | Notion API for pages, databases, comments |
| **airtable-records** | Browse and manage Airtable bases |
| **todoist** | Task management via Todoist |
| **trello** | Project management via Trello |
| **calendar-cli** | Calendar management |
| **goplaces** | Location and places search |
| **nano-banana-pro** | Image generation and editing |
| **diagram-maker** | Create architecture diagrams and flowcharts |
| **meme-maker** | Meme generation |
| **humanizer** | Make AI text sound more natural |
| **platform-formatting** | Format messages for Discord, WhatsApp, Slack |
| **proactive-agent** | Proactive check-in system with heartbeat |
| **netlify** | Deploy sites to Netlify |
| **youtube-watcher** | YouTube transcript and content analysis |

## Architecture

```
~/.openclaw/
├── openclaw.json          # Gateway configuration (env var references)
├── .env                   # Your secrets (gitignored)
├── skills/                # All assistant skills
├── workspace-business-assistant/  # Assistant's workspace
│   ├── SOUL.md            # Personality and rules
│   ├── AGENTS.md          # Workspace conventions
│   ├── TOOLS.md           # Tool notes
│   ├── USER.md            # About the user
│   └── memory/            # Long-term memory
└── agents/                # Agent state (gitignored)
```

## License

MIT — use it, sell it, customize it for your clients.
