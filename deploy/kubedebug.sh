#!/bin/bash

echo "Node info:"
oc get node --show-labels

echo "Namespace $NAMESPACE objects:"
oc get -n "$NAMESPACE" all,pvc

oc describe -n "$NAMESPACE" all,pvc

echo "Logs:"
for labelselector in "${LSLIST[@]}"; do
  oc logs -n "$NAMESPACE" -l "$labelselector" --all-containers --tail=-1
done
