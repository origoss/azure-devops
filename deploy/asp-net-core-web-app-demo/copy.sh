#!/bin/bash

dirname=$(dirname "$0")
dirname=$(readlink -f "$dirname")
cd "$dirname" || exit 1
basedir=$(readlink -f "$dirname/..")

if [ -r "$basedir/vars.sh" ]; then
  . "$basedir/vars.sh" || exit 1
fi
if [ -r "$dirname/vars.sh" ]; then
  . "$dirname/vars.sh" || exit 1
fi
if [ -r "$basedir/vars-$env.sh" ]; then
  . "$basedir/vars-$env.sh" || exit 1
fi
if [ -r "$dirname/vars-$env.sh" ]; then
  . "$dirname/vars-$env.sh" || exit 1
fi

if [ -z "$SOURCE_IMAGE_REGISTRY" ]; then
  echo "Missing SOURCE_IMAGE_REGISTRY environment variable"
  exit 1
fi
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
if [ -z "$SOURCE_AUTHCONFIG" ]; then
  echo "Missing SOURCE_AUTHCONFIG environment variable"
  exit 1
fi
if [ -z "$AUTHCONFIG" ]; then
  echo "Missing AUTHCONFIG environment variable"
  exit 1
fi
if [ -z "$POLICY_CONFIG" ]; then
  echo "Missing POLICY_CONFIG environment variable"
  exit 1
fi
if [ ! -r "$SOURCE_AUTHCONFIG" ]; then
  echo "Cannot read source auth config file $SOURCE_AUTHCONFIG"
  exit 1
fi
if [ ! -r "$AUTHCONFIG" ]; then
  echo "Cannot read destination auth config file $AUTHCONFIG"
  exit 1
fi
if [ ! -r "$POLICY_CONFIG" ]; then
  echo "Cannot read policy config file $POLICY_CONFIG"
  exit 1
fi

SOURCE_IMAGE="${SOURCE_IMAGE_REGISTRY}/${IMAGE_REPOSITORY}:${IMAGE_TAG}"
DESTINATION_IMAGE="${IMAGE_REGISTRY}/${IMAGE_REPOSITORY}:${IMAGE_TAG}"

skopeo copy --all --src-authfile "$SOURCE_AUTHCONFIG" --dest-authfile "$AUTHCONFIG" \
  --policy "$POLICY_CONFIG" "docker://$SOURCE_IMAGE" "docker://$DESTINATION_IMAGE" "$@"
