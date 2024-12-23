#!/usr/bin/env bash
# shellcheck disable=SC2086

set -e

# OUTPUT
# Colors
MAGENTA="\033[0;35m"
GREEN="\033[0;32m"
RED="\033[0;31m"
WHITE="\033[0;37m"
# Format
BOLD="\033[1m"
NF="\033[0m"
# Symbols
Q=$(echo -e ${BOLD}${MAGENTA}»${WHITE})
C=$(echo -e ${BOLD}${GREEN}✔${WHITE})
X=$(echo -e ${BOLD}${RED}✘${WHITE})
NL=$(echo -e "\n${NF}")

# Returns the Compose V2 command, if available, else Compose V1 command.
# If the latter is also not available, an error is thrown and the script
# fails.
get_docker_compose_cmd () {
  if docker compose > /dev/null 2>&1
  then
    echo "$(command -v docker) compose"
  else
    command -v docker-compose
  fi
}

DOCKER_COMPOSE=$(get_docker_compose_cmd)
CMD="${DOCKER_COMPOSE} ${1} -p ${PROJECT_SLUG}"

MY_UID="$(id -u)"
MY_GID="$(id -g)"
export MY_UID MY_GID

./scripts/docker-compose-down.sh

echo -e "${Q} Running Docker Compose with the following configuration:${NL}"
${CMD} config
echo ""

# Docker Compose Options
# --build: build images before starting containers
# --force-recreate: recreate containers even if their configuration and image
#   haven’t changed
# --pull=always: always attempt to pull images before running
# --remove-orphans: remove containers for undefined services
# --renew-anon-volumes, -V: recreate anonymous volumes instead of retrieving
#   data from the previous containers

if ${CMD} up --build --force-recreate --pull=always --remove-orphans -V ${2}
then
  echo -e "\n${C} Docker Compose succeeded!"
else
  echo -e "\n${X} Docker Compose failed!"
  exit 1
fi
