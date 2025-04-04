# Crumb

**Crumb** is a lightweight, self-hosted event tracking pipeline. Drop in a tiny SDK, send events from your app, and forward them wherever you want. No dashboards, no billing surprises—just data you own.

## Why Crumb?

- Simple `track()` events
- Built with Elixir for speed and reliability
- Forward events to any service (webhooks, GA, etc.)
- Self-hosted, open-source, and easy to extend

## Quickstart

### 0. Install

Get the code.
Use [mise](https://mise.jdx.dev/), asdf or similar to install from .tool-versions.

```bash
git clone https://github.com/mrdougwright/crumb
cd crumb
mise install
```

### 1. Run the Crumb Server

```bash
mix deps.get
iex -S mix phx.server
```

### 2. Build JS SDk

```bash
cd sdk/js
npm run build
cd ../..
```

### 3. Run JS SDK test

```bash
# from root (crumb)
npx serve .
```

Go to `localhost:3000` and navigate to `sdk-js-test` page.
Click the button, see event sent (browser console) and received (server shell)!
