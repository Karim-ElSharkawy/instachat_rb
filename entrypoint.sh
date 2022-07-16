#!/bin/bash

## This script checks if the container is started for the first time.
#CONTAINER_FIRST_STARTUP="CONTAINER_FIRST_STARTUP"
#if [ ! -e /$CONTAINER_FIRST_STARTUP ]; then
#    touch /$CONTAINER_FIRST_STARTUP
#    rails db:prepare
#fi

set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /rails-app/tmp/pids/server.pid

exec "$@"