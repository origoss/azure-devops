#!/bin/bash

dirname=$(dirname "$0")
dirname=$(readlink -f "$dirname")
cd "$dirname" || exit 1
basedir=$(readlink -f "$dirname/..")
chartsdir="$dirname/charts"

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
if [ -r "$basedir/func.sh" ]; then
  . "$basedir/func.sh" || exit 1
fi
if [ -r "$dirname/func.sh" ]; then
  . "$dirname/func.sh" || exit 1
fi
if [ -n "${CHECKIMAGE}" ]; then
  . "$basedir/checkimage.sh" || exit 1
fi
helm upgrade --install --reset-values -n "$NAMESPACE" --values "$VALUES" "${HELMVARS[@]}" "${HELMPARAMS[@]}" "$INSTANCE" "$chartsdir/$CHART" "${HELMDEBUG[@]}" "$@"
rc=$?
if [ "${#HELMDEBUG}" -gt 0 ]; then
  . "$basedir/kubedebug.sh"
fi
exit $rc
