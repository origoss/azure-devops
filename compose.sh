#!/bin/bash

scriptname=$(readlink -f "$0")
dirname=$(dirname "$scriptname")

. "$dirname/env.sh"

buildname=linuxagent:latest

remoterepo="${remoterepo:-linuxagent}"
remotetag="${remotetag:-latest}"
[ -n "$remotehost" ] && remotehost="${remotehost}/"
[ -n "$remoteprefix" ] && remoteprefix="${remoteprefix}/"
remotename="${remotehost}${remoteprefix}${remoterepo}:${remotetag}"

export IMAGE="${remotename}"

cmd=()

compose=$(command -v docker-compose)
if [ -z "$compose" ]; then
  cmd+=($(command -v docker) compose)
else
  cmd+=("$compose")
fi
cd "$dirname" && "${cmd[@]}" "$@"
