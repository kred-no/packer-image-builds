#!/usr/bin/env bash
set -eu

log(){
  printf "[%s] %s\n" "$(date -u)" "$1"
}

# Validation
if [ -z "activemq_version" ]; then log "Please set the 'activemq_version' variable";exit 1; fi

tempdir="./cache"
mkdir -p ${tempdir}
pushd ${tempdir}

# //////////////////////
# // Download ActiveMQ
# //////////////////////

activemq_url="https://archive.apache.org/dist/activemq/${activemq_version}/apache-activemq-${activemq_version}-bin.tar.gz"
activemq_filename="apache-activemq"

log "[ActiveMQ] Processing v${activemq_version} -> ${tempdir}"
curl --silent --retry 3  -L "${activemq_url}.sha512" -o "${activemq_filename}.sha512"

if [[ -f "${activemq_filename}-bin.tar.gz" ]]; then
  log "[ActiveMQ] Validating existing file"
  if ! echo "$(cat ${activemq_filename}.sha512|cut -d' ' -f1) ${activemq_filename}-bin.tar.gz" | sha512sum -c - > /dev/null 2>&1; then
    log "[ActiveMQ] Checksum mismatch; removing cached file"
    rm -f ./${activemq_filename}-bin.tar.gz
  fi
fi

if [[ ! -f "${activemq_filename}-bin.tar.gz" ]]; then
  log "[ActiveMQ] Downloading archive"
  curl --silent --retry 3 -L "${activemq_url}" -o ${activemq_filename}-bin.tar.gz
  if ! echo "$(cat ${activemq_filename}.sha512|cut -d' ' -f1) ${activemq_filename}-bin.tar.gz" | sha512sum -c - > /dev/null 2>&1; then
    log "[ActiveMQ] Checksum Failed"
    exit 1
  fi
fi

log "[ActiveMQ] Checksum OK; Finished!"

popd