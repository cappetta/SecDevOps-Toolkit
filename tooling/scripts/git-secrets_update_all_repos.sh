#!/bin/bash

# Big thanks to Nate J
# ref: https://gist.github.com/iAmNathanJ/0ae03dcb08ba222d36346b138e83bfdf
# ref: https://seesparkbox.com/foundry/git_secrets

# Usage examples:
#   ./update-all-repos.sh
#   ./update-all-repos.sh ~/Sites ~/Projects

HIGHLIGHT="\e[01;34m"
NORMAL='\e[00m'

function update {
  local d="$1"
  if [ -d "$d" ]; then
    cd "$d" > /dev/null
    if [ -d ".git" ]; then
      printf "%b\n" "\n${HIGHLIGHT}Updating `pwd`$NORMAL"
      git secrets --install
    else
      scan *
    fi
    cd .. > /dev/null
  fi
}

function scan {
  for x in $*; do
    update "$x"
  done
}

function updater {
  if [ "$1" != "" ]; then cd "$1" > /dev/null; fi
  printf "%b\n" "${HIGHLIGHT}Scanning ${PWD}${NORMAL}"
  scan *
}

if [ "$1" == "" ]; then
  updater
else
  for dir in "$@"; do
    updater "$dir"
  done
fi