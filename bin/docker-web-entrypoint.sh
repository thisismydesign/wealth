#!/bin/sh
set -e

wait_for()
{
  echo "Waiting $1 seconds for $2:$3"
  timeout $1 sh -c 'until nc -z $0 $1; do sleep 0.1; done' $2 $3 || return 1
  echo "$2:$3 available"
}

bundle check || bundle install

wait_for 10 db 5432
wait_for 10 redis 6379

ls bin/rails && bin/rails db:prepare

rm -f /app/tmp/pids/server.pid

exec "$@"
