[ -z "$env" ] && env=sand

case "$env" in
  sand)
    ;;
  test)
    ;;
  prod)
    ;;
  *)
    echo "Invalid environment $env; only sand, test, prod accepted"
    exit 1
esac

VALUES="values-$env.yaml"
DEV_IMAGE_REGISTRY="acrmvmidevops.azurecr.io"
SAND_IMAGE_REGISTRY="acrmvmisand.azurecr.io"
TEST_IMAGE_REGISTRY="acrmvmitest.azurecr.io"
PROD_IMAGE_REGISTRY="acrmvmiprod.azurecr.io"
