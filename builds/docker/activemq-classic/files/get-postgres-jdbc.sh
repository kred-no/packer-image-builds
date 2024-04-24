#!/usr/bin/env bash
set -eu

log(){
  printf "[%s] %s\n" "$(date -u)" "$1"
}

########################
## Validation
########################

if [ -z "jdbc_version" ]; then echo "Please set the 'jdbc_version' variable";exit 1;fi

########################
## Environment
########################

TEMPDIR=${tmpdir:-"/tmp"}
VERSION=${postgres_jdbc_version:-"42.7.3"}
URL="https://repo1.maven.org/maven2/org/postgresql/postgresql/${VERSION}/postgresql-${VERSION}.jar"
FILENAME="postgresql.jar"

########################
## Download JDBC
########################

pushd ${TEMPDIR}
log "[Postgres-JDBC] Processing v${VERSION}"

curl --silent --retry 3 -L "${URL}.sha1" -o "${FILENAME}.sha1"

if [[ -f "${FILENAME}" ]]; then
  log "[Postgres-JDBC] Validating existing file"
  if ! echo "$(cat ${FILENAME}.sha1|cut -d' ' -f1) ${FILENAME}" | sha1sum -c - > /dev/null 2>&1; then
    log "[Postgres-JDBC] Checksum mismatch; removing cached file"
    rm -f ./${FILENAME}
  fi
fi

if [[ ! -f "${FILENAME}" ]]; then
  log "[Postgres-JDBC] Downloading archive"
  curl --silent --retry 3 -L "${URL}" -o ${FILENAME}
  if ! echo "$(cat ${FILENAME}.sha1|cut -d' ' -f1) ${FILENAME}" | sha1sum -c - > /dev/null 2>&1; then
    log "[Postgres-JDBC] Checksum Failed"
    exit 1
  fi
fi

log "[Postgres-JDBC] Checksum OK; Finished"
popd

########################
## Done
########################

exit 0
