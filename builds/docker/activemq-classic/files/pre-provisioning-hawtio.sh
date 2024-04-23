#!/usr/bin/env bash
set -eu

log(){
  printf "[%s] %s\n" "$(date -u)" "$1"
}

# Validation
if [ -z "hawtio_version" ]; then echo "Please set the 'hawtio_version' variable";exit 1; fi

# Environment

hawtio_url="https://repo1.maven.org/maven2/io/hawt/hawtio-default/${hawtio_version}/hawtio-default-${hawtio_version}.war"
hawtio_filename="hawtio-default"

# //////////////////////
# // Download HawtIO
# //////////////////////

log "[HawtIO] Processing v${hawtio_version}"

curl --silent --retry 3 -L "${hawtio_url}.sha1" -o "${hawtio_filename}.sha1"

if [[ -f "${hawtio_filename}.war" ]]; then
  log "[HawtIO] Validating existing file"
  if ! echo "$(cat ${hawtio_filename}.sha1|cut -d' ' -f1) ${hawtio_filename}.war" | sha1sum -c - > /dev/null 2>&1; then
    log "[HawtIO] Checksum mismatch; removing cached file"
    rm -f ./${hawtio_filename}.war
  fi
fi

if [[ ! -f "${hawtio_filename}.war" ]]; then
  log "[HawtIO] Downloading archive"
  curl --silent --retry 3 -L "${hawtio_url}" -o ${hawtio_filename}.war
  if ! echo "$(cat ${hawtio_filename}.sha1|cut -d' ' -f1) ${hawtio_filename}.war" | sha1sum -c - > /dev/null 2>&1; then
    log "[HawtIO] Checksum Failed"
    exit 1
  fi
fi

log "[HawtIO] Checksum OK; Finished"

# //////////////////////
# // Done
# //////////////////////
