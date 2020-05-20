#!/usr/bin/env bash

BASEDIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

docker-compose -f "$BASEDIR"/docker-compose-services.yml down -v
docker-compose -f "$BASEDIR"/docker-compose-monitoring.yml down -v