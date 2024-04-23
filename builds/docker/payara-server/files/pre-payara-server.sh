#!/usr/bin/env bash
set -e

VERSION_MAJOR=${payara_major:-'6'}
VERSION_MINOR=${payara_minor:-'2024'}
VERSION_PATCH=${payara_patch:-'4'}
VERSION_FULL="${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}"

VERSION=${payara_version:-${VERSION_FULL}}

log(){
  printf "[%s] %s\n" "$(date -u)" "$1"
}

# Download Payara Server
PAYARA_URL=https://nexus.payara.fish/repository/payara-community/fish/payara/distributions/payara/${VERSION}/payara-${VERSION}.zip

log "[Payara] Processing v${VERSION}"
curl --silent --retry 3  -L "${PAYARA_URL}.sha1" -o "payara.zip.sha1"

if [[ -f "payara.zip" ]]; then
  log "[Payara] Validating Existing File"
  if ! echo "$(cat ./payara.zip.sha1|cut -d' ' -f1) payara.zip" | sha1sum -c - > /dev/null 2>&1; then
    log "[Payara] Checksum Mismatch; Removing Cached File"
    rm -f ./payara.zip
  fi
fi

if [[ ! -f "payara.zip" ]]; then
  log "[Payara] Downloading Archive"
  curl --silent --retry 3 -L "${PAYARA_URL}" -o payara.zip
  if ! echo "$(cat ./payara.zip.sha1|cut -d' ' -f1) payara.zip" | sha1sum -c - > /dev/null 2>&1; then
    log "[Payara] Checksum Validation Failed!"
    exit 1
  fi
fi

log "[Payara] Checksum OK; Finished!"

exit 0
