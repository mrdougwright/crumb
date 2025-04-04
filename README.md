# Crumb

**Crumb** is a lightweight, self-hosted event tracking pipeline. Drop in a tiny SDK, send events from your app, and forward them wherever you want. No dashboards, no billing surprises—just data you own.

## Why Crumb?

- Simple `track()` events
- Built with Elixir for speed and reliability
- Forward events to any service (webhooks, GA, etc.)
- Self-hosted, open-source, and easy to extend

## Quickstart

### 1. Run the Crumb Server

```bash
git clone https://github.com/mrdougwright/crumb
cd crumb
mix deps.get
mix phx.server
