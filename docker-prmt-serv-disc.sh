#!/usr/bin/env bash

BASEDIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

RED='\033[0;31m'
GREEN='\033[0;32m'
LIGHT_CYAN='\033[0;96m'
LIGHT_YELLOW='\033[0;93m'
BLUE='\033[0;34m'
NOCOLOR='\033[0m'

function print_green() {
    echo -e "${GREEN}$1${NOCOLOR}"
}

function print_blue() {
    echo -e "${BLUE}$1${NOCOLOR}"
}

function print_error() {
    echo -e "${RED}$1${NOCOLOR}"
}

function print_cyan() {
    echo -e "${LIGHT_CYAN}$1${NOCOLOR}"
}

function print_yellow() {
    echo -e "${LIGHT_YELLOW}$1${NOCOLOR}"
}

# Name of the script
SCRIPT=$( basename "$0" )

# Current version
VERSION="1.0.0"

#
# Message to display for usage and help.
#
function usage
{
    local txt=(
"Utility $SCRIPT for doing stuff."
"Usage: $SCRIPT [options] <command> [arguments]"
""
"Commands:"
"  start           docker-prmt-serv-disc start - It will start the Docker Compose Prometheus Service Discovery"
"  stop            docker-prmt-serv-disc stop - It will stop the Docker Compose Prometheus Service Discovery"
""
""
"Options:"
"  --help, -h               Print help."
"  --version, -v            Print version."
"  --yaml-file, -f          The yaml file that contains your configuration."
    )

    printf "%s\n" "${txt[@]}"
}

#
# Message to display for version.
#
function version
{
    local txt=("$SCRIPT version $VERSION")
    printf "%s\n" "${txt[@]}"
}

#
# Method responsible to get the yaml file
#
function getYamlFile {
  COUNTER=0;
  YAML_FILE=('./example/docker-prometheus-sd.yml');
  for setUpArgument in "$@"
  do
    COUNTER=$((COUNTER+1));
    case "$setUpArgument" in
        --yaml-file | -f)
          YAML_FILE=("${@:COUNTER+1}");
        ;;
    esac
  done
  echo "${YAML_FILE[0]}";
}

function do-start() {
  print_cyan "Starting Docker Compose Prometheus Service Discovery"
  YAML_FILE_LOCATION=$(getYamlFile "$@")

  SERVICE_RUNNING_PID=$(pgrep -f docker-prometheus-sd-service.sh)

  if [ -z "$SERVICE_RUNNING_PID" ]
  then
    print_cyan "BASEDIR: $BASEDIR"
    print_cyan "YAML_FILE_LOCATION: $YAML_FILE_LOCATION"
    nohup "$BASEDIR"/docker-prometheus-sd-service.sh "$YAML_FILE_LOCATION" 0<&- &> "$BASEDIR"/debug.log.file &
  else
    print_yellow "You are already a Docker Compose Prometheus Service Discovery running using the PID $SERVICE_RUNNING_PID"
  fi
}

function do-stop() {
  print_cyan "Stopping Docker Compose Prometheus Service Discovery"

  PIDS=()
  while IFS='' read -r line; do PIDS+=("$line"); done < <(pgrep -f docker-prometheus-sd-service.sh)

  for VAR_PID in "${PIDS[@]}"
  do
    kill -9 "$VAR_PID"
  done
}

function do-log() {
  tail -f "$BASEDIR"/debug.log.file
}

#
# Process options
#
for argument in "$@"
do
    case "$argument" in

        --help | -h)
            usage
            exit 0
        ;;

        --version | -v)
            version
            exit 0
        ;;

        --yaml-file | -f)
        ;;

        start  \
        | stop \
        | log)
            shift
            "do-$argument" "$@"
            exit 0
        ;;

        *)
            print_error "Option/command '$argument' not recognized."
            exit 0
        ;;

    esac
done

exit 0