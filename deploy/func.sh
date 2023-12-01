shopt -s nocasematch
if [[ "$DEBUG" = "" || "$DEBUG" == "no" || "$DEBUG" == "false" || "$DEBUG" = "0" ]]; then
  HELMDEBUG=()
else
  HELMDEBUG=(--debug -v 9)
  HELMVARS+=(--set 'debugging=true')
fi
if [ -n "$HELMWAIT" ]; then
  HELMPARAMS+=(--wait --timeout=$HELMWAIT)
fi

NAMESPACE="${NAMESPACE:-$DEFAULT_NAMESPACE}"
