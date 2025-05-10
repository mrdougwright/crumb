# Dockerfile

# Base image
FROM elixir:1.16-alpine AS build

# Install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set environment
ENV MIX_ENV=prod \
    LANG=C.UTF-8

# Install Node and dependencies for assets
RUN apk add --no-cache build-base git npm

# Create build dir
WORKDIR /app

# Copy files
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only prod
RUN mix deps.compile

COPY priv priv
COPY lib lib

# Compile and digest assets
RUN mix compile

# Release the app
RUN mix release

# ─── FINAL IMAGE ────────────────────────────────────────────

FROM alpine:3.18 AS app

RUN apk add --no-cache openssl ncurses-libs libstdc++

WORKDIR /app

COPY --from=build /app/_build/prod/rel/crumb ./

CMD ["bin/crumb", "start"]
