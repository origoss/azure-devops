if [ -z "$NAMESPACE" ]; then
  echo "Missing NAMESPACE environment variable"
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
if [ -z "$APPS_DEFAULT_DOMAIN" ]; then
  echo "Missing APPS_DEFAULT_DOMAIN environment variable"
  exit 1
fi
if [ -z "$ROUTE_HOSTNAME" ]; then
  echo "Missing ROUTE_HOSTNAME environment variable"
  exit 1
fi

ROUTE_FQDN="${ROUTE_HOSTNAME}.${APPS_DEFAULT_DOMAIN}"

HELMPARAMS+=(--set "appdemo.name=$INSTANCE")
HELMPARAMS+=(--set "appdemo.image.prefix=$IMAGE_REGISTRY/")
HELMPARAMS+=(--set "appdemo.image.name=$IMAGE_REPOSITORY")
HELMPARAMS+=(--set "appdemo.image.tag=$IMAGE_TAG")
HELMPARAMS+=(--set "appdemo.route.host=$ROUTE_FQDN")
