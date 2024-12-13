FROM node:20.9.0-alpine AS node
FROM ruby:3.2.2-alpine AS base

COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/share /usr/local/share
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin
COPY --from=node /opt /opt

WORKDIR /app

RUN apk --update add --no-cache \
  # Required for Docker port scanning
  netcat-openbsd \
  # Required by Rails
  tzdata \
  # Required for PostgreSQL
  postgresql-client \
  # Required by the app
  nodejs \
  # Required for Apple Silicon
  gcompat


FROM base AS dev

RUN apk --update add --no-cache \
  # Build tools for building gems with native extensions
  build-base \
  # Required for PostgreSQL
  postgresql-dev

COPY . .


FROM dev AS deps

RUN bundle install --no-cache


FROM base AS app

COPY --from=deps /usr/local/bundle/ /usr/local/bundle/

COPY . .
