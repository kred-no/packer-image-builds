#!/bin/bash
set -eu

log(){
  printf "[%s] %s\n" "$(date -u)" "${1}"
}

########################
## ISSUE: https://github.com/payara/Payara/issues/2267
## Append hostname to hostsfile on startup
# Requires root
########################
#echo 127.0.0.1 `cat /etc/hostname` | tee -a /etc/hosts

########################
## Run Scripts (non-root)
########################

log "Executing scripts (non-root)"
for f in ${SCRIPT_DIR}/init_* ${SCRIPT_DIR}/init.d/*; do
  case "${f}" in
    *.sh)  echo "[Entrypoint] running ${f}"; . "${f}" ;;
    *)     echo "[Entrypoint] ignoring ${f}" ;;
  esac
  echo
done

########################
## Auto-Deployment
########################

log "Creating auto-deployment directory (${DEPLOY_DIR}), if missing"
mkdir -p ${DEPLOY_DIR}

# Append to postboot-commands
deploy() {
  # Empty Input
  if [ -z ${1} ]; then
    log "Nothing to deploy."
    return 0;
  fi

  # File (basename) already exists in post-boot
  if grep -q $(basename ${1}) ${POSTBOOT_COMMANDS}; then
    echo "Ignoring existing deployment (basename): ${1}"
    return 0
  fi

  echo "Appending to post-boot deploments: ${1}"
  printf "deploy %s %s\n" "${DEPLOY_PROPS}" "${1}" | tee -a ${POSTBOOT_COMMANDS}
}

# Check rar-files/folders
log "Checking for rar-deployments (files/folders)."
for deployment in $(find ${DEPLOY_DIR} -mindepth 1 -maxdepth 1 -name "*.rar"); do
  deploy ${deployment}
done

# Check war, jar, ear or directory to deploy (exluding *.rar files/folders)
log "Checking for other deployments (files/folders)."
for deployment in $(find ${DEPLOY_DIR} -mindepth 1 -maxdepth 1 ! -name "*.rar" -a -name "*.war" -o -name "*.ear" -o -name "*.jar" -o -type d); do
  deploy ${deployment}
done

########################
## Start Payara Server
########################

exec ${SCRIPT_DIR}/startInForeground.sh ${PAYARA_ARGS}
