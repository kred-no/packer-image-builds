#!/usr/bin/env bash
set -eu

log () {
  printf "[%s] %s\n" "$(date -u)" "${1}"
}

########################
## Environment
########################

TEMPDIR=${tmpdir:-"/tmp"}
ACTIVEMQ_HOME=/opt/activemq
ACTIVEMQ_USER=activemq

########################
## Validation
########################

if [ ! -f "${TEMPDIR}/apache-activemq-bin.tar.gz" ];then log "Missing ActiveMQ installer!";exit 1;fi
if [ ! -f "${TEMPDIR}/postgresql.jar" ];then log "Missing Postgres JDBC driver!";exit 1;fi

########################
## ActiveMQ Installation
########################

log "Extracting ActiveMQ"

mkdir -p ${ACTIVEMQ_HOME}
tar -xzf ${TEMPDIR}/apache-activemq-bin.tar.gz --strip-components=1 -C ${ACTIVEMQ_HOME}
rm -rf ${TEMPDIR}/apache-activemq-bin.tar.gz

########################
## Update Default Config
########################

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
## Drivers
########################

log "Adding ActiveMQ drivers"

mkdir -p ${ACTIVEMQ_HOME}/lib/optional
mv ${TEMPDIR}/postgresql.jar ${ACTIVEMQ_HOME}/lib/optional/

########################
## Users & Permissions
########################

log "Creating ActiveMQ user"

useradd --comment "ActiveMQ user" --base-dir /home --home-dir ${ACTIVEMQ_HOME} --no-create-home --system --user-group ${ACTIVEMQ_USER}
chown -R ${ACTIVEMQ_USER}:${ACTIVEMQ_USER} ${ACTIVEMQ_HOME}

########################
## Done!
########################

exit 0
