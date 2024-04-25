#!/bin/bash
set -eux

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

log "Running custom scripts"
for f in ${SCRIPT_DIR}/init_* ${SCRIPT_DIR}/init.d/*; do
  case "${f}" in
    *.sh)  echo "[Entrypoint] running ${f}"; . "${f}" ;;
    *)     echo "[Entrypoint] ignoring ${f}" ;;
  esac
  echo
done

########################
## Add Deployments
########################

log "Creating deployment directory, if missing"
mkdir -p ${DEPLOY_DIR}

# Define function for appending deployments to postboot-command-file
deploy() {
  # Check if input is empty
  if [ -z ${1} ]; then
    log "Nothing to deploy"
    return 0;
  fi

  # Check if command already exists in post-boot deployments
  if grep -q ${1} ${POSTBOOT_COMMANDS}; then
    log "Ignoring already included deployment: ${1}"
  else
    log "Appending deployment to postboot-commands: ${1}"
    echo "deploy ${DEPLOY_PROPS} ${1}" | tee -a ${POSTBOOT_COMMANDS}
  fi
}

# Check for rar-files/folders to deploy first
log "Adding rar-deployments to post-boot (files/folders)"
for deployment in $(find ${DEPLOY_DIR} -mindepth 1 -maxdepth 1 -name "*.rar"); do
  deploy ${deployment}
done

# Check for war, jar, ear-files or directory to deploy (exluding *.rar files/folders)
log "Deploying other deployments to post-boot (files/folders)"
for deployment in $(find ${DEPLOY_DIR} -mindepth 1 -maxdepth 1 ! -name "*.rar" -a -name "*.war" -o -name "*.ear" -o -name "*.jar" -o -type d); do
  deploy ${deployment}
done

########################
## Start Payara Server
########################

exec ${SCRIPT_DIR}/startInForeground.sh ${PAYARA_ARGS}
