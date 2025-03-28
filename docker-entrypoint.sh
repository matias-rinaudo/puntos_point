#!/bin/sh
set -e

if [ -f /code/tmp/pids/server.pid ]; then
  rm /code/tmp/pids/server.pid
fi

if [ -f /code/tmp/pids/sidekiq.pid ]; then
  rm /code/tmp/pids/sidekiq.pid
fi

bundle check || bundle install

exec "$@"