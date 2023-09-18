#!/bin/bash

scriptname=$(readlink -f "$0")
dirname=$(dirname "$scriptname")

. "$dirname/env.sh"

cd "$dirname" && docker compose "$@"
