#!/bin/bash

scriptname=$(readlink -f "$0")
dirname=$(dirname "$scriptname")

. "$dirname/env.build.sh"

buildname=linuxagent:latest

remoterepo="${remoterepo:-linuxagent}"
remotetag="${remotetag:-latest}"
[ -n "$remotehost" ] && remotehost="${remotehost}/"
[ -n "$remoteprefix" ] && remoteprefix="${remoteprefix}/"
remotename="${remotehost}${remoteprefix}${remoterepo}:${remotetag}"

#cmd=$(command -v buildah)
[ -z "$cmd" ] && cmd=$(command -v docker)

cd "$dirname" || exit 1
echo "Building image"
"$cmd" build "${build_args[@]}" -t "$buildname" src "$@" || exit 1
if [ -n "$remotehost" ]; then
  echo "Pushing image to $remotename"
  if [ "$remotename" != "$buildname" ]; then
    "$cmd" tag "$buildname" "$remotename"
  fi
  "$cmd" push "$remotename"
fi
