#!/usr/bin/env bash
# shellcheck disable=SC2086

set -e

# OUTPUT
# Colors
MAGENTA="\033[0;35m"
WHITE="\033[0;37m"
# Format
BOLD="\033[1m"
NF="\033[0m"
# Symbols
Q=$(echo -e ${BOLD}${MAGENTA}»${WHITE})
NL=$(echo -e "\n${NF}")

# Returns the Compose V2 command, if available, else Compose V1 command will
# be used instead. If the latter isn't available as well, an error is thrown
# and the script fails with exit code 1.
get_docker_compose_cmd () {
  if docker compose > /dev/null 2>&1
  then
    echo "$(command -v docker) compose"
  else
    command -v docker-compose
  fi
}

CMD=$(get_docker_compose_cmd)

echo -e "${Q} Stopping and removing existing containers, networks and volumes:${NL}"
${CMD} -p "${PROJECT_SLUG}" down -v --remove-orphans
echo ""
