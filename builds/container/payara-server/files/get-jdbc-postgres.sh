#!/usr/bin/env bash
set -e

OUTDIR=${outdir:-"/tmp"}
VERSION_MAJOR=${postgres_jdbc_major:-'42'}
VERSION_MINOR=${postgres_jdbc_minor:-'7'}
VERSION_PATCH=${postgres_jdbc_patch:-'3'}
VERSION_FULL="${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}"

VERSION=${postgres_jdbc_version:-${VERSION_FULL}}


log(){
  printf "[%s] %s\n" "$(date -u)" "$1"
}

# //////////////////////
# // Download JDBC
# //////////////////////

POSTGRES_JDBC_URL="https://repo1.maven.org/maven2/org/postgresql/postgresql/${VERSION}/postgresql-${VERSION}.jar"

pushd ${OUTDIR}
log "[Postgres-JDBC] Processing v${VERSION}"

curl --silent --retry 3 -L "${POSTGRES_JDBC_URL}.sha1" -o "postgres.sha1"

if [[ -f "./postgres.jar" ]]; then
  log "[Postgres-JDBC] Validating existing file"
  if ! echo "$(cat ./postgres.sha1|cut -d' ' -f1) postgres.jar" | sha1sum -c - > /dev/null 2>&1; then
    log "[Postgres-JDBC] Checksum mismatch; removing cached file"
    rm -f ./postgres.jar
  fi
fi

if [[ ! -f "./postgres.jar" ]]; then
  log "[Postgres-JDBC] Downloading archive"
  curl --silent --retry 3 -L "${POSTGRES_JDBC_URL}" -o postgres.jar
  if ! echo "$(cat ./postgres.sha1|cut -d' ' -f1) postgres.jar" | sha1sum -c - > /dev/null 2>&1; then
    log "[Postgres-JDBC] Checksum Failed"
    exit 1
  fi
fi

log "[Postgres-JDBC] Checksum OK; Finished"
popd

# //////////////////////
# // Done
# //////////////////////

exit 0