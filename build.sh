#!/bin/bash

scriptname=$(readlink -f "$0")
dirname=$(dirname "$scriptname")

remoterepo="${remoterepo:-linuxagent}"
remotetag="${remotetag:-latest}"

remotename="${remotehost}${remoteprefix}/${remoterepo}:${remotetag}"

cmd=$(command -v buildah)
[ -z "$cmd" ] && cmd=$(command -v docker)

cd "$dirname" || exit 1
echo "Building image"
"$cmd" build -t linuxagent:latest src || exit 1
if [ -n "$remotehost" ]; then
  echo "Pushing image to $remotename"
  "$cmd" tag linuxagent:latest "$remotename"
  "$cmd" push "$remotename"
fi
