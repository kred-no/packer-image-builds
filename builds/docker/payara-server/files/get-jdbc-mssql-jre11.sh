#!/usr/bin/env bash
set -e

OUTDIR=${outdir:-"/tmp"}
VERSION_MAJOR=${mssql_jdbc_major:-'12'}
VERSION_MINOR=${mssql_jdbc_minor:-'6'}
VERSION_PATCH=${mssql_jdbc_patch:-'1'}
VERSION_FULL="${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}"

VERSION=${mssql_jdbc_version:-${VERSION_FULL}}

log(){
  printf "[%s] %s\n" "$(date -u)" "$1"
}

# //////////////////////
# // Download JDBC
# //////////////////////

URL="https://repo1.maven.org/maven2/com/microsoft/sqlserver/mssql-jdbc/${VERSION}.jre11/mssql-jdbc-${VERSION}.jre11.jar"

pushd ${OUTDIR}
log "[MSSQL-JDBC] Processing v${VERSION}"

curl --silent --retry 3 -L "${URL}.sha1" -o "mssql.jar.sha1"

if [[ -f "./mssql.jar" ]]; then
  log "[MMSQL-JDBC] Validating existing file"
  if ! echo "$(cat ./mssql.jar.sha1|cut -d' ' -f1) mssql.jar" | sha1sum -c - > /dev/null 2>&1; then
    log "[MMSQL-JDBC] Checksum mismatch; removing cached file"
    rm -f ./mssql.jar
  fi
fi

if [[ ! -f "./mssql.jar" ]]; then
  log "[MMSQL-JDBC] Downloading archive"
  curl --silent --retry 3 -L "${URL}" -o mssql.jar
  if ! echo "$(cat ./mssql.jar.sha1|cut -d' ' -f1) mssql.jar" | sha1sum -c - > /dev/null 2>&1; then
    log "[MMSQL-JDBC] Checksum Failed"
    exit 1
  fi
fi

log "[MMSQL-JDBC] Checksum OK; Finished"
popd

# //////////////////////
# // Done
# //////////////////////

exit 0