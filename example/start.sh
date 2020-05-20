#!/usr/bin/env bash

BASEDIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

docker-compose -f "$BASEDIR"/docker-compose-services.yml up -d --scale appA=4 --scale appB=3

"$BASEDIR/../wait.sh" 1 "$BASEDIR/targets.json" 'targets'

docker-compose -f "$BASEDIR"/docker-compose-monitoring.yml up -d