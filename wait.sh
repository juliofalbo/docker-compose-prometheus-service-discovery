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

print_cyan "Installing Docker Compose Prometheus Service Discovery"

echo "$BASEDIR"

if grep -q "alias docker-prmt-serv-disc=\"$BASEDIR/docker-prmt-serv-disc.sh\"" "$HOME/.bash_profile";
  then
    print_blue "Command 'docker-prmt-serv-disc' already exists. SKIPPING"
  else
    echo "alias docker-prmt-serv-disc=\"$BASEDIR/docker-prmt-serv-disc.sh\"" >> ~/.bash_profile
fi

brew install gnu-sed
brew install yq

print_green "Docker Compose Prometheus Service Discovery was installed. Source your .bash_profile or open another terminal to use."