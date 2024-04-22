#!/usr/bin/env bash
set -eu

log(){
  printf "[%s] %s\n" "$(date -u)" "$1"
}

# Validation
if [ -z "jdbc_version" ]; then echo "Please set the 'jdbc_version' variable";exit 1;fi

tempdir=${temp_folder:-"./cache"}
mkdir -p ${tempdir}
pushd ${tempdir}

# //////////////////////
# // Download Postgres JDBC
# //////////////////////

jdbc_url="https://repo1.maven.org/maven2/org/postgresql/postgresql/${jdbc_version}/postgresql-${jdbc_version}.jar"
jdbc_filename="postgresql"

log "[Postgres-JDBC] Processing v${jdbc_version}"

curl --silent --retry 3 -L "${jdbc_url}.sha1" -o "${jdbc_filename}.sha1"

if [[ -f "${jdbc_filename}.jar" ]]; then
  log "[Postgres-JDBC] Validating existing file"
  if ! echo "$(cat ${jdbc_filename}.sha1|cut -d' ' -f1) ${jdbc_filename}.jar" | sha1sum -c - > /dev/null 2>&1; then
    log "[Postgres-JDBC] Checksum mismatch; removing cached file"
    rm -f ./${jdbc_filename}.jar
  fi
fi

if [[ ! -f "${jdbc_filename}.jar" ]]; then
  log "[Postgres-JDBC] Downloading archive"
  curl --silent --retry 3 -L "${jdbc_url}" -o ${jdbc_filename}.jar
  if ! echo "$(cat ${jdbc_filename}.sha1|cut -d' ' -f1) ${jdbc_filename}.jar" | sha1sum -c - > /dev/null 2>&1; then
    log "[Postgres-JDBC] Checksum Failed"
    exit 1
  fi
fi

log "[Postgres-JDBC] Checksum OK; Finished"

# //////////////////////
# // Done
# //////////////////////

popd