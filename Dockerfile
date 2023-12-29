FROM ruby:3.2.2-alpine AS base

WORKDIR /app

RUN apk --update add --no-cache \
  # Required for Docker port scanning
  netcat-openbsd \
  # Required by Rails
  tzdata \
  # Required for PostgreSQL
  postgresql-client \
  # Required by the app
  nodejs


FROM base AS dev

RUN apk --update add --no-cache \
  # Build tools for building gems with native extensions
  build-base \
  # Required for PostgreSQL
  postgresql-dev

COPY . .


FROM dev AS ruby-deps

RUN bundle install --no-cache


FROM base AS app

COPY --from=ruby-deps /usr/local/bundle/ /usr/local/bundle/

COPY .env.example .env
COPY . .
