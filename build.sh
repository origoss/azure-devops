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

cmd=
[ -z "$cmd" -a -n "$BUILD_PREFER_PODMAN" ] && cmd=$(command -v podman)
[ -z "$cmd" -a -n "$BUILD_PREFER_BUILDAH" ] && cmd=$(command -v buildah)
[ -z "$cmd" -a -n "$BUILD_PREFER_DOCKER" ] && cmd=$(command -v docker)
[ -z "$cmd" ] && cmd=$(command -v podman)
[ -z "$cmd" ] && cmd=$(command -v buildah)
[ -z "$cmd" ] && cmd=$(command -v docker)
if [ -z "$cmd" ]; then
  echo "Missing container build tools podman/buildah/docker"
  exit 1
fi

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
