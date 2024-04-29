#!/usr/bin/env bash
set -eu

log(){
  printf "[%s] %s\n" "$(date -u)" "$1"
}

########################
## Validation
########################

if [ -z "activemq_version" ]; then log "Please set the 'activemq_version' variable";exit 1; fi

########################
## Environment
########################

TEMPDIR=${tmpdir:-"/tmp"}
ACTIVEMQ_VERSION=${activemq_version:-"6.1.2"}

ACTIVEMQ_URL="https://archive.apache.org/dist/activemq/${ACTIVEMQ_VERSION}/apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz"
ACTIVEMQ_FILENAME="apache-activemq-bin.tar.gz"

########################
## Download ActiveMQ
########################

pushd ${TEMPDIR}
log "[ActiveMQ] Processing v${ACTIVEMQ_VERSION}"

curl --silent --retry 3  -L "${ACTIVEMQ_URL}.sha512" -o "${ACTIVEMQ_FILENAME}.sha512"

if [[ -f "${ACTIVEMQ_FILENAME}" ]]; then
  log "[ActiveMQ] Validating existing file"
  if ! echo "$(cat ${ACTIVEMQ_FILENAME}.sha512|cut -d' ' -f1) ${ACTIVEMQ_FILENAME}" | sha512sum -c - > /dev/null 2>&1; then
    log "[ActiveMQ] Checksum mismatch; removing cached file"
    rm -f ./${ACTIVEMQ_FILENAME}
  fi
fi

if [[ ! -f "${ACTIVEMQ_FILENAME}" ]]; then
  log "[ActiveMQ] Downloading archive"
  curl --silent --retry 3 -L "${ACTIVEMQ_URL}" -o ${ACTIVEMQ_FILENAME}
  if ! echo "$(cat ${ACTIVEMQ_FILENAME}.sha512|cut -d' ' -f1) ${ACTIVEMQ_FILENAME}" | sha512sum -c - > /dev/null 2>&1; then
    log "[ActiveMQ] Checksum Failed"
    exit 1
  fi
fi

log "[ActiveMQ] Checksum OK; Finished!"
popd

########################
## Done
########################

exit 0
