#!/bin/bash

if [ -z "$IMAGE_REGISTRY" ]; then
  echo "Missing IMAGE_REGISTRY environment variable"
  exit 1
fi
if [ -z "$IMAGE_REPOSITORY" ]; then
  echo "Missing IMAGE_REPOSITORY environment variable"
  exit 1
fi
if [ -z "$IMAGE_TAG" ]; then
  echo "Missing IMAGE_TAG environment variable"
  exit 1
fi
if [ -z "$AUTHCONFIG" ]; then
  echo "Missing AUTHCONFIG environment variable"
  exit 1
fi
if [ ! -r "$AUTHCONFIG" ]; then
  echo "Cannot read destination auth config file $AUTHCONFIG"
  exit 1
fi
creds=$(jq -r '.auths["'"$IMAGE_REGISTRY"'"].auth // ""' < "$AUTHCONFIG" | base64 -d)
if [ -z "$creds" ]; then
  echo "Cannot find authentication data for $IMAGE_REGISTRY in auth config file $AUTHCONFIG"
  exit 1
fi

status=$(curl -s -D - --http1.1 -o /tmp/list -u "$creds" "https://${IMAGE_REGISTRY}/v2/${IMAGE_REPOSITORY}/tags/list")
rc=$?
if [ $rc -gt 0 ]; then
  echo "Image check ${IMAGE_REGISTRY}/${IMAGE_REPOSITORY} tag list failed with error code $rc: $status"
  exit 1
fi
http=$(echo "$status" | head -1 | awk '{ print $2 }')
if (( $http != 200 )); then
  echo "Image check ${IMAGE_REGISTRY}/${IMAGE_REPOSITORY} tag list failed: $status"
  exit 1
fi
find=$(jq -r '.tags[] | select(.=="'"${IMAGE_TAG}"'")' < /tmp/list)
if [ "$find" != "${IMAGE_TAG}" ]; then
  echo "Image check ${IMAGE_REGISTRY}/${IMAGE_REPOSITORY}:${IMAGE_TAG} failed: missing tag"
  exit 1
fi
