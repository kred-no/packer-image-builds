#!/usr/bin/env bash
set -e

VERSION_MAJOR=${activemq_major:-'6'}
VERSION_MINOR=${activemq_minor:-'1'}
VERSION_PATCH=${activemq_patch:-'2'}
VERSION_FULL="${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}"

VERSION=${activemq_version:-${VERSION_FULL}}

log(){
  printf "[%s] %s\n" "$(date -u)" "$1"
}

# //////////////////////
# // Download JDBC
# //////////////////////

URL="https://repo1.maven.org/maven2/org/apache/activemq/activemq-rar/${VERSION}/activemq-rar-${VERSION}.rar"

log "[ActiveMQ] Processing v${VERSION}"
curl --silent --retry 3 -L "${URL}.sha1" -o "activemq-rar.rar.sha1"

if [[ -f "./activemq-rar.rar" ]]; then
  log "[ActiveMQ] Validating existing file"
  if ! echo "$(cat ./activemq-rar.rar.sha1|cut -d' ' -f1) activemq-rar.rar" | sha1sum -c - > /dev/null 2>&1; then
    log "[ActiveMQ] Checksum mismatch; removing cached file"
    rm -f ./activemq-rar.rar
  fi
fi

if [[ ! -f "./activemq-rar.rar" ]]; then
  log "[ActiveMQ] Downloading archive"
  curl --silent --retry 3 -L "${URL}" -o activemq-rar.rar
  if ! echo "$(cat ./activemq-rar.rar.sha1|cut -d' ' -f1) activemq-rar.rar" | sha1sum -c - > /dev/null 2>&1; then
    log "[ActiveMQ] Checksum Failed"
    exit 1
  fi
fi

log "[ActiveMQ] Checksum OK; Finished"

# //////////////////////
# // Done
# //////////////////////

exit 0