#!/bin/bash
set -eux

########################
## ISSUE: https://github.com/payara/Payara/issues/2267
## Append hostname to hostsfile on startup
# Requires root
########################
#echo 127.0.0.1 `cat /etc/hostname` | tee -a /etc/hosts

########################
## Run Scripts (non-root)
########################

for f in ${SCRIPT_DIR}/init_* ${SCRIPT_DIR}/init.d/*; do
  case "${f}" in
    *.sh)  echo "[Entrypoint] running ${f}"; . "${f}" ;;
    *)     echo "[Entrypoint] ignoring ${f}" ;;
  esac
  echo
done

exec ${SCRIPT_DIR}/startInForeground.sh ${PAYARA_ARGS}
