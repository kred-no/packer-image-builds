#!/usr/bin/env bash
set -eu

log(){
  printf "[%s] %s\n" "$(date -u)" "$1"
}

########################
## Validation
########################

log "Validating environment"

if [ -z "jdbc_version" ]; then log "Please set the 'jdbc_version' variable";exit 1;fi
if [ -z "activemq_version" ]; then log "Please set the 'activemq_version' variable";exit 1; fi

########################
## Environment
########################

TEMPDIR=${tmpdir:-"/tmp"}
PG_VERSION=${postgres_jdbc_version:-"42.7.3"}
ACTIVEMQ_VERSION=${activemq_version:-"6.1.2"}

########################
## Initialize
########################

log "Installing OS packages"

echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
apt-get update
apt-get -qqy install apt-utils > /dev/null 2>&1
apt-get -qqy install unzip curl tar

########################
## Download Postgres
########################

PG_URL="https://repo1.maven.org/maven2/org/postgresql/postgresql/${PG_VERSION}/postgresql-${PG_VERSION}.jar"
PG_FILENAME="postgresql.jar"

pushd ${TEMPDIR}
log "[Postgres-JDBC] Processing v${PG_VERSION}"

curl --silent --retry 3 -L "${PG_URL}.sha1" -o "${PG_FILENAME}.sha1"

if [[ -f "${PG_FILENAME}" ]]; then
  log "[Postgres-JDBC] Validating existing file"
  if ! echo "$(cat ${PG_FILENAME}.sha1|cut -d' ' -f1) ${PG_FILENAME}" | sha1sum -c - > /dev/null 2>&1; then
    log "[Postgres-JDBC] Checksum mismatch; removing cached file"
    rm -f ./${PG_FILENAME}
  fi
fi

if [[ ! -f "${PG_FILENAME}" ]]; then
  log "[Postgres-JDBC] Downloading archive"
  curl --silent --retry 3 -L "${PG_URL}" -o ${PG_FILENAME}
  if ! echo "$(cat ${PG_FILENAME}.sha1|cut -d' ' -f1) ${PG_FILENAME}" | sha1sum -c - > /dev/null 2>&1; then
    log "[Postgres-JDBC] Checksum Failed"
    exit 1
  fi
fi

log "[Postgres-JDBC] Checksum OK; Finished"
popd

########################
## Download ActiveMQ
########################

ACTIVEMQ_URL="https://archive.apache.org/dist/activemq/${ACTIVEMQ_VERSION}/apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz"
ACTIVEMQ_FILENAME="apache-activemq-bin.tar.gz"

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
## Provisioning
########################

ACTIVEMQ_HOME=/opt/activemq
ACTIVEMQ_USER=activemq

log "Extracting ActiveMQ files"

mkdir -p ${ACTIVEMQ_HOME}
tar -xzf ${TEMPDIR}/apache-activemq-bin.tar.gz --strip-components=1 -C ${ACTIVEMQ_HOME}
rm -rf ${TEMPDIR}/apache-activemq-bin.tar.gz

log "Configuring ActiveMQ defaults"

sed -i 's/127.0.0.1/0.0.0.0/g' "${ACTIVEMQ_HOME}/conf/jetty.xml"
sed -i 's/127.0.0.1/0.0.0.0/g' "${ACTIVEMQ_HOME}/conf/activemq.xml"

# v5.x.x
if [[ -f "${ACTIVEMQ_HOME}/bin/env" ]];then
  sed -ri 's/^(\s*)ACTIVEMQ_OPTS_MEMORY=(.*)/\1ACTIVEMQ_OPTS_MEMORY="-XX:MaxRAMPercentage=85.0 -XX:InitialRAMPercentage=85.0 -XX:+ExitOnOutOfMemoryError"/g' "${ACTIVEMQ_HOME}/bin/env"
fi

# v6.x.x
if [[ -f "${ACTIVEMQ_HOME}/bin/setenv" ]]; then
  sed -ri 's/^(\s*)ACTIVEMQ_OPTS_MEMORY=(.*)/\1ACTIVEMQ_OPTS_MEMORY="-XX:MaxRAMPercentage=85.0 -XX:InitialRAMPercentage=85.0 -XX:+ExitOnOutOfMemoryError"/g' "${ACTIVEMQ_HOME}/bin/setenv"
fi

########################
## Extra Drivers
########################

log "Adding Postgres driver"

mkdir -p ${ACTIVEMQ_HOME}/lib/optional
mv ${TEMPDIR}/postgresql.jar ${ACTIVEMQ_HOME}/lib/optional/

########################
## ActiveMQ Users & Permissions
########################

log "Creating ActiveMQ user"

useradd --comment "ActiveMQ user" --base-dir /home --home-dir ${ACTIVEMQ_HOME} --no-create-home --system --user-group ${ACTIVEMQ_USER}
chown -R ${ACTIVEMQ_USER}:${ACTIVEMQ_USER} ${ACTIVEMQ_HOME}

########################
## Cleanup
########################

apt-get -qqy autoclean

rm -rf /var/lib/apt/lists/* 
rm -rf /tmp/*

exit 0
