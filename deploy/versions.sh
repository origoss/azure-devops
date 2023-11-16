#!/bin/bash

echo -n "Date: " ; date
echo -n "Uptime: " ; uptime
echo -n "System: " ; uname -a
echo -n "UID/GID: " ; id
echo -n "podman version: " ; podman --version
echo -n "buildah version: " ; buildah --version
echo -n "skopeo version: " ; skopeo --version
echo -n "jq version: " ; jq --version
echo -n "helm version: " ; helm version --short
echo -n "oc version: " ; oc version --client
