#!/bin/sh
set -e

bundle check || bundle install

ls bin/rails && bin/rails db:prepare

rm -f /app/tmp/pids/server.pid

exec "$@"
